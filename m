Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZBZLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZBZLlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZBZLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:41:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZBZLlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:41:15 -0500
Date: Thu, 26 Feb 2009 12:41:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove update_apic from x86_quirks
Message-ID: <20090226114103.GA6651@elte.hu>
References: <49A61FA9.5080706@kernel.org> <20090226053254.GA11806@elte.hu> <20090226053426.GA23744@elte.hu> <20090226054305.GA13545@elte.hu> <49A650B3.8080902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A650B3.8080902@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > except that it doesnt build:
> > 
> > arch/x86/kernel/built-in.o:(.data+0x8c08): undefined reference to `wakeup_secondary_cpu_via_init'
> > arch/x86/kernel/built-in.o:(.data+0x8d68): undefined reference to `wakeup_secondary_cpu_via_init'
> > arch/x86/kernel/built-in.o:(.data+0x8ec8): undefined reference to `wakeup_secondary_cpu_via_init'
> > arch/x86/kernel/built-in.o:(.data+0x9038): undefined reference to `wakeup_secondary_cpu_via_init'
> > 
> 
> .config?

There's no need for a config :)

When introducing a widely used symbol as 
wakeup_secondary_cpu_via_init(), the first thing to check is to 
make sure it's built in widely enough:

$ git grep wakeup_secondary_cpu_via_init

arch/x86/include/asm/apic.h:extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
arch/x86/kernel/apic/apic_flat_64.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/apic_flat_64.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/bigsmp_32.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/es7000_32.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/probe_32.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/summit_32.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/x2apic_cluster.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/apic/x2apic_phys.c:	.wakeup_cpu			= wakeup_secondary_cpu_via_init,
arch/x86/kernel/smpboot.c:wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)

as you can see it's defined in arch/x86/kernel/smpboot.c - 
which, as its name already tells us, is only built on SMP. 

There's other usage though, like 
arch/x86/kernel/apic/probe_32.c, which is built on 
CONFIG_X86_LOCAL_APIC=y, which can be enabled on !SMP as well.

Since on SMP we are not likely to boot other CPUs via 
apic->wakeup_cpu(), i suspect we need a !SMP inline for 
wakeup_secondary_cpu_via_init()?

	Ingo
