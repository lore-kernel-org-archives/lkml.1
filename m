Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbZFKL4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbZFKL4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFKL4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:56:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50089 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFKL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:56:11 -0400
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
In-Reply-To: <20090611114814.GB13391@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
	 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
	 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
	 <20090611113512.GA6971@elte.hu> <20090611114032.GA8856@elte.hu>
	 <20090611114203.GA13391@elte.hu>  <20090611114814.GB13391@elte.hu>
Date: Thu, 11 Jun 2009 14:56:11 +0300
Message-Id: <1244721371.17483.31.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 13:48 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Hm, with this pulled on a testbox i'm still getting:
> > > 
> > > [    0.000000] Experimental hierarchical RCU init done.
> > > [    0.000000] NR_IRQS:4352 nr_irqs:256
> > > [    0.000000] ------------[ cut here ]------------
> > > [    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x40/0x7e()
> > 
> > Another testbox crashed on bootup. I'm collecting a serial log 
> > from it - config attached meanwhile.
> 
> We have a hard crash in the WP-protect code:
> 
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
> [    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
> [    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
> [    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
> [    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
> [    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
> [    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
> [    0.000000] Call Trace:
> [    0.000000]  [<c15357c2>] ? printk+0x14/0x16
> [    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
> [    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
> [    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
> [    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
> [    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
> [    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f
> 
> (full bootlog attached)
> 
> Just a quick analysis from the place we crash (without looking into 
> any details): the WP test is the first time we really make use of 
> the MMU during bootup - crashes there are often a sign of messed up 
> pagetables, which is easy if the bootmem allocator is changed.

No, mem_init() happens _before_ slab is set up so it's probably just
this.

And yes, the patch set clearly needs more work.

			Pekka

diff --git a/init/main.c b/init/main.c
index 859af21..6d38f96 100644
--- a/init/main.c
+++ b/init/main.c
@@ -588,6 +588,8 @@ asmlinkage void __init start_kernel(void)
 	 */
 	pidhash_init();
 	vfs_caches_init_early();
+	sort_main_extable();
+	trap_init();
 	/*
 	 * Set up kernel memory allocators
 	 */
@@ -610,8 +612,6 @@ asmlinkage void __init start_kernel(void)
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
-	sort_main_extable();
-	trap_init();
 	rcu_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();


