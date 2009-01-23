Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZAWBn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZAWBn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZAWBnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:43:20 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52333 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbZAWBnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:43:19 -0500
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
From: john stultz <johnstul@us.ibm.com>
To: Miklos Vajna <vmiklos@frugalware.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?ISO-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
In-Reply-To: <20090122235727.GB21473@genesis.frugalware.org>
References: <20090121171423.GI21473@genesis.frugalware.org>
	 <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com>
	 <20090121210726.GK21473@genesis.frugalware.org>
	 <1232573646.6997.21.camel@localhost.localdomain>
	 <20090122195132.GZ21473@genesis.frugalware.org>
	 <20090122235727.GB21473@genesis.frugalware.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 17:43:14 -0800
Message-Id: <1232674994.6678.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 00:57 +0100, Miklos Vajna wrote:
> On Thu, Jan 22, 2009 at 12:03:14PM -0800, john stultz 
> > CONFIG_X86_VISWS: If I recall, this is support for SGI workstations that
> > had different apics then most systems, and might be related.
> > 
> I just did a new build with CONFIG_X86_VISWS and CONFIG_X86_RDC321X
> disabled, but I kept CONFIG_PARAVIRT_GUEST enabled and that works fine
> as well. So CONFIG_PARAVIRT_GUEST seems to be unrelated.

Ah. CONFIG_X86_RDC321X is indeed the issue.

>From arch/x86/include/asm/timex.h:

#ifdef CONFIG_X86_ELAN
#  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
#elif defined(CONFIG_X86_RDC321X)
#  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
#else
#  define PIT_TICK_RATE 1193182 /* Underlying HZ */
#endif


This gives the kernel an incorrect slower frequency for the PIT hardware
on your system and is why the TSC calibration is off and why the ACPI PM
gets thrown out.

I'd think this would ideally be more of a subarch in the config
selection like the AMD Elan is, so folks know it really is not just a
extra-support feature and in fact limits what hardware you can use the
resulting kernel on.

Florian, any thoughts on this? Would a patch like the following
(untested) be ok by you?

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 862adb9..6d8ac94 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -300,6 +300,16 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
+config X86_RDC321X
+	bool "RDC R-321x SoC"
+	depends on X86_32
+	select M486
+	select X86_REBOOTFIXUPS
+	help
+	  This option is needed for RDC R-321x system-on-chip, also known
+	  as R-8610-(G).
+	  If you don't have one of these chips, you should say N here.
+
 config X86_VOYAGER
 	bool "Voyager (NCR)"
 	depends on X86_32 && (SMP || BROKEN) && !PCI
@@ -380,16 +390,6 @@ config X86_VISWS
 	  A kernel compiled for the Visual Workstation will run on general
 	  PCs as well. See <file:Documentation/sgi-visws.txt> for details.
 
-config X86_RDC321X
-	bool "RDC R-321x SoC"
-	depends on X86_32
-	select M486
-	select X86_REBOOTFIXUPS
-	help
-	  This option is needed for RDC R-321x system-on-chip, also known
-	  as R-8610-(G).
-	  If you don't have one of these chips, you should say N here.
-
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"




