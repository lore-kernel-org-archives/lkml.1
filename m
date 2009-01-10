Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZAJL4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZAJL4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZAJLzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:55:55 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:2188 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900AbZAJLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:55:54 -0500
Message-ID: <49688C67.5050502@gentoo.org>
Date: Sat, 10 Jan 2009 11:54:15 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: klausman@gentoo.org, rth@twiddle.net
Subject: cant compile on alpha with gcc-4.3 and CONFIG_ALPHA_NAUTILUS
Content-Type: multipart/mixed;
 boundary="------------070408040208020907020309"
X-Cloudmark-Analysis: v=1.0 c=1 a=a5PJpRa3NxQA:10 a=tj7nbZ9FMiwA:10 a=7mOBRU54AAAA:8 a=XTmTef33UoQ6Ru8ARbUA:9 a=1i2wxVhOy3jKh230w5gA:7 a=AX-RvxnbeGI7c8aOa9ElU4qA66gA:4 a=50e4U0PicR4A:10 a=yJmr3hZOAQhnGubUC64A:9 a=BxthDOj1FlTzs7v3Y0UA:7 a=LyOnrB70Udv1VJ2zpHflfsRFpTgA:4 a=iYlkOlhu7C0A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070408040208020907020309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

As reported here:
http://bugs.gentoo.org/show_bug.cgi?id=254150

.config here:
http://bugs.gentoo.org/attachment.cgi?id=177958&action=view

Compile fails for the CONFIG_ALPHA_NAUTILUS systype on gcc 4.3, due to
gcc's new array bounds checking:
   CC      arch/alpha/kernel/irq_srm.o
cc1: warnings being treated as errors
arch/alpha/kernel/irq_srm.c: In function 'init_srm_irqs':
arch/alpha/kernel/irq_srm.c:69: error: array subscript is above array
bounds
arch/alpha/kernel/irq_srm.c:70: error: array subscript is above array
bounds
make[1]: *** [arch/alpha/kernel/irq_srm.o] Error 1

I was surprised to see that alpha has -Werror set, but I see that is
also true of some other architectures. Ordinarily, bounds checking is
only a warning.

gcc is both right and wrong with this warning. It is right, because
nautilus hits this in arch/alpha/include/asm/irq.h:
#else /* everyone else */
# define NR_IRQS	16
#endif

And init_srm_irqs() would clearly go above the size of the array:
	for (i = 16; i < max; ++i)

But gcc is also wrong, in that it is assuming that init_srm_irqs() would
be called with max > 16. In fact, in this configuration, init_srm_irqs()
is never called at all (but I am not sure how we could expect gcc to
know this, given that object files are compiled individually). It is
only called on two of the many alpha systypes, as far as I can see.

To fix this, we could remove -Werror or we could restructure the irq_srm
code so that it is only compiled on systems that use it. One small
function (srm_device_interrupt) is used all over the place so would have
to be separated. Patch attached, which has been compile-tested on 
nautilus. The disadvantage is that srm_device_interrupt() is now built 
on all alpha sys types, but it is so small that it doesn't seem worth 
creating its own file or creating ifdef spaghetti.

Thoughts?

Daniel


--------------070408040208020907020309
Content-Type: text/plain;
 name="alpha-srm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="alpha-srm.patch"

From: Daniel Drake <dsd@gentoo.org>
https://bugs.gentoo.org/show_bug.cgi?id=254150
Disclaimer: I know nothing about alpha!

Index: linux-2.6.28-gentoo/arch/alpha/kernel/Makefile
===================================================================
--- linux-2.6.28-gentoo.orig/arch/alpha/kernel/Makefile
+++ linux-2.6.28-gentoo/arch/alpha/kernel/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_ALPHA_TITAN)	+= core_titan.
 obj-$(CONFIG_ALPHA_WILDFIRE)	+= core_wildfire.o
 
 # Board support
-obj-$(CONFIG_ALPHA_ALCOR)	+= sys_alcor.o irq_i8259.o irq_srm.o
+obj-$(CONFIG_ALPHA_ALCOR)	+= sys_alcor.o irq_i8259.o
 obj-$(CONFIG_ALPHA_CABRIOLET)	+= sys_cabriolet.o irq_i8259.o irq_srm.o \
 				   ns87312.o
 obj-$(CONFIG_ALPHA_EB164)	+= sys_cabriolet.o irq_i8259.o irq_srm.o \
