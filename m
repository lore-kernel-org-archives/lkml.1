Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZEMGhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZEMGhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZEMGhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:37:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48599 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZEMGhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:37:07 -0400
Date: Wed, 13 May 2009 08:37:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Max Kellermann <max@duempel.org>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] splice: implement default splice_read method
Message-ID: <20090513063707.GC4140@kernel.dk>
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512223500.d7ef4648.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12 2009, Andrew Morton wrote:
> On Thu, 07 May 2009 15:37:36 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > +	for (i = 0; i < spd.nr_pages; i++) {
> > +		kunmap(pages[i]);
> 
> It is deadlockable if any thread of control holds more than a single
> kmap at a time.
> 
> Because there are a finite number of kmaps available, and if one is
> unavailable, kmap() waits for one to become free.  If the number of
> waiting threads equals the number of available slots, nobody makes any
> progress.

Good catch, that will not work reliably. I've applied the below.

commit 4f23122858a27ba97444b9b37a066d83edebd4c8
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed May 13 08:35:35 2009 +0200

    splice: fix repeated kmap()'s in default_file_splice_read()
    
    We cannot reliably map more than one page at the time, or we risk
    deadlocking. Just allocate the pages from low mem instead.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/splice.c b/fs/splice.c
index eefd96b..c5e3c79 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -580,13 +580,13 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	for (i = 0; i < nr_pages && i < PIPE_BUFFERS && len; i++) {
 		struct page *page;
 
-		page = alloc_page(GFP_HIGHUSER);
+		page = alloc_page(GFP_USER);
 		error = -ENOMEM;
 		if (!page)
 			goto err;
 
 		this_len = min_t(size_t, len, PAGE_CACHE_SIZE - offset);
-		vec[i].iov_base = (void __user *) kmap(page);
+		vec[i].iov_base = (void __user *) page_address(page);
 		vec[i].iov_len = this_len;
 		pages[i] = page;
 		spd.nr_pages++;
@@ -604,7 +604,6 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 
 	nr_freed = 0;
 	for (i = 0; i < spd.nr_pages; i++) {
-		kunmap(pages[i]);
 		this_len = min_t(size_t, vec[i].iov_len, res);
 		partial[i].offset = 0;
 		partial[i].len = this_len;
@@ -624,10 +623,9 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	return res;
 
 err:
-	for (i = 0; i < spd.nr_pages; i++) {
-		kunmap(pages[i]);
+	for (i = 0; i < spd.nr_pages; i++)
 		__free_page(pages[i]);
-	}
+
 	return error;
 }
 EXPORT_SYMBOL(default_file_splice_read);

-- 
Jens Axboe

