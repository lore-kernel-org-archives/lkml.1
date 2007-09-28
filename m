Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXI1JKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXI1JKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXI1JKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:10:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbXI1JKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:10:35 -0400
Date: Fri, 28 Sep 2007 02:09:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397
 smp_call_function_mask()
Message-Id: <20070928020950.bdcad2c2.akpm@linux-foundation.org>
In-Reply-To: <46FCC0B8.7090403@bull.net>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<390947257.08622@ustc.edu.cn>
	<46FCC0B8.7090403@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:52:08 +0200 Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Fengguang Wu wrote:
> > On Thu, Sep 27, 2007 at 02:22:20AM -0700, Andrew Morton wrote:
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> >  
> > Laurent,
> > 
> > It triggered a WARNING on first run in qemu:
> 
> Thank you to report it.
> 
> > 
> > [    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
> > [    0.310000]
> > [    0.310000] Call Trace:
> > [    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
> > [    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
> > [    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
> > [    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
> > [    0.310000]  [<ffffffff8101cd69>] smp_call_function+0x19/0x20
> > [    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
> > [    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
> > [    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
> > [    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x150
> > [    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
> > [    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
> > [    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140
> 
> 
> the reason is the WARN_ON():
> 
> 390 int smp_call_function_mask(cpumask_t mask,
> 391                            void (*func)(void *), void *info,
> 392                            int wait)
> 393 {
> 394         int ret;
> 395
> 396         /* Can deadlock when called with interrupts disabled */
> 397         WARN_ON(irqs_disabled());
> 398
> 399         spin_lock(&call_lock);
> 400         ret = __smp_call_function_mask(mask, func, info, wait);
> 401         spin_unlock(&call_lock);
> 402         return ret;
> 403 }
> 
> The patch I sent to Andi didn't include this WARN_ON() and it's why I didn't
> find this issue. (see http://lkml.org/lkml/2007/8/24/101)
> 
> smp_call_function_mask() is called by smp_call_function() which calls a function
> on all CPU except current.
> The comment of smp_call_function() specifies:
> ...
>  * You must not call this function with disabled interrupts or from a
>  * hardware interrupt handler or from a bottom half handler.
>  * Actually there are a few legal cases, like panic.
>  */
> 
> So this WARN_ON() is correct, and the caller (global_flush_tlb()) doesn't follow
> this rule.
> 
> I guess this WARN_ON() is only needed when we have current CPU in provided mask.
> So I think we should change:
> 
> int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
>                         int wait)
> {
>         return smp_call_function_mask(cpu_online_map, func, info, wait);
> }
> ("cpu_online_map" is a bad choice, comment also specifies: "run a function on
> all other CPU")
> 
> to
> 
> int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
>                         int wait)
> {
>         int ret;
> 	cpumask_t allbutself;
> 
> 	allbutself = cpu_online_map;
> 	cpu_clear(smp_processor_id(), allbutself);
> 
>         spin_lock(&call_lock);
>         ret = __smp_call_function_mask(allbutself, func, info, wait);
>         spin_unlock(&call_lock);
>         return ret;
> }
> (which is smp_call_function_mask() without the WARN_ON() and without current cpu
> in the mask)
> 
> Andi, is this correct ?
> Andrew, should I send a patch implementing this change ?

umm, I think all the smp_call_function fucntions are deadlocky if called
with local interrupts disabled, regardless of whether the calling CPU is in
the mask.

If CPU A is sending a cross-cpu call to CPU B and CPU B is sending a
cross-cpu call to CPU A, and they both have local interrupts disabled...

