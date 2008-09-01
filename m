Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbYIAUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbYIAUXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYIAUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:23:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:35510 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYIAUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:23:14 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Mon, 1 Sep 2008 16:23:11 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org> <200808311603.49056.linux@sandersweb.net>
In-Reply-To: <200808311603.49056.linux@sandersweb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011623.12518.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008 16:03, David Sanders wrote:
> On Sunday 31 August 2008 14:47, Linus Torvalds wrote:
> > On Sun, 31 Aug 2008, David Sanders wrote:
> > > I recently discovered that x86 kernels won't boot under Virtual PC.
> >
> > What CPU does Virtual PC emulate? As far as Wikipedia is concerned (not
> > that I'd take it on complete faith) it emulates a 32-bit Intel Pentium
> > II.
> >
> > And that commit makes the kernel use the "P6 nops" for such hardware.
> > Maybe Virtual PC doesn't support the newer intel nop things?
> >
> > Intel docs say that it should be available on any intel CPU that has
> > CPUID.01H.EAX[11:8] = 0110B or 1111B. That's the "family ID", and Pentium
> > II should have a family ID of 6 (ie that 0110B case).
> >
> > So it sounds like a Virtual PC bug, but I dunno. And maybe we should just
> > use the legcay nops for anything that isn't modern (ie P4+ or Core)?
> >
> > 		Linus
>
> Virtual PC does not emulate a processor like it does with the motherboard,
> video, NIC ,etc.  What you see in the virtual machine is the actual
> processor, except that Virtual PC looks at all of your instructions and
> modifies ring 0 code and the like.  It may be that Virtual PC was not
> designed with an awareness of these nops that the commit added.
>
> I would suggest an configuration option to select legacy-nops or newer-nops
> and a kernel boot-time parameter so it can be disabled to allow
> installation of a distribution for example.
>
> I would be happy to submit such a patch if you agree (or I'll try to
> anyway).

OK, below is my patch.  The problem is I just built with it and the boot 
problem still exists.  Either the patch is flawed or git-bisect gave me the 
wrong commit.  Any help would be appreciated.
David

Signed-off-by: David Sanders <linux@sandersweb.net>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..a38f362 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -445,6 +445,13 @@ config PARAVIRT_DEBUG
          Enable to debug paravirt_ops internals.  Specifically, BUG if
 	 a paravirt_op is missing when it is called.
 
+config INTEL_NOPS
+	bool "Use legacy x86 NOPS"
+	depends on X86_32
+	help
+	This option tells kernel to use legacy x86 nops
+
+
 config MEMTEST
 	bool "Memtest"
 	help
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2763cb3..10713e4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -58,6 +58,16 @@ static int __init setup_noreplace_paravirt(char *str)
 __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #endif
 
+static int intel_legacy_nops = 0;
+
+static int __init setup_intel_legacy_nops(char *str)
+{
+	intel_legacy_nops = 1;
+	return 1;
+}
+
+__setup("intel-legacy-nops", setup_intel_legacy_nops);
+
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
@@ -167,12 +177,17 @@ const unsigned char *const *find_nop_table(void)
 	const unsigned char *const *noptable = intel_nops;
 	int i;
 
-	for (i = 0; noptypes[i].cpuid >= 0; i++) {
-		if (boot_cpu_has(noptypes[i].cpuid)) {
-			noptable = noptypes[i].noptable;
-			break;
+	if (!intel_legacy_nops) {
+#ifndef CONFIG_INTEL_NOPS
+		for (i = 0; noptypes[i].cpuid >= 0; i++) {
+			if (boot_cpu_has(noptypes[i].cpuid)) {
+				noptable = noptypes[i].noptable;
+				break;
+			}
 		}
+#endif /* CONFIG_INTEL_NOPS */
 	}
+
 	return noptable;
 }
