Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZHCFzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZHCFzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZHCFzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:55:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZHCFzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:55:13 -0400
Date: Mon, 3 Aug 2009 07:54:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
	pci-dma-compat.h
Message-ID: <20090803055441.GA19428@elte.hu>
References: <20090714092354.GL19087@amd.com> <20090714.131224.205307048.davem@davemloft.net> <20090718110620.GC27287@elte.hu> <20090802.202135.63875488.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802.202135.63875488.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 18 Jul 2009 13:06:20 +0200
> 
> > I'm wondering why sparc32 frees from the middle of the kernel 
> > image. The way architectures generally do it is to put freeable 
> > pages into a separate section. That way it does not get mingled 
> > with the kernel core image area (which stays nicely continuous).
> 
> It's conditionally free'able, we actually use the pages if the 
> system is SMP and has more than cpu 0 installed.

Sounds similar to the alternate instructions section on x86:

 arch/x86/kernel/alternative.c:

        if (smp_alt_once)
                free_init_pages("SMP alternatives",
                                (unsigned long)__smp_locks,
                                (unsigned long)__smp_locks_end);

It's in a separate section and linked + freed separately. The linker 
script page-aligns it:

 arch/x86/kernel/vmlinux.lds.S:

        /*
         * smp_locks might be freed after init
         * start/end must be page aligned
         */
        . = ALIGN(PAGE_SIZE);
        .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
                __smp_locks = .;
                *(.smp_locks)
                __smp_locks_end = .;
                . = ALIGN(PAGE_SIZE);
        }

So that it can be freed. It's also placed next to the regular init 
section to not create too many holes. It also keeps the 'kernel text 
area' continuous and things like core_kernel_text() & co still work 
fine.

	Ingo