@@ -78,19 +78,19 @@ obj-$(CONFIG_ALPHA_JENSEN)	+= sys_jensen
 obj-$(CONFIG_ALPHA_MARVEL)	+= sys_marvel.o 
 obj-$(CONFIG_ALPHA_MIATA)	+= sys_miata.o irq_pyxis.o irq_i8259.o \
 				   es1888.o smc37c669.o
-obj-$(CONFIG_ALPHA_MIKASA)	+= sys_mikasa.o irq_i8259.o irq_srm.o
-obj-$(CONFIG_ALPHA_NAUTILUS)	+= sys_nautilus.o irq_i8259.o irq_srm.o
+obj-$(CONFIG_ALPHA_MIKASA)	+= sys_mikasa.o irq_i8259.o
+obj-$(CONFIG_ALPHA_NAUTILUS)	+= sys_nautilus.o irq_i8259.o
 obj-$(CONFIG_ALPHA_NORITAKE)	+= sys_noritake.o irq_i8259.o
 obj-$(CONFIG_ALPHA_RAWHIDE)	+= sys_rawhide.o irq_i8259.o
 obj-$(CONFIG_ALPHA_RUFFIAN)	+= sys_ruffian.o irq_pyxis.o irq_i8259.o
 obj-$(CONFIG_ALPHA_RX164)	+= sys_rx164.o irq_i8259.o
 obj-$(CONFIG_ALPHA_SABLE)	+= sys_sable.o
 obj-$(CONFIG_ALPHA_LYNX)	+= sys_sable.o
-obj-$(CONFIG_ALPHA_BOOK1)	+= sys_sio.o irq_i8259.o irq_srm.o ns87312.o
-obj-$(CONFIG_ALPHA_AVANTI)	+= sys_sio.o irq_i8259.o irq_srm.o ns87312.o
-obj-$(CONFIG_ALPHA_NONAME)	+= sys_sio.o irq_i8259.o irq_srm.o ns87312.o
-obj-$(CONFIG_ALPHA_P2K)		+= sys_sio.o irq_i8259.o irq_srm.o ns87312.o
-obj-$(CONFIG_ALPHA_XL)		+= sys_sio.o irq_i8259.o irq_srm.o ns87312.o
+obj-$(CONFIG_ALPHA_BOOK1)	+= sys_sio.o irq_i8259.o ns87312.o
+obj-$(CONFIG_ALPHA_AVANTI)	+= sys_sio.o irq_i8259.o ns87312.o
+obj-$(CONFIG_ALPHA_NONAME)	+= sys_sio.o irq_i8259.o ns87312.o
+obj-$(CONFIG_ALPHA_P2K)		+= sys_sio.o irq_i8259.o ns87312.o
+obj-$(CONFIG_ALPHA_XL)		+= sys_sio.o irq_i8259.o ns87312.o
 obj-$(CONFIG_ALPHA_SX164)	+= sys_sx164.o irq_pyxis.o irq_i8259.o \
 				   irq_srm.o smc37c669.o
 obj-$(CONFIG_ALPHA_TAKARA)	+= sys_takara.o irq_i8259.o ns87312.o
Index: linux-2.6.28-gentoo/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.28-gentoo.orig/arch/alpha/kernel/irq.c
+++ linux-2.6.28-gentoo/arch/alpha/kernel/irq.c
@@ -159,3 +159,11 @@ handle_irq(int irq)
 	__do_IRQ(irq);
 	irq_exit();
 }
+
+void
+srm_device_interrupt(unsigned long vector)
+{
+	int irq = (vector - 0x800) >> 4;
+	handle_irq(irq);
+}
+
Index: linux-2.6.28-gentoo/arch/alpha/kernel/irq_srm.c
===================================================================
--- linux-2.6.28-gentoo.orig/arch/alpha/kernel/irq_srm.c
+++ linux-2.6.28-gentoo/arch/alpha/kernel/irq_srm.c
@@ -71,9 +71,3 @@ init_srm_irqs(long max, unsigned long ig
 	}
 }
 
-void 
-srm_device_interrupt(unsigned long vector)
-{
-	int irq = (vector - 0x800) >> 4;
-	handle_irq(irq);
-}

--------------070408040208020907020309--
