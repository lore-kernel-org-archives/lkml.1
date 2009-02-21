Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZBUIcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZBUIcf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 03:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZBUIc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 03:32:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZBUIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 03:32:26 -0500
Date: Sat, 21 Feb 2009 09:32:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090221083212.GA1537@elte.hu>
References: <20090219171005.GA27922@elte.hu> <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 19 Feb 2009, Ingo Molnar wrote:
> >
> > Andi Kleen (3):
> >       x86, mce: reinitialize per cpu features on resume
> 
> This one causes
> 
>   WARNING: arch/x86/kernel/cpu/mcheck/built-in.o(.text+0xf72): Section mismatch in reference from the function mce_resume() to the function .cpuinit.text:mce_intel_feature_init()
>   The function mce_resume() references
>   the function __cpuinit mce_intel_feature_init().
>   This is often because mce_resume lacks a __cpuinit annotation or the annotation of mce_intel_feature_init is wrong.
> 
> which looks like a real bug.
> 
> On UP - withot CPU hotplug - I think __cpuinit becomes __init. 
> No? So now mce_resume() will call some function that was long 
> since free'd.

Indeed. hpa pushed the fix for it - it can be found below.

> I didn't look closer, but I wish somebody else would. And I 
> wish people looked at warnings that are introduced by their 
> new code before sending said changes to me.

Hm, i build and boot every tree i send to you, but this warning 
didnt pop up and i specifically watch for build warnings and 
section warnings in particular. (50% of all section warnings are 
real.)

And i dont see it in an allyesconfig build either. Weird.

After half an hour of head scratching (including two 
allyesconfig builds) i found these two gems commits that were 
merged in the last week or two:

| commit fa2144ba9a31d1d0dc9607508576c3850e0d95b1
| Author: Sam Ravnborg <sam@ravnborg.org>
| Date:   Fri Feb 15 13:53:11 2008 +0100
|
|     kbuild: explain why DEBUG_SECTION_MISMATCH is UNDEFINED
|    
|     We started to see patches enabling this - so explain why
|     it is disabled and the condition to enable it again.
|    
|     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
|
| diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
| index a370fe8..ab408aa 100644
| --- a/lib/Kconfig.debug
| +++ b/lib/Kconfig.debug
| @@ -82,6 +82,9 @@ config HEADERS_CHECK
|  config DEBUG_SECTION_MISMATCH
|         bool "Enable full Section mismatch analysis"
|         depends on UNDEFINED
| +       # This option is on purpose disabled for now.
| +       # It will be enabled when we are down to a resonable number
| +       # of section mismatch warnings (< 10 for an allyesconfig build)

| commit e5f95c8b7700a7bf1c2d24eedc677954d9aa0285
| Author: Sam Ravnborg <sam@ravnborg.org>
| Date:   Sat Feb 2 18:57:18 2008 +0100
|
|     kbuild: print only total number of section mismatces found
|    
|     We have too many section mismatches detected at the moment.
|     So silence modpost and prevent the option from being
|     set in a typical allyesconfig build.
|    
|     Tell the user how to see all the deteils in the summary
|     message from modpost.
|     
|     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

These commits are an utter joke.

Sam, i virtually _begged_ you a few months ago to actually turn 
section warnings into hard build failures, because 50% of the 
time the warnings show real bugs and we want to fix real bugs 
not hide them. Having them as build failures and not as warnings 
is the only way to realistically fix them, in the current 
upstream kernel climate.

Not only didnt what i suggest happen, but apparently this useful 
debug feature got turned _off_ in rc5, silently :-( This broke 
my push-to-Linus qa.

And the thing is, this commit log title:

  kbuild: print only total number of section mismatces found

is utterly deceiving as well. It should have been:

  kbuild: disable CONFIG_DEBUG_SECTION_MISMATCH

(i'd probably have noticed that patch - i check every patch 
title that goes upstream.)

I've now worked it around in tip:master but that's not a good 
solution because when i send a tree to Linus i build _that 
specific tree_, with _zero_ additional patches, to make sure 
that what i send to Linus is sane. (to make sure that none of 
our other fixes/changes in tip:master interact, etc.)

So these patches need to be reverted in -rc6.

	Ingo

------------------------->
>From cc3ca22063784076bd240fda87217387a8f2ae92 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Fri, 20 Feb 2009 23:35:51 -0800
Subject: [PATCH] x86, mce: remove incorrect __cpuinit for mce_cpu_features()

Impact: Bug fix on UP

Checkin 6ec68bff3c81e776a455f6aca95c8c5f1d630198:
    x86, mce: reinitialize per cpu features on resume

introduced a call to mce_cpu_features() in the resume path, in order
for the MCE machinery to get properly reinitialized after a resume.
However, this function (and its successors) was flagged __cpuinit,
which becomes __init on UP configurations (on SMP suspend/resume
requires CPU hotplug and so this would not be seen.)

Remove the offending __cpuinit annotations for mce_cpu_features() and
its successor functions.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c       |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 25cf624..fe79985 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -490,7 +490,7 @@ static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 
 }
 
-static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
+static void mce_cpu_features(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 8ae8c4f..f2ee0ae 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -121,7 +121,7 @@ static long threshold_restart_bank(void *_tr)
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
-void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
+void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
 	unsigned int bank, block;
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 4b48f25..f44c366 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -30,7 +30,7 @@ asmlinkage void smp_thermal_interrupt(void)
 	irq_exit();
 }
 
-static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
+static void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int tm2 = 0;
@@ -84,7 +84,7 @@ static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
 	return;
 }
 
-void __cpuinit mce_intel_feature_init(struct cpuinfo_x86 *c)
+void mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
 	intel_init_thermal(c);
 }
