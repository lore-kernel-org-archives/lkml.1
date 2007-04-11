Return-Path: <linux-kernel-owner+w=401wt.eu-S1161403AbXDKXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161403AbXDKXGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161355AbXDKWy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55563 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347AbXDKWyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:23 -0400
Date: Wed, 11 Apr 2007 15:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Oberritter <obi@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 09/31] DVB: pluto2: fix incorrect TSCR register setting
Message-ID: <20070411225144.GJ24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-pluto2-fix-incorrect-tscr-register-setting.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andreas Oberritter <obi@linuxtv.org>

DVB: pluto2: fix incorrect TSCR register setting

The ADEF bits in the TSCR register have different meanings in read
and write mode. For this reason ADEF has to be reset on every
read-modify-write operation.

This patch introduces a special write function for this register, which
takes care of it.

Thanks to Holger Magnussen for pointing my nose at this problem.

(cherry picked from commit 1489f90a49f0603a393e1800d729050f6e332bec)

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/pluto2/pluto2.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -149,6 +149,15 @@ static inline void pluto_rw(struct pluto
 	writel(val, &pluto->io_mem[reg]);
 }
 
+static void pluto_write_tscr(struct pluto *pluto, u32 val)
+{
+	/* set the number of packets */
+	val &= ~TSCR_ADEF;
+	val |= TS_DMA_PACKETS / 2;
+
+	pluto_writereg(pluto, REG_TSCR, val);
+}
+
 static void pluto_setsda(void *data, int state)
 {
 	struct pluto *pluto = data;
@@ -213,11 +222,11 @@ static void pluto_reset_ts(struct pluto 
 
 	if (val & TSCR_RSTN) {
 		val &= ~TSCR_RSTN;
-		pluto_writereg(pluto, REG_TSCR, val);
+		pluto_write_tscr(pluto, val);
 	}
 	if (reenable) {
 		val |= TSCR_RSTN;
-		pluto_writereg(pluto, REG_TSCR, val);
+		pluto_write_tscr(pluto, val);
 	}
 }
 
@@ -339,7 +348,7 @@ static irqreturn_t pluto_irq(int irq, vo
 	}
 
 	/* ACK the interrupt */
-	pluto_writereg(pluto, REG_TSCR, tscr | TSCR_IACK);
+	pluto_write_tscr(pluto, tscr | TSCR_IACK);
 
 	return IRQ_HANDLED;
 }
@@ -348,9 +357,6 @@ static void __devinit pluto_enable_irqs(
 {
 	u32 val = pluto_readreg(pluto, REG_TSCR);
 
-	/* set the number of packets */
-	val &= ~TSCR_ADEF;
-	val |= TS_DMA_PACKETS / 2;
 	/* disable AFUL and LOCK interrupts */
 	val |= (TSCR_MSKA | TSCR_MSKL);
 	/* enable DMA and OVERFLOW interrupts */
@@ -358,7 +364,7 @@ static void __devinit pluto_enable_irqs(
 	/* clear pending interrupts */
 	val |= TSCR_IACK;
 
-	pluto_writereg(pluto, REG_TSCR, val);
+	pluto_write_tscr(pluto, val);
 }
 
 static void pluto_disable_irqs(struct pluto *pluto)
@@ -370,7 +376,7 @@ static void pluto_disable_irqs(struct pl
 	/* clear pending interrupts */
 	val |= TSCR_IACK;
 
-	pluto_writereg(pluto, REG_TSCR, val);
+	pluto_write_tscr(pluto, val);
 }
 
 static int __devinit pluto_hw_init(struct pluto *pluto)

-- 
