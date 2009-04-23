Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbZDWH6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbZDWH6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZDWHev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:51 -0400
Received: from sous-sol.org ([216.99.217.87]:51076 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757485AbZDWHet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:49 -0400
Message-Id: <20090423072627.658983380@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jean Delvare <jdelvare@suse.de>,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 053/100] SCSI: libiscsi: fix iscsi pool error path
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=scsi-libiscsi-fix-iscsi-pool-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <jdelvare@suse.de>

upstream commit: f474a37bc48667595b5653a983b635c95ed82a3b

Memory freeing in iscsi_pool_free() looks wrong to me. Either q->pool
can be NULL and this should be tested before dereferencing it, or it
can't be NULL and it shouldn't be tested at all. As far as I can see,
the only case where q->pool is NULL is on early error in
iscsi_pool_init(). One possible way to fix the bug is thus to not
call iscsi_pool_free() in this case (nothing needs to be freed anyway)
and then we can get rid of the q->pool check.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/libiscsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1944,7 +1944,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		goto enomem;
+		return -ENOMEM;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
@@ -1979,8 +1979,7 @@ void iscsi_pool_free(struct iscsi_pool *
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	if (q->pool)
-		kfree(q->pool);
+	kfree(q->pool);
 	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);

