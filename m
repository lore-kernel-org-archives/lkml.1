Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZHQMLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZHQMLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZHQMLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:11:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49351 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZHQMLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:11:37 -0400
Date: Mon, 17 Aug 2009 14:11:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com, Trond.Myklebust@netapp.com
Subject: Re: [PATCH 1/3] direct-io: make O_DIRECT IO path be page based
Message-ID: <20090817121137.GW12579@kernel.dk>
References: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com> <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17 2009, Jens Axboe wrote:
> Switch the aops->direct_IO() and below code to use page arrays
> instead, so that it doesn't make any assumptions about who the pages
> belong to. This works directly for all users but NFS, which just
> uses the same helper that the generic mapping read/write functions
> also call.

A quick NFS test reveals a simple problem - it wants to free the
pagevec on IO completion, but for O_DIRECT it should not do that anymore
since it'll simply inherit the given page map.

There's a flag structure in the nfs_{read,write}_data structure, but I
was not able to find out which flags (if any?!) it actually uses. So I
just stuck an int in there. Trond?

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index aff6169..2913caf 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -302,7 +302,7 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 		bytes = min(rsize,count);
 
 		result = -ENOMEM;
-		data = nfs_readdata_alloc(nfs_page_array_len(pgbase, bytes));
+		data = nfs_readdata_alloc(nfs_page_array_len(pgbase, bytes), 0);
 		if (unlikely(!data))
 			break;
 
@@ -699,7 +699,7 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 		bytes = min(wsize,count);
 
 		result = -ENOMEM;
-		data = nfs_writedata_alloc(nfs_page_array_len(pgbase, bytes));
+		data = nfs_writedata_alloc(nfs_page_array_len(pgbase, bytes),0);
 		if (unlikely(!data))
 			break;
 
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 12c9e66..86f96a4 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -38,7 +38,8 @@ static mempool_t *nfs_rdata_mempool;
 
 #define MIN_POOL_READ	(32)
 
