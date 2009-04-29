Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbZD2Wbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbZD2Wbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbZD2WVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:34 -0400
Received: from kroah.org ([198.145.64.141]:40484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbZD2WVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:27 2009
Message-Id: <20090429220927.309155133@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:27 -0700
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
       alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 28/58] SCSI: libiscsi: fix iscsi pool error path again
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0053-SCSI-libiscsi-fix-iscsi-pool-error-path.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/libiscsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1811,8 +1811,10 @@ iscsi_pool_init(struct iscsi_pool *q, in
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
-	if (q->queue == ERR_PTR(-ENOMEM))
+	if (IS_ERR(q->queue)) {
+		q->queue = NULL;
 		goto enomem;
+	}
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);


