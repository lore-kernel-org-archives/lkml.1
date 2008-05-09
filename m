Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYEIDxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYEIDxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 23:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYEIDxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 23:53:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42572 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYEIDxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 23:53:11 -0400
X-Sasl-enc: PfzObK/7xZfzEhibrLPHLE5Gu4A+AOYTn2HB+0ezpRBB 1210305189
Date: Fri, 9 May 2008 00:53:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Karol Lewandowski <lmctlx@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080509035306.GA10978@khazad-dum.debian.net>
References: <20080508231227.GA9157@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508231227.GA9157@localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2008, Karol Lewandowski wrote:
> On my Thinkpad T21 executing:

Please send me by private email the acpidump and dmidecode information
for your ThinkPad, I don't have any for the T21.  Feel free to
XXXXXX-out the UUID and serial number of your T21 in the dmidecode
output.

The machine was clean after a boot, correct? (no sleeps or other
known-to-be-busted-in-2.6.26 operations before the OOPS?)

Assuming the comments on the LED code from the first ibm-acpi maintainer
are correct, the T20-T22 use the same LED interface, the "LED_OLD"
ibm-acpi codepath.  That codepath is indeed NOT tested often, as I don't
have a way to do so.  Bugs there wouldn't surprise me too much.

If you try it using the sysfs led class, do you get the same OOPS? (I
expect you to. If you don't, I *need* to know this).

Is it always a problem with the last led (number 7), or other leds also
cause the OOPS?

Also, please try the patch below, and send me the debug output it will
generate.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 3f28f6e..392c800 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -3867,6 +3867,9 @@ static int led_set_status(unsigned int led, enum led_status_t ledstatus)
 
 	int rc = 0;
 
+	printk(TPACPI_ERR "debug: led %u, status %u, mode %u\n",
+		led, ledstatus, led_supported);
+
 	switch (led_supported) {
 	case TPACPI_LED_570:
 			/* 570 */
@@ -3878,13 +3881,22 @@ static int led_set_status(unsigned int led, enum led_status_t ledstatus)
 	case TPACPI_LED_OLD:
 			/* 600e/x, 770e, 770x, A21e, A2xm/p, T20-22, X20 */
 			led = 1 << led;
+			printk(TPACPI_ERR "debug: led is now 0x%0X\n", led);
+			printk(TPACPI_ERR "debug: will write A=0x%0X, B=0x%0X\n",
+				led * led_exp_hlbl[ledstatus],
+				led * led_exp_hlcl[ledstatus]);
+
 			rc = ec_write(TPACPI_LED_EC_HLMS, led);
 			if (rc >= 0)
 				rc = ec_write(TPACPI_LED_EC_HLBL,
 					      led * led_exp_hlbl[ledstatus]);
+			else
+				printk(TPACPI_ERR "debug: kaboom1 %d\n", rc);
 			if (rc >= 0)
 				rc = ec_write(TPACPI_LED_EC_HLCL,
 					      led * led_exp_hlcl[ledstatus]);
+			if (rc)
+				printk(TPACPI_ERR "debug: kaboom2 %d\n", rc);
 			break;
 	case TPACPI_LED_NEW:
 			/* all others */