-struct nfs_read_data *nfs_readdata_alloc(unsigned int pagecount)
+struct nfs_read_data *nfs_readdata_alloc(unsigned int pagecount,
+					 int need_pagevec)
 {
 	struct nfs_read_data *p = mempool_alloc(nfs_rdata_mempool, GFP_NOFS);
 
@@ -47,9 +48,11 @@ struct nfs_read_data *nfs_readdata_alloc(unsigned int pagecount)
 		INIT_LIST_HEAD(&p->pages);
 		p->npages = pagecount;
 		p->res.seq_res.sr_slotid = NFS4_MAX_SLOT_TABLE;
-		if (pagecount <= ARRAY_SIZE(p->page_array))
+		if (!need_pagevec || pagecount <= ARRAY_SIZE(p->page_array)) {
 			p->pagevec = p->page_array;
-		else {
+			p->free_pagevec = 0;
+		} else {
+			p->free_pagevec = 1;
 			p->pagevec = kcalloc(pagecount, sizeof(struct page *), GFP_NOFS);
 			if (!p->pagevec) {
 				mempool_free(p, nfs_rdata_mempool);
@@ -62,7 +65,7 @@ struct nfs_read_data *nfs_readdata_alloc(unsigned int pagecount)
 
 void nfs_readdata_free(struct nfs_read_data *p)
 {
-	if (p && (p->pagevec != &p->page_array[0]))
+	if (p && p->free_pagevec)
 		kfree(p->pagevec);
 	mempool_free(p, nfs_rdata_mempool);
 }
@@ -256,7 +259,7 @@ static int nfs_pagein_multi(struct inode *inode, struct list_head *head, unsigne
 	do {
 		size_t len = min(nbytes,rsize);
 
-		data = nfs_readdata_alloc(1);
+		data = nfs_readdata_alloc(1, 1);
 		if (!data)
 			goto out_bad;
 		list_add(&data->pages, &list);
@@ -306,7 +309,7 @@ static int nfs_pagein_one(struct inode *inode, struct list_head *head, unsigned
 	struct nfs_read_data	*data;
 	int ret = -ENOMEM;
 
-	data = nfs_readdata_alloc(npages);
+	data = nfs_readdata_alloc(npages, 1);
 	if (!data)
 		goto out_bad;
 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index a34fae2..defb266 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -60,12 +60,13 @@ struct nfs_write_data *nfs_commitdata_alloc(void)
 
 void nfs_commit_free(struct nfs_write_data *p)
 {
-	if (p && (p->pagevec != &p->page_array[0]))
+	if (p && p->free_pagevec)
 		kfree(p->pagevec);
 	mempool_free(p, nfs_commit_mempool);
 }
 
-struct nfs_write_data *nfs_writedata_alloc(unsigned int pagecount)
+struct nfs_write_data *nfs_writedata_alloc(unsigned int pagecount,
+					   int need_pagevec)
 {
 	struct nfs_write_data *p = mempool_alloc(nfs_wdata_mempool, GFP_NOFS);
 
@@ -74,9 +75,11 @@ struct nfs_write_data *nfs_writedata_alloc(unsigned int pagecount)
 		INIT_LIST_HEAD(&p->pages);
 		p->npages = pagecount;
 		p->res.seq_res.sr_slotid = NFS4_MAX_SLOT_TABLE;
-		if (pagecount <= ARRAY_SIZE(p->page_array))
+		if (!need_pagevec || pagecount <= ARRAY_SIZE(p->page_array)) {
 			p->pagevec = p->page_array;
-		else {
+			p->free_pagevec = 0;
+		} else {
+			p->free_pagevec = 1;
 			p->pagevec = kcalloc(pagecount, sizeof(struct page *), GFP_NOFS);
 			if (!p->pagevec) {
 				mempool_free(p, nfs_wdata_mempool);
@@ -89,7 +92,7 @@ struct nfs_write_data *nfs_writedata_alloc(unsigned int pagecount)
 
 void nfs_writedata_free(struct nfs_write_data *p)
 {
-	if (p && (p->pagevec != &p->page_array[0]))
+	if (p && p->free_pagevec)
 		kfree(p->pagevec);
 	mempool_free(p, nfs_wdata_mempool);
 }
@@ -904,7 +907,7 @@ static int nfs_flush_multi(struct inode *inode, struct list_head *head, unsigned
 	do {
 		size_t len = min(nbytes, wsize);
 
-		data = nfs_writedata_alloc(1);
+		data = nfs_writedata_alloc(1, 1);
 		if (!data)
 			goto out_bad;
 		list_add(&data->pages, &list);
@@ -960,7 +963,7 @@ static int nfs_flush_one(struct inode *inode, struct list_head *head, unsigned i
 	struct page		**pages;
 	struct nfs_write_data	*data;
 
-	data = nfs_writedata_alloc(npages);
+	data = nfs_writedata_alloc(npages, 1);
 	if (!data)
 		goto out_bad;
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index dab9bf9..946317c 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -498,7 +498,7 @@ nfs_have_writebacks(struct inode *inode)
 /*
  * Allocate nfs_write_data structures
  */
-extern struct nfs_write_data *nfs_writedata_alloc(unsigned int npages);
+extern struct nfs_write_data *nfs_writedata_alloc(unsigned int npages, int);
 extern void nfs_writedata_free(struct nfs_write_data *);
 
 /*
@@ -514,7 +514,7 @@ extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
 /*
  * Allocate nfs_read_data structures
  */
-extern struct nfs_read_data *nfs_readdata_alloc(unsigned int npages);
+extern struct nfs_read_data *nfs_readdata_alloc(unsigned int npages, int);
 extern void nfs_readdata_free(struct nfs_read_data *);
 
 /*
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 62f63fb..45dd955 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -954,6 +954,7 @@ struct nfs_read_data {
 	struct nfs_page		*req;	/* multi ops per nfs_page */
 	struct page		**pagevec;
 	unsigned int		npages;	/* Max length of pagevec */
+	int			free_pagevec;	/* free ->pagevec */
 	struct nfs_readargs args;
 	struct nfs_readres  res;
 #ifdef CONFIG_NFS_V4
@@ -973,6 +974,7 @@ struct nfs_write_data {
 	struct nfs_page		*req;		/* multi ops per nfs_page */
 	struct page		**pagevec;
 	unsigned int		npages;		/* Max length of pagevec */
+	int			free_pagevec;	/* free ->pagevec */
 	struct nfs_writeargs	args;		/* argument struct */
 	struct nfs_writeres	res;		/* result struct */
 #ifdef CONFIG_NFS_V4

-- 
Jens Axboe

