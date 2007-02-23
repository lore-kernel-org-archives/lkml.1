Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbXBWGUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbXBWGUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXBWGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:20:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbXBWGUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:20:19 -0500
Date: Fri, 23 Feb 2007 07:14:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] s390: do not use _local_bh_enable()
Message-ID: <20070223061459.GA10106@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Heiko, what do you think about the patch below - is there perhaps some 
deeper reason to s390's _local_bh_enable() use that i missed?

	Ingo

-------------------------->
Subject: [patch] s390: do not use _local_bh_enable()
From: Ingo Molnar <mingo@elte.hu>

_local_bh_enable() enables bhs without invoke_softirqs(), and can thus 
cause missed softirq processing. The s390 code seems to have two such 
uses of _local_bh_enable().

in cio.c the bh disable/enable pair is superfluous, because 
irq_enter()/exit() disables softirqs anyway.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/s390/char/sclp.c |    2 +-
 drivers/s390/cio/cio.c   |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: linux/drivers/s390/char/sclp.c
===================================================================
--- linux.orig/drivers/s390/char/sclp.c
+++ linux/drivers/s390/char/sclp.c
@@ -407,8 +407,8 @@ sclp_sync_wait(void)
 	}
 	local_irq_disable();
 	__ctl_load(cr0, 0, 0);
-	_local_bh_enable();
 	local_irq_restore(flags);
+	local_bh_enable();
 }
 
 EXPORT_SYMBOL(sclp_sync_wait);
Index: linux/drivers/s390/cio/cio.c
===================================================================
--- linux.orig/drivers/s390/cio/cio.c
+++ linux/drivers/s390/cio/cio.c
@@ -140,7 +140,6 @@ cio_tpi(void)
 	sch = (struct subchannel *)(unsigned long)tpi_info->intparm;
 	if (!sch)
 		return 1;
-	local_bh_disable();
 	irq_enter ();
 	spin_lock(sch->lock);
 	memcpy (&sch->schib.scsw, &irb->scsw, sizeof (struct scsw));
@@ -148,7 +147,7 @@ cio_tpi(void)
 		sch->driver->irq(&sch->dev);
 	spin_unlock(sch->lock);
 	irq_exit ();
-	_local_bh_enable();
+
 	return 1;
 }
 
