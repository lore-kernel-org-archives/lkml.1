Return-Path: <linux-kernel-owner+w=401wt.eu-S1765757AbZD3RVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765757AbZD3RVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763428AbZD3RHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:49 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764560AbZD3RHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:43 2009
Message-Id: <20090430165743.048913756@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:21 -0700
From: Greg KH <gregkh@suse.de>
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
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 32/88] SCSI: libiscsi: fix iscsi pool error path
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0052-SCSI-libiscsi-fix-iscsi-pool-error-path.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/libiscsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1862,7 +1862,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		goto enomem;
+		return -ENOMEM;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
@@ -1897,8 +1897,7 @@ void iscsi_pool_free(struct iscsi_pool *
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	if (q->pool)
-		kfree(q->pool);
+	kfree(q->pool);
 	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);


