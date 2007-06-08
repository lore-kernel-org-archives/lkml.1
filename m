Return-Path: <linux-kernel-owner+w=401wt.eu-S939183AbXFHIIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939183AbXFHIIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938855AbXFHHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:40:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35547 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938872AbXFHHkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:40:06 -0400
Message-Id: <20070608072158.875539000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>,
       Roland Scheidegger <sroland@tungstengraphics.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 16/54] Input: i8042 - fix AUX port detection with some chips
Content-Disposition: inline; filename=input-i8042-fix-aux-port-detection-with-some-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Roland Scheidegger <sroland@tungstengraphics.com>

The i8042 driver fails detection of the AUX port with some chips,
because they apparently do not change the I8042_CTR_AUXDIS bit
immediately. This is known to affect at least HP500/HP510 notebooks,
consequently the built-in touchpad will not work. The patch will simply
reread the value until it gets the expected value or a retry limit is
hit, without touching other workaround code in the same area.

Signed-off-by: Roland Scheidegger <sroland@tungstengraphics.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=d2ada5597d33a9108acb2caf912f85cbc9caab1e

 drivers/input/serio/i8042.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- linux-2.6.21.4.orig/drivers/input/serio/i8042.c
+++ linux-2.6.21.4/drivers/input/serio/i8042.c
@@ -526,6 +526,33 @@ static irqreturn_t __devinit i8042_aux_t
 	return IRQ_HANDLED;
 }
 
+/*
+ * i8042_toggle_aux - enables or disables AUX port on i8042 via command and
+ * verifies success by readinng CTR. Used when testing for presence of AUX
+ * port.
+ */
+static int __devinit i8042_toggle_aux(int on)
+{
+	unsigned char param;
+	int i;
+
+	if (i8042_command(&param,
+			on ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE))
+		return -1;
+
+	/* some chips need some time to set the I8042_CTR_AUXDIS bit */
+	for (i = 0; i < 100; i++) {
+		udelay(50);
+
+		if (i8042_command(&param, I8042_CMD_CTL_RCTR))
+			return -1;
+
+		if (!(param & I8042_CTR_AUXDIS) == on)
+			return 0;
+	}
+
+	return -1;
+}
 
 /*
  * i8042_check_aux() applies as much paranoia as it can at detecting
@@ -580,16 +607,12 @@ static int __devinit i8042_check_aux(voi
  * Bit assignment test - filters out PS/2 i8042's in AT mode
  */
 
-	if (i8042_command(&param, I8042_CMD_AUX_DISABLE))
-		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (~param & I8042_CTR_AUXDIS)) {
+	if (i8042_toggle_aux(0)) {
 		printk(KERN_WARNING "Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
 		printk(KERN_WARNING "If AUX port is really absent please use the 'i8042.noaux' option.\n");
 	}
 
-	if (i8042_command(&param, I8042_CMD_AUX_ENABLE))
-		return -1;
-	if (i8042_command(&param, I8042_CMD_CTL_RCTR) || (param & I8042_CTR_AUXDIS))
+	if (i8042_toggle_aux(1))
 		return -1;
 
 /*

-- 
