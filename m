Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYBQAYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYBQAYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYBQAYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:24:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36036 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYBQAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:24:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2.6.25-rc2-mm1: build failure (x86)
Date: Sun, 17 Feb 2008 01:22:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Russell Leidich <rml@google.com>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216030949.5b11ba4c.akpm@linux-foundation.org> <20080216113722.GA9041@joi>
In-Reply-To: <20080216113722.GA9041@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802170122.12669.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of February 2008, Marcin Slusarz wrote:
> On Sat, Feb 16, 2008 at 03:09:49AM -0800, Andrew Morton wrote:
> > On Sat, 16 Feb 2008 11:59:07 +0100 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > 
> > > arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> > > (.text+0xe03b): undefined reference to `mce_log_therm_throt_event'

This one is easily fixed by the appended patch (whether it works is a separate
issue, though).

> > > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > > (.text+0x12239): undefined reference to `setup_trampoline'
> > > 
> > > #
> > > # Automatically generated make config: don't edit
> > > # Linux kernel version: 2.6.25-rc2-mm1
> > > # Sat Feb 16 11:32:49 2008
> > 
> > ho hum, thanks.  I think I'll drop x86-amd-thermal-interrupt-support.patch.
> >  I don't think it's the final version anwyay.
> > 
> Ok, I had to revert x86-remove-pt_regs-arg-from-smp_thermal_interrupt before x86-amd-thermal-interrupt-support.
> 
> Second error vanished when I reverted "suspend: wakeup code in C".

It will compile if you set CONFIG_SMP.  Working on a fix.

Thanks,
Rafael


---
 arch/x86/kernel/cpu/mcheck/mce_64.c      |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_thermal.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -317,7 +317,7 @@ void do_machine_check(struct pt_regs * r
 	atomic_dec(&mce_entry);
 }
 
-#ifdef CONFIG_X86_MCE_INTEL
+#ifdef CONFIG_X86_MCE
 /***
  * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
  * @cpu: The CPU on which the event occurred.
@@ -342,7 +342,7 @@ void mce_log_therm_throt_event(unsigned 
 	rdtscll(m.tsc);
 	mce_log(&m);
 }
-#endif /* CONFIG_X86_MCE_INTEL */
+#endif /* CONFIG_X86_MCE */
 
 /*
  * Periodic polling timer for "silent" machine check errors.  If the
Index: linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_thermal.h
===================================================================
--- linux-2.6.25-rc2-mm1.orig/arch/x86/kernel/cpu/mcheck/mce_thermal.h
+++ linux-2.6.25-rc2-mm1/arch/x86/kernel/cpu/mcheck/mce_thermal.h
@@ -4,5 +4,5 @@
 typedef void (*smp_thermal_interrupt_callback_t)(void);
 extern smp_thermal_interrupt_callback_t	smp_thermal_interrupt;
 
-void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
+extern void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
 
