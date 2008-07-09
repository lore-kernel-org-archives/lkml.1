Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYGINvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYGINvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYGINul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:50:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbYGINuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:50:40 -0400
Date: Wed, 9 Jul 2008 15:49:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [patch] x86, paravirt-spinlocks: fix boot hang (was: Re: [PATCH
	RFC 0/4] Paravirtual spinlocks)
Message-ID: <20080709134944.GA15190@elte.hu>
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu> <20080709133358.GA7005@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709133358.GA7005@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> the patches caused a boot hang with this config:
> 
>  http://redhat.com/~mingo/misc/config-Wed_Jul__9_14_47_04_CEST_2008.bad

ok, fixed it via the patch below.

	Ingo

-------------->
commit 6412367fe22dc54cc727e7bec5bd65c36c1a0754
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 15:42:09 2008 +0200

    x86, paravirt-spinlocks: fix boot hang
    
    the paravirt-spinlock patches caused a boot hang with this config:
    
     http://redhat.com/~mingo/misc/config-Wed_Jul__9_14_47_04_CEST_2008.bad
    
    i have bisected it down to:
    
    |  commit e17b58c2e85bc2ad2afc07fb8d898017c2b75ed1
    |  Author: Jeremy Fitzhardinge <jeremy@goop.org>
    |  Date:   Mon Jul 7 12:07:53 2008 -0700
    |
    |      xen: implement Xen-specific spinlocks
    
    i.e. applying that patch alone causes the hang. The hang happens in the
    ftrace self-test:
    
      initcall utsname_sysctl_init+0x0/0x19 returned 0 after 0 msecs
      calling  init_sched_switch_trace+0x0/0x4c
      Testing tracer sched_switch: PASSED
      initcall init_sched_switch_trace+0x0/0x4c returned 0 after 167 msecs
      calling  init_function_trace+0x0/0x12
      Testing tracer ftrace:
      [hard hang]
    
    it should have continued like this:
    
      Testing tracer ftrace: PASSED
      initcall init_function_trace+0x0/0x12 returned 0 after 198 msecs
      calling  init_irqsoff_tracer+0x0/0x14
      Testing tracer irqsoff: PASSED
      initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 3 msecs
      calling  init_mmio_trace+0x0/0x12
      initcall init_mmio_trace+0x0/0x12 returned 0 after 0 msecs
    
    the problem is that such lowlevel primitives as spinlocks should never
    be built with -pg (which ftrace does). Marking paravirt.o as non-pg and
    marking all spinlock ops as always-inline solve the hang.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2dd1ccd..faba669 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -7,10 +7,11 @@ extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinu
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
 ifdef CONFIG_FTRACE
-# Do not profile debug utilities
+# Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc_64.o = -pg
 CFLAGS_REMOVE_tsc_32.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
+CFLAGS_REMOVE_paravirt.o = -pg
 endif
 
 #
