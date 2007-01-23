Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXAWAXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXAWAXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbXAWAWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:22:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:35117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbXAWAWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:22:45 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:22:18 +1100
Message-Id: <1070123002218.27842@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 5] knfsd: Fix an NFSD bug with full sized, non-page-aligned reads.
References: <20070123111558.27683.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NFSd assumes that largest number of pages that will be needed
for a request+response is 2+N where N pages is the size of the largest
permitted read/write request.  The '2' are 1 for the non-data part of
the request, and 1 for the non-data part of the reply.

However, when a read request is not page-aligned, and we choose to use
->sendfile to send it directly from the page cache, we may need N+1
pages to hold the whole reply.  This can overflow and array and cause
an Oops.

This patch increases size of the array for holding pages by one and
makes sure that entry is NULL when it is not in use.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/vfs.c              |    3 ++-
 ./include/linux/sunrpc/svc.h |    5 ++++-
 ./net/sunrpc/svcsock.c       |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-01-23 11:13:45.000000000 +1100
+++ ./fs/nfsd/vfs.c	2007-01-23 11:14:54.000000000 +1100
@@ -822,7 +822,8 @@ nfsd_read_actor(read_descriptor_t *desc,
 		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
-		put_page(*pp);
+		if (*pp)
+			put_page(*pp);
 		*pp = page;
 		rqstp->rq_resused++;
 		rqstp->rq_res.page_len += size;

diff .prev/include/linux/sunrpc/svc.h ./include/linux/sunrpc/svc.h
--- .prev/include/linux/sunrpc/svc.h	2007-01-23 11:13:45.000000000 +1100
+++ ./include/linux/sunrpc/svc.h	2007-01-23 11:14:54.000000000 +1100
@@ -144,8 +144,11 @@ extern u32 svc_max_payload(const struct 
  *
  * Each request/reply pair can have at most one "payload", plus two pages,
  * one for the request, and one for the reply.
+ * We using ->sendfile to return read data, we might need one extra page
+ * if the request is not page-aligned.  So add another '1'.
  */
-#define RPCSVC_MAXPAGES		((RPCSVC_MAXPAYLOAD+PAGE_SIZE-1)/PAGE_SIZE + 2)
+#define RPCSVC_MAXPAGES		((RPCSVC_MAXPAYLOAD+PAGE_SIZE-1)/PAGE_SIZE \
+				+ 2 + 1)
 
 static inline u32 svc_getnl(struct kvec *iov)
 {

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-01-23 11:13:45.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-01-23 11:14:54.000000000 +1100
@@ -1306,6 +1306,8 @@ svc_recv(struct svc_rqst *rqstp, long ti
 				schedule_timeout_uninterruptible(msecs_to_jiffies(500));
 			rqstp->rq_pages[i] = p;
 		}
+	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	BUG_ON(pages >= RPCSVC_MAXPAGES);
 
 	/* Make arg->head point to first page and arg->pages point to rest */
 	arg = &rqstp->rq_arg;
