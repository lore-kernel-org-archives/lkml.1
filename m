Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXISByQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXISByQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXISByA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:54:00 -0400
Received: from ozlabs.org ([203.10.76.45]:56965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXISByA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:54:00 -0400
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: virtualization@lists.linux-foundation.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200709182352.25118.ak@suse.de>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <200709181257.41530.ak@suse.de>
	 <1190151272.7262.175.camel@localhost.localdomain>
	 <200709182352.25118.ak@suse.de>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 11:53:17 +1000
Message-Id: <1190166797.7262.193.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 23:52 +0200, Andi Kleen wrote:
> On Tuesday 18 September 2007 23:34, Rusty Russell wrote:
> > How about a "select" based on Xen, lguest or VMI?  There's no other
> > reason to enable it, after all.
> 
> I did an patch to do that recently because  the current setup
> is indeed unobvious.
> 
> But I had to drop it again because 
> it ended up with Kconfig warnings. about undefined symbols
> on x86-64. The problem is that lguest
> is visible in Kconfig for all architectures and it warns
> if you select something that doesn't exist on all architectures.

I think that's fixed as a side-effect of this cleanup.  At least, it
works for me on x86-64.  Patch below: if you agree, I'll re-xmit all
three.

> > > Also I would still consider it experimental.
> >
> > After 9 months in mainline and three kernel versions, 
> 
> Well it changed a lot each release.

Well, the biggest change was the patching code getting enhanced in
2.6.22 (to cover all calls, not just 5).  The 22 -> 23 changes were
fairly trivial.

So I think 2.6.24 is a reasonable time to remove EXPERIMENTAL.

> > I'd hope not. 
> > It's been pretty damn stable (ok, you broke it once, but maybe that's
> > because you consider it experimental).
> 
> Is there a significant user base? 

It's enabled in Ubuntu Feisty (2.6.20).

> At least the Xen port seems to have specific requirements
> and essentially only work on xen-unstable (?) [or at least
> some very new Xen version] which probably very few
> people use.

Sure, and that might well still be experimental (Jeremy?).  But that's
not CONFIG_PARAVIRT.

Hope that helps,
Rusty.
==
Andi points out that PARAVIRT is an option best selected when needed.

We introduce PARAVIRT_GUEST for the menu itself, and select PARAVIRT
if they ask for anything which needs it.  This also makes PARAVIRT
non-experimental.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 8efa5fdb22d8 arch/i386/Kconfig
--- a/arch/i386/Kconfig	Wed Sep 19 11:23:18 2007 +1000
+++ b/arch/i386/Kconfig	Wed Sep 19 11:33:59 2007 +1000
@@ -214,24 +214,30 @@ config X86_ES7000
 
 endchoice
 
-menuconfig PARAVIRT
+config PARAVIRT
+	bool
+	depends on !(X86_VISWS || X86_VOYAGER)
+	help
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
+menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Paravirtualized guest support"
-	depends on !(X86_VISWS || X86_VOYAGER)
-	help
-	  Paravirtualization is a way of running multiple instances of
-	  Linux on the same machine, under a hypervisor.  This option
-	  changes the kernel so it can modify itself when it is run
-	  under a hypervisor, improving performance significantly.
-	  However, when run without a hypervisor the kernel is
-	  theoretically slower.  If in doubt, say N.
-
-if PARAVIRT
+	help
+	  Say Y here to get to see options related to running Linux under
+	  various hypervisors.  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if PARAVIRT_GUEST
 
 source "arch/i386/xen/Kconfig"
 
 config VMI
 	bool "VMI Guest support"
+	select PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
@@ -239,6 +246,7 @@ config VMI
 
 config LGUEST_GUEST
 	bool "Lguest guest support"
+	select PARAVIRT
 	depends on !X86_PAE
 	help
 	  Lguest is a tiny in-kernel hypervisor.  Selecting this will
diff -r 8efa5fdb22d8 arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig	Wed Sep 19 11:23:18 2007 +1000
+++ b/arch/i386/xen/Kconfig	Wed Sep 19 11:25:07 2007 +1000
@@ -4,6 +4,7 @@
 
 config XEN
 	bool "Xen guest support"
+	select PARAVIRT
 	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
 	help
 	  This is the Linux Xen port.  Enabling this will allow the


