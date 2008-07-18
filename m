Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbYGRQmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbYGRQmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYGRQl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:41:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759542AbYGRQl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:41:56 -0400
Date: Fri, 18 Jul 2008 18:41:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       michael@free-electrons.com
Subject: Re: [patch 0/3] [x86] Configure out CPU-specific support code
Message-ID: <20080718164146.GB6875@elte.hu>
References: <20080710151318.936860143@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710151318.936860143@free-electrons.com>
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


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Hi,
> 
> The purpose of this small patch series is to be able to configure out 
> x86 CPU-specific support code, in order to reduce the kernel code 
> size, particularly for embedded systems.
> 
> Reviews and comments welcome.

this interacted quite a bit with ongoing work in arch/x86. I have 
applied your first patch (it had some conflicts which i resolved.)

but much of #2 has already been done via:

| commit cc9f7a0ccf000d4db5fbdc7b0ae48eefea102f69
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Mon Jun 16 16:11:08 2008 -0700
|
|     x86: kill bad_ppro

this is now upstream. Likewise, #3 doesnt apply either. So could you 
please rework #2 and #3 against tip/x86/cpu? You can pull it via the 
coordinates below.

	Ingo

------------->
the latest x86/cpu git tree is at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/cpu

------------------>
Thomas Petazzoni (1):
      x86: consolidate the definition of the force_mwait variable


 arch/x86/kernel/cpu/amd.c   |    2 --
 arch/x86/kernel/process.c   |    1 +
 include/asm-x86/processor.h |    2 --
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 81a07ca..cae9cab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -24,8 +24,6 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-int force_mwait __cpuinitdata;
-
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpuid_eax(0x80000000) >= 0x80000007) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4d629c6..74f2d19 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,6 +15,7 @@ unsigned long idle_nomwait;
 EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
+static int force_mwait __cpuinitdata;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 55402d2..15cb82a 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -722,8 +722,6 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
-extern int			force_mwait;
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long		boot_option_idle_override;
