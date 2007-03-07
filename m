Return-Path: <linux-kernel-owner+w=401wt.eu-S1422885AbXCGR32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885AbXCGR32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422853AbXCGRRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:43485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821AbXCGRQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:46 -0500
Message-Id: <20070307171507.521078125@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 067/101] Fix %100 cpu spinning on sparc64
Content-Disposition: inline; filename=fix-100-cpu-spinning-on-sparc64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[SPARC64] bbc_i2c: Fix kenvctrld eating %100 cpu.

Based almost entirely upon a patch by Joerg Friedrich

Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/sbus/char/bbc_i2c.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- linux-2.6.20.1.orig/drivers/sbus/char/bbc_i2c.c
+++ linux-2.6.20.1/drivers/sbus/char/bbc_i2c.c
@@ -187,19 +187,20 @@ static int wait_for_pin(struct bbc_i2c_b
 	bp->waiting = 1;
 	add_wait_queue(&bp->wq, &wait);
 	while (limit-- > 0) {
-		u8 val;
+		unsigned long val;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		*status = val = readb(bp->i2c_control_regs + 0);
-		if ((val & I2C_PCF_PIN) == 0) {
+		val = wait_event_interruptible_timeout(
+				bp->wq,
+				(((*status = readb(bp->i2c_control_regs + 0))
+				  & I2C_PCF_PIN) == 0),
+				msecs_to_jiffies(250));
+		if (val > 0) {
 			ret = 0;
 			break;
 		}
-		msleep_interruptible(250);
 	}
 	remove_wait_queue(&bp->wq, &wait);
 	bp->waiting = 0;
-	current->state = TASK_RUNNING;
 
 	return ret;
 }
@@ -340,7 +341,7 @@ static irqreturn_t bbc_i2c_interrupt(int
 	 */
 	if (bp->waiting &&
 	    !(readb(bp->i2c_control_regs + 0x0) & I2C_PCF_PIN))
-		wake_up(&bp->wq);
+		wake_up_interruptible(&bp->wq);
 
 	return IRQ_HANDLED;
 }

--
