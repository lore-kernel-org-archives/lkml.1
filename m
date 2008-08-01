Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYHAO0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYHAO0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYHAO0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:26:23 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57189 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYHAO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:26:21 -0400
Message-ID: <48931D69.2010309@keyaccess.nl>
Date: Fri, 01 Aug 2008 16:27:53 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Wolfram Sang <w.sang@pengutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org> <20080731225004.GD22426@elte.hu> <48926FC3.3000706@keyaccess.nl> <20080801095105.GA18055@elte.hu>
In-Reply-To: <20080801095105.GA18055@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------000709040506070606000101"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709040506070606000101
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 01-08-08 11:51, Ingo Molnar wrote:

> find attached below a newer version of the original list i published 
> half a year ago:
> 
>    http://people.redhat.com/mingo/auto-qa-patches/Kconfig-qa.patch
> 
> these are just pragmatic local hacks to get things going. (There are 
> more per machine quirks as well.)
> 
> i have not used a BROKEN annotation because CONFIG_BROKEN is 
> impractical: it just kills code altogether, indiscriminately. There's no 
> way for users to enable CONFIG_BROKEN in the upstream kernel - nothing 
> selects it and it's not an interactive option either.
> 
> So by all means if we mark a driver or a kernel feature as 
> CONFIG_BROKEN, it's killed altogether for all practical purposes.
> 
> What we'd need is some more gradual approach: for example a way to mark 
> "drivers that are not expected to boot on a whitebox PC", without 
> removing them altogether via a CONFIG_BROKEN dependency - often it's 
> hardware that cannot be probed safely.

For real ISA at the least, the best fix I feel is just not go grabbing 
resources without anything (ie, ISAPnP) or anyone (ie, the user) telling 
us that's where the hardware's at.

For example, for the first real ISA driver in the list:

> Index: linux/drivers/i2c/busses/Kconfig
> ===================================================================
> --- linux.orig/drivers/i2c/busses/Kconfig
> +++ linux/drivers/i2c/busses/Kconfig
> @@ -610,6 +610,11 @@ config I2C_ELEKTOR
>  config I2C_PCA_ISA
>  	tristate "PCA9564 on an ISA bus"
>  	depends on ISA
> +
> +	# takes away IRQ10 on venus and thus breaks e1000
> +	depends on BROKEN_BOOT_ALLOWED
> +	select BROKEN_BOOT
> +

The attached would be my preffered approach to this.

(to avoid an IRQ 0 discussion -- the middle hunk is unrelated, just 
makes it consistent with the rest of the file)

(and this uses the isa_bus match() method as intended; the idea of the 
isa_bus is to make it look at least somewhat like a sane bus such as PCI 
which includes only failing a load if there's no way a later bind could 
conceivably succeed. somewhat debatable merit sometimes, but such is the 
device model, and it's actually fairly nice once you get used to it for 
quickly switching drivers for a single piece of hardware)

A user of this hardware is a one-time

$ echo options i2c-pca-isa base=0x330 irq=10 >> /etc/modprobe.conf

away from the old behaviour. Given the hackish nature of all this kind 
of hardware these days its users tend to not mind. In fact, what with 
getting old hardware to play nice with modern systems, I myself at least 
very much welcome having to be explicit about these things.

(and just saw the CC list on this thing while adding Wolfram. ouch. will 
be dropping all from any followups...)

Rene.

--------------000709040506070606000101
Content-Type: text/plain;
 name="0001-i2c-don-t-autograb-i2c-pca-isa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-i2c-don-t-autograb-i2c-pca-isa.patch"

>From 58f25a608b827426bf5c110795dd7e917e9cc568 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 1 Aug 2008 15:35:31 +0200
Subject: [PATCH] i2c: don't autograb i2c-pca-isa

Grabbing resources without anything telling us we should can break
randconfig builds by keeping them busy. Insist that when hardware
is not capable of telling us, the user does.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/i2c/busses/i2c-pca-isa.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index a119784..2579169 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -36,8 +36,8 @@
 #define DRIVER "i2c-pca-isa"
 #define IO_SIZE 4
 
-static unsigned long base   = 0x330;
-static int irq 	  = 10;
+static unsigned long base;
+static int irq = -1;
 
 /* Data sheet recommends 59kHz for 100kHz operation due to variation
  * in the actual clock rate */
@@ -107,6 +107,19 @@ static struct i2c_adapter pca_isa_ops = {
 	.timeout	= 100,
 };
 
+static int __devinit pca_isa_match(struct device *dev, unsigned int id)
+{
+	int match = base != 0;
+
+	if (match) {
+		if (irq == -1)
+			dev_warn(dev, "using poling mode (specify irq)\n");
+	} else
+		dev_err(dev, "please specify base\n");
+
+	return match;
+}
+
 static int __devinit pca_isa_probe(struct device *dev, unsigned int id)
 {
 	init_waitqueue_head(&pca_wait);
@@ -153,7 +166,7 @@ static int __devexit pca_isa_remove(struct device *dev, unsigned int id)
 {
 	i2c_del_adapter(&pca_isa_ops);
 
-	if (irq > 0) {
+	if (irq > -1) {
 		disable_irq(irq);
 		free_irq(irq, &pca_isa_ops);
 	}
@@ -163,6 +176,7 @@ static int __devexit pca_isa_remove(struct device *dev, unsigned int id)
 }
 
 static struct isa_driver pca_isa_driver = {
+	.match		= pca_isa_match,
 	.probe		= pca_isa_probe,
 	.remove		= __devexit_p(pca_isa_remove),
 	.driver = {
-- 
1.5.5


--------------000709040506070606000101--
