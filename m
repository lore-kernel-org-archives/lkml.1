Return-Path: <linux-kernel-owner+w=401wt.eu-S1946270AbXBCCi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946270AbXBCCi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946268AbXBCCi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:56 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53039 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946263AbXBCCiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:50 -0500
Message-Id: <20070203024309.888535000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:39 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 35/59] knfsd: fix an NFSD bug with full sized, non-page-aligned reads.
Content-Disposition: inline; filename=knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/nfsd/vfs.c              |    3 ++-
 include/linux/sunrpc/svc.h |    5 ++++-
 net/sunrpc/svcsock.c       |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/fs/nfsd/vfs.c
+++ linux-2.6.19.2/fs/nfsd/vfs.c
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
--- linux-2.6.19.2.orig/include/linux/sunrpc/svc.h
+++ linux-2.6.19.2/include/linux/sunrpc/svc.h
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
--- linux-2.6.19.2.orig/net/sunrpc/svcsock.c
+++ linux-2.6.19.2/net/sunrpc/svcsock.c
@@ -1248,6 +1248,8 @@ svc_recv(struct svc_rqst *rqstp, long ti
 				schedule_timeout_uninterruptible(msecs_to_jiffies(500));
 			rqstp->rq_pages[i] = p;
 		}
+	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	BUG_ON(pages >= RPCSVC_MAXPAGES);
 
 	/* Make arg->head point to first page and arg->pages point to rest */
 	arg = &rqstp->rq_arg;

--
