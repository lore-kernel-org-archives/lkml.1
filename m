Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXCEN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXCEN3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965666AbXCEN3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:29:18 -0500
Received: from ozlabs.org ([203.10.76.45]:41724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965677AbXCEN3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:29:16 -0500
Subject: Re: [patch] paravirt: VDSO page is essential
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <20070305120631.GA14105@elte.hu>
References: <20070305120631.GA14105@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 00:28:17 +1100
Message-Id: <1173101297.26165.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 13:06 +0100, Ingo Molnar wrote:
> Subject: [patch] paravirt: VDSO page is essential
> From: Ingo Molnar <mingo@elte.hu>
> 
> commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
> CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 
> an essential component of Linux, and this change forces all of them to 
> use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
> handle the VDSO properly then it can work things around via the vdso=0 
> boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
> case, it is a basic taste issue: we DO NOT #ifdef around core features 
> like this!)

I agree with the criticism, dislike the snarly comments, and disagree
with this patch.

VDSO is only a problem if (1) the hypervisor wants to reserve the top
virtual address space (CONFIG_PARAVIRT=y), and (2) the glibc is old and
can't handle a VDSO mapped anywhere but 0xFFFFE000
(CONFIG_COMPAT_VDSO=y).

Now, KVM wants to use CONFIG_PARAVIRT=y but not reserve_top_address(),
so we should split the config option.  Let's not get too excited because
we kept it simple.  Patch (untested, but fairly simple) below.

BTW, I had a patch to do a runtime test (old glibc causes init to
assert, then disable vdso and try again): everyone hated it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f75715e64a3b arch/i386/Kconfig
--- a/arch/i386/Kconfig	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/Kconfig	Tue Mar 06 00:20:44 2007 +1100
@@ -218,9 +218,18 @@ config PARAVIRT
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
 
+config RESERVE_TOP
+	bool
+	help
+	  Many hypervisors want to reserve some amount of the top of
+	  virtual address space.  Unfortunately, old glibc needs the
+	  vdso page there, so we must disable vdso if COMPAT_VDSO is
+	  enabled as well as this option.
+
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT && !NO_HZ
+	select RESERVE_TOP
 	default y
 	help
 	  VMI provides a paravirtualized interface to multiple hypervisors
@@ -893,9 +902,10 @@ config COMPAT_VDSO
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
-	depends on !PARAVIRT
-	help
-	  Map the VDSO to the predictable old-style address too.
+	help
+	  Map the VDSO to the predictable old-style address too, or
+	  in the case of a VMI/Xen/lguest virtualized guest, don't create
+	  the VDSO at all.
 	---help---
 	  Say N here if you are running a sufficiently recent glibc
 	  version (2.3.3 or later), to remove the high-mapped
diff -r f75715e64a3b arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/kernel/sysenter.c	Tue Mar 06 00:21:42 2007 +1100
@@ -27,7 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
+#if defined(CONFIG_COMPAT_VDSO) && defined(CONFIG_RESERVE_TOP)
 unsigned int __read_mostly vdso_enabled = 0;
 #else
 unsigned int __read_mostly vdso_enabled = 1;
diff -r f75715e64a3b arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/mm/pgtable.c	Tue Mar 06 00:06:00 2007 +1100
@@ -173,7 +173,7 @@ void reserve_top_address(unsigned long r
 	BUG_ON(fixmaps > 0);
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
-#ifdef CONFIG_COMPAT_VDSO
+#ifndef CONFIG_RESERVE_TOP
 	BUG_ON(reserve != 0);
 #else
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;


