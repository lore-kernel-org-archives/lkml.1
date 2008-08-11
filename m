Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYHKUoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYHKUoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYHKUog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:44:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYHKUof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:44:35 -0400
Date: Mon, 11 Aug 2008 22:44:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Max Krasnyansky <maxk@qualcomm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080811204404.GD10774@elte.hu>
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com> <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org> <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com> <b6a2187b0808060833gc9d02caw2893ae8b021d1aa2@mail.gmail.com> <20080811195939.GA16716@elte.hu> <86802c440808111303x16922f43g4e17fa43972e9076@mail.gmail.com> <20080811200808.GB24111@elte.hu> <86802c440808111312n49ce2c0akae18b539ad543410@mail.gmail.com> <86802c440808111336o1dbffbb0xf551b4feb54b231c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808111336o1dbffbb0xf551b4feb54b231c@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86: move def_to_bigsmp check later
> 
> and skip the apicid id > 8

applied to tip/x86/urgent - thanks Yinghai. While we are touching this 
code i cleaned up the printk a bit: the line breaking was way too ugly, 
and the message not very informative about the effects of this problem. 
See the full commit below.

	Ingo

--------------->
>From b74548e76a0eab1f29546e7c5a589429c069a680 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Mon, 11 Aug 2008 13:36:04 -0700
Subject: [PATCH] x86: fix 2.6.27rc1 cannot boot more than 8CPUs

Jeff Chua reported that booting a !bigsmp kernel on a 16-way box
hangs silently.

this is a long-standing issue, smp start AP cpu could check the
apic id >=8 etc before trying to start it.

achieve this by moving the def_to_bigsmp check later and skip the
apicid id > 8

[ mingo@elte.hu: clean up the message that is printed. ]

Reported-by: "Jeff Chua" <jeff.chua.linux@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

 arch/x86/kernel/setup.c   |    6 ------
 arch/x86/kernel/smpboot.c |   10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)
---
 arch/x86/kernel/setup.c   |    6 ------
 arch/x86/kernel/smpboot.c |   10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6e5823b..68b48e3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -861,12 +861,6 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 	ioapic_init_mappings();
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
-	if (def_to_bigsmp)
-		printk(KERN_WARNING "More than 8 CPUs detected and "
-			"CONFIG_X86_PC cannot handle it.\nUse "
-			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
-#endif
 	kvm_guest_init();
 
 	e820_reserve_resources();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index da10f07..91055d7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -994,7 +994,17 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	flush_tlb_all();
 	low_mappings = 1;
 
+#ifdef CONFIG_X86_PC
+	if (def_to_bigsmp && apicid > 8) {
+		printk(KERN_WARNING
+			"More than 8 CPUs detected - skipping them.\n"
+			"Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
+		err = -1;
+	} else
+		err = do_boot_cpu(apicid, cpu);
+#else
 	err = do_boot_cpu(apicid, cpu);
+#endif
 
 	zap_low_mappings();
 	low_mappings = 0;
