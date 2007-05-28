Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXE1T5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXE1T5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 15:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXE1T5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 15:57:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59772 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXE1T5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 15:57:47 -0400
Date: Mon, 28 May 2007 21:58:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ARM: Section mismatch warnings
Message-ID: <20070528195847.GB31233@uranus.ravnborg.org>
References: <20070528163253.GA29174@uranus.ravnborg.org> <20070528170430.GB5737@flint.arm.linux.org.uk> <20070528183629.GA30821@uranus.ravnborg.org> <20070528192548.GD5737@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528192548.GD5737@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:25:48PM +0100, Russell King wrote:
> On Mon, May 28, 2007 at 08:36:29PM +0200, Sam Ravnborg wrote:
> > > 
> > > > o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1748):
> > >  Section mismatch: reference to .init.text:sa1110_mb_disable
> > >  (between 'neponset_init' and 'neponset_resume')
> > > 
> > > This one looks quite bogus.  sa1110_mb_disable() is marked __init, and
> > > it's called from neponset_init() which is also marked __init.
> > 
> > Created a neponset.i file - output:
> > 
> > static int neponset_init(void)
> > {
> >  platform_driver_register(&neponset_device_driver);
> > 
> > So we loose the __init marker during preprocessing.
> > Which is due the the buggy part of my path that adds __devinit.
> > 
> > There was a reason I noted the devinit markers should be reviewed
> > carefully - this one seems wrong.
> 
> I don't understand why you added that __devinit in the first place.
Too many children running around seeking attention?

> What happens if you leave it as a mere __init function, as it should be?
$ o-arm/scripts/mod/modpost o-arm/arch/arm/mach-sa1100/neponset.o
WARNING: o-arm/arch/arm/mach-sa1100/neponset.o(.text+0x300): Section mismatch: reference to .init.data:devices (after 'neponset_probe')

Declaring neponset_probe __init cured it.
Sorry for posting the wrong patch in the first place.

Patch below.

	Sam

Subject: arm: fix two warnings in mach-sa1100/neponset.c

Fix following warnings:
  CC      arch/arm/mach-sa1100/neponset.o
/home/sam/kernel/kbuild.git/arch/arm/mach-sa1100/neponset.c: In function 'neponset_init':
/home/sam/kernel/kbuild.git/arch/arm/mach-sa1100/neponset.c:317: warning: implicit declaration of function 'sa1110_mb_disable'
WARNING: o-arm/arch/arm/mach-sa1100/neponset.o(.text+0x300): Section mismatch: reference to .init.data:devices (after 'neponset_probe')

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/arm/mach-sa1100/neponset.c b/arch/arm/mach-sa1100/neponset.c
index d7c038a..6dfc62a 100644
--- a/arch/arm/mach-sa1100/neponset.c
+++ b/arch/arm/mach-sa1100/neponset.c
@@ -21,6 +21,8 @@
 #include <asm/hardware/sa1111.h>
 #include <asm/sizes.h>
 
+#include "generic.h"
+
 /*
  * Install handler for Neponset IRQ.  Note that we have to loop here
  * since the ETHERNET and USAR IRQs are level based, and we need to
@@ -144,7 +146,7 @@ static struct sa1100_port_fns neponset_port_fns __initdata = {
 	.get_mctrl	= neponset_get_mctrl,
 };
 
-static int neponset_probe(struct platform_device *dev)
+static int __init neponset_probe(struct platform_device *dev)
 {
 	sa1100_register_uart_fns(&neponset_port_fns);
 
