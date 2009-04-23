Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbZDWHx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbZDWHx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZDWHdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:54 -0400
Received: from sous-sol.org ([216.99.217.87]:50997 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754744AbZDWHdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:50 -0400
Message-Id: <20090423072639.615884422@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:14 -0700
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
Subject: [patch 054/100] SCSI: libiscsi: fix iscsi pool error path (fixlet)
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=scsi-libiscsi-fix-iscsi-pool-error-path-fixlet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <jdelvare@suse.de>

upstream commit: fd6e1c14b73dbab89cb76af895d5612e4a8b5522

Le lundi 30 mars 2009, Chris Wright a écrit :
> q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
> on error.  Make iscsi_pool_free more defensive.
>

Making the freeing of q->queue dependent on q->pool being set looks
really weird (although it is correct at the moment. But this seems
to be fixable in a much simpler way.

With the benefit that only the error case is slowed down. In both
cases we have a problem if q->queue contains an error value but it's
not -ENOMEM. Apparently this can't happen today, but it doesn't feel
right to assume this will always be true. Maybe it's the right time
to fix this as well.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
[chrisw: this is a fixlet to f474a37b, also in -stable]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/libiscsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1948,8 +1948,10 @@ iscsi_pool_init(struct iscsi_pool *q, in
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
-	if (q->queue == ERR_PTR(-ENOMEM))
+	if (IS_ERR(q->queue)) {
+		q->queue = NULL;
 		goto enomem;
+	}
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);

