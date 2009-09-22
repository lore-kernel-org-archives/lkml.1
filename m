Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZIVTaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZIVTaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIVTap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:30:45 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:41299 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbZIVTal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:30:41 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090920074247.GA5733@elte.hu>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
	 <1253419185.3253.21.camel@ank32.eng.vmware.com>
	 <20090920074247.GA5733@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 22 Sep 2009 12:30:45 -0700
Message-Id: <1253647845.10565.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, 2009-09-20 at 00:42 -0700, Ingo Molnar wrote:

> 
> The thing is, the overwhelming majority of vmware users dont benefit 
> from hardware features like nested page tables yet. So this needs to be 
> done _way_ more carefully, with a proper sunset period of a couple of 
> kernel cycles.

I am fine with that too. Below is a patch which adds notes in
feature-removal-schedule.txt, I have marked it for removal from 2.6.34.
Please consider this patch for 2.6.32.

> If we were able to rip out all (or most) of paravirt from arch/x86 it 
> would be tempting for other technical reasons - but the patch above is 
> well localized.

We can certainly look at removing some paravirt-hooks which are only
used by VMI. Not sure if there are any but will take a look when we
actually remove VMI.

Thanks,
Alok

--

Mark VMI for deprecation in feature-removal-schedule.txt.

From: Alok N Kataria <akataria@vmware.com>

Add text in feature-removal.txt and also modify Kconfig to disable
vmi by default.
Patch on top of tip/master.

Details about VMware's plan about retiring VMI  can be found here
http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html

---

 Documentation/feature-removal-schedule.txt |   24 ++++++++++++++++++++++++
 arch/x86/Kconfig                           |    8 +++++---
 2 files changed, 29 insertions(+), 3 deletions(-)


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index fa75220..b985328 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -459,3 +459,27 @@ Why:	OSS sound_core grabs all legacy minors (0-255) of SOUND_MAJOR
 	will also allow making ALSA OSS emulation independent of
 	sound_core.  The dependency will be broken then too.
 Who:	Tejun Heo <tj@kernel.org>
+
+----------------------------
+
+What:	Support for VMware's guest paravirtuliazation technique [VMI] will be
+	dropped.
+When:	2.6.34
+Why:	With the recent innovations in CPU hardware acceleration technologies
+	from Intel and AMD, VMware ran a few experiments to compare these
+	techniques to guest paravirtulization technique on VMware's platform.
+	These hardware assisted virtualization techniques have outperformed the
+	performance benefits provided by VMI in most of the workloads. VMware
+	expects that these hardware features will be ubiquitous in a couple of
+	years, as a result, VMware has started a phased retirement of this
+	feature from the hypervisor. We will be removing this feature from the
+	Kernel too, in a couple of releases.
+	Please note that VMI has always been an optimization and non-VMI kernels
+	still work fine on VMware's platform.
+
+	For more details about VMI retirement take a look at this,
+	http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html
+
+Who:	Alok N Kataria <akataria@vmware.com>
+
+----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e214f45..1f3e156 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -485,14 +485,16 @@ if PARAVIRT_GUEST
 source "arch/x86/xen/Kconfig"
 
 config VMI
-	bool "VMI Guest support"
-	select PARAVIRT
-	depends on X86_32
+	bool "VMI Guest support [will be deprecated soon]"
+	default n
+	depends on X86_32 && PARAVIRT
 	---help---
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
+	  VMware has started a phased retirement of this feature from there
+	  products. Please see feature-removal-schedule.txt for details.
 
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"


