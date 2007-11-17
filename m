Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXKQJdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXKQJdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 04:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXKQJdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 04:33:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbXKQJdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 04:33:16 -0500
Date: Sat, 17 Nov 2007 10:32:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, ak@suse.de,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       tglx@linutronix.de, anthony@codemonkey.ws, akpm@linux-foundation.org
Subject: Re: [PATCH 5/24] smp x86 consolidation
Message-ID: <20071117093224.GA32256@elte.hu>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <4734FB67.8080500@goop.org> <4735098B.7040305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4735098B.7040305@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> > I'm getting link errors in 32-bit:
> > 
> > arch/x86/kernel/built-in.o: In function `native_smp_send_reschedule':
> > /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/smpcommon.c:262: undefined reference to `genapic'
> > arch/x86/kernel/built-in.o: In function `native_smp_call_function_mask':
> > /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/smpcommon.c:113: undefined reference to `genapic'
> > 
> Ok, it compiled just fine here. I bet it's due to  one of that i386 lots
> of variants.

this patch is causing build failures all around the place. It does not 
build on CONFIG_X86_SUMMIT, it does not build if CONFIG_X86_GENERICARCH 
is turned off, etc. It does not even build on UP - fix for that is 
attached below. I've dropped this patch for now.

	Ingo

-------------->
Subject: x86: fix build error
From: Ingo Molnar <mingo@elte.hu>

fix build error on !CONFIG_SMP.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/smp.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/include/asm-x86/smp.h
===================================================================
--- linux.orig/include/asm-x86/smp.h
+++ linux/include/asm-x86/smp.h
@@ -2,6 +2,7 @@
 #define _X86_SMP_H_
 
 #ifndef __ASSEMBLY__
+#ifdef CONFIG_SMP
 struct smp_ops
 {
 	void (*smp_prepare_boot_cpu)(void);
@@ -55,6 +56,7 @@ void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
 void native_smp_cpus_done(unsigned int max_cpus);
+#endif
 
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
