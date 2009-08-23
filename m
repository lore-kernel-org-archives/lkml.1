Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbZHWCs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbZHWCs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 22:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbZHWCs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 22:48:57 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:61735 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbZHWCs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 22:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XNwygQ0+FIq7y5wVCocb4NWfZpOjVslZCcu9hC+VdeO64osG93kVauU6LaTr+8MPjN
         FI7PptDgmqFTMu3z9+c6T85pD7YSQdf1nquhGFlm+RTfadqk8RMDFywNJoWaFB2rha16
         ZrdbM3aFnCFierLOEQ3isETrXVo9/xaMMWF7I=
MIME-Version: 1.0
In-Reply-To: <1247059996.6595.36.camel@pc1117.cambridge.arm.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1247059996.6595.36.camel@pc1117.cambridge.arm.com>
Date: Sun, 23 Aug 2009 10:48:57 +0800
Message-ID: <d82e647a0908221948q380c3365v827c93c549d5f084@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/8 Catalin Marinas <catalin.marinas@arm.com>:
> Hi Ingo,
>
> On Wed, 2009-07-01 at 11:30 +0200, Ingo Molnar wrote:
>> * Catalin Marinas <catalin.marinas@arm.com> wrote:
>>
>> > > The minimal fix below removes scan_yield() and adds a
>> > > cond_resched() to the outmost (safe) place of the scanning
>> > > thread. This solves the regression.
>> >
>> > With CONFIG_PREEMPT disabled it won't reschedule during the bss
>> > scanning but I don't see this as a real issue (task stacks
>> > scanning probably takes longer anyway).
>>
>> Yeah. I suspect one more cond_resched() could be added - i just
>> didnt see an obvious place for it, given that scan_block() is being
>> called with asymetric held-locks contexts.
>
> I tried with a few cond_resched() calls in the kmemleak_scan() function
> but it looks like a significant (well, 1-2 seconds, depending on the
> hardware) amount of time is spent in scanning the data and bss sections.
> The patch below makes the system with !PREEMPT more responsive during
> the scanning episodes.
>
> Are you ok with this approach? Thanks.
>
>
> kmemleak: Add more cond_resched() calls in the scanning thread
>
> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Following recent fix to no longer reschedule in the scan_block()
> function, the system may become unresponsive with !PREEMPT. This patch
> re-adds the cond_resched() call to scan_block() but conditioned by the
> allow_resched parameter.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/kmemleak.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 6006553..93f1481 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -807,7 +807,7 @@ static int scan_should_stop(void)
>  * found to the gray list.
>  */
>  static void scan_block(void *_start, void *_end,
> -                      struct kmemleak_object *scanned)
> +                      struct kmemleak_object *scanned, int allow_resched)
>  {
>        unsigned long *ptr;
>        unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
> @@ -818,6 +818,8 @@ static void scan_block(void *_start, void *_end,
>                unsigned long pointer = *ptr;
>                struct kmemleak_object *object;
>
> +               if (allow_resched)
> +                       cond_resched();
>                if (scan_should_stop())
>                        break;
>
> @@ -881,12 +883,12 @@ static void scan_object(struct kmemleak_object *object)
>                goto out;
>        if (hlist_empty(&object->area_list))
>                scan_block((void *)object->pointer,
> -                          (void *)(object->pointer + object->size), object);
> +                          (void *)(object->pointer + object->size), object, 0);
>        else
>                hlist_for_each_entry(area, elem, &object->area_list, node)
>                        scan_block((void *)(object->pointer + area->offset),
>                                   (void *)(object->pointer + area->offset
> -                                           + area->length), object);
> +                                           + area->length), object, 0);
>  out:
>        spin_unlock_irqrestore(&object->lock, flags);
>  }
> @@ -931,14 +933,14 @@ static void kmemleak_scan(void)
>        rcu_read_unlock();
>
>        /* data/bss scanning */
> -       scan_block(_sdata, _edata, NULL);
> -       scan_block(__bss_start, __bss_stop, NULL);
> +       scan_block(_sdata, _edata, NULL, 1);
> +       scan_block(__bss_start, __bss_stop, NULL, 1);
>
>  #ifdef CONFIG_SMP
>        /* per-cpu sections scanning */
>        for_each_possible_cpu(i)
>                scan_block(__per_cpu_start + per_cpu_offset(i),
> -                          __per_cpu_end + per_cpu_offset(i), NULL);
> +                          __per_cpu_end + per_cpu_offset(i), NULL, 1);
>  #endif
>
>        /*
> @@ -960,7 +962,7 @@ static void kmemleak_scan(void)
>                        /* only scan if page is in use */
>                        if (page_count(page) == 0)
>                                continue;
> -                       scan_block(page, page + 1, NULL);
> +                       scan_block(page, page + 1, NULL, 1);
>                }
>        }
>
> @@ -972,7 +974,8 @@ static void kmemleak_scan(void)
>                read_lock(&tasklist_lock);
>                for_each_process(task)
>                        scan_block(task_stack_page(task),
> -                                  task_stack_page(task) + THREAD_SIZE, NULL);
> +                                  task_stack_page(task) + THREAD_SIZE,
> +                                  NULL, 0);
>                read_unlock(&tasklist_lock);
>        }
>

This still exits in 2.6.31-rc7 if kmemcheck is enabled, and isn't  the patch
merged into mainline?

Thanks.

[    0.006569] ACPI: Core revision 20090521
[    0.011476] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.011558] no locks held by swapper/0.
[    0.011561] Modules linked in:
[    0.011566] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.011569] Call Trace:
[    0.011577]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.011584]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.011590]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.011596]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.011600]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.011604]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.011609]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.011614]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.011620]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.011625]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.011630]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.011635]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.011640]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.011645]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.011650]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.011656]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.011661]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.011666]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.011670]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.011675]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.012058] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.012135] no locks held by swapper/0.
[    0.012138] Modules linked in:
[    0.012141] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.012144] Call Trace:
[    0.012148]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.012153]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.012157]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.012162]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.012166]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.012170]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.012175]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.012180]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.012184]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.012189]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.012194]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.012199]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.012204]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.012209]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.012213]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.012217]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.012222]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.012226]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.012231]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.012235]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.021056] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.021134] no locks held by swapper/0.
[    0.021136] Modules linked in:
[    0.021140] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.021143] Call Trace:
[    0.021147]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.021152]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.021156]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.021161]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.021167]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.021172]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.021177]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.021181]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.021186]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.021190]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.021195]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.021200]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.021205]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.021210]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.021215]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.021219]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.021223]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.021228]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.021232]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.021236]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.021241]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.030047] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.030127] no locks held by swapper/0.
[    0.030129] Modules linked in:
[    0.030133] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.030135] Call Trace:
[    0.030140]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.030145]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.030149]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.030153]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.030158]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.030162]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.030167]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.030171]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.030176]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.030181]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.030186]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.030190]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.030196]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.030200]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.030204]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.030209]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.030213]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.030217]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.030222]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.030226]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.039062] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.039141] no locks held by swapper/0.
[    0.039143] Modules linked in:
[    0.039147] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.039150] Call Trace:
[    0.039154]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.039159]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.039164]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.039168]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.039172]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.039177]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.039181]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.039186]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.039190]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.039195]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.039200]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.039205]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.039210]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.039215]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.039219]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.039223]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.039228]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.039232]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.039236]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.039241]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.048030] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.048108] no locks held by swapper/0.
[    0.048111] Modules linked in:
[    0.048115] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.048117] Call Trace:
[    0.048122]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.048126]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.048131]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.048135]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.048140]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.048145]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.048150]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.048154]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.048158]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.048163]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.048168]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.048173]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.048178]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.048183]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.048187]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.048192]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.048196]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.048200]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.048205]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.048209]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.048214]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.057134] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.057213] no locks held by swapper/0.
[    0.057215] Modules linked in:
[    0.057219] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.057221] Call Trace:
[    0.057226]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.057231]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.057235]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.057239]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.057244]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.057248]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.057253]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.057257]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.057262]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.057267]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.057272]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.057277]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.057282]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.057286]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.057290]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.057295]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.057299]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.057304]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.057308]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.057313]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.066077] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.066156] no locks held by swapper/0.
[    0.066158] Modules linked in:
[    0.066162] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.066165] Call Trace:
[    0.066169]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.066174]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.066179]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.066183]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.066188]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.066192]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.066197]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.066201]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.066206]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.066211]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.066216]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.066221]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.066226]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.066230]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.066235]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.066239]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.066243]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.066248]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.066252]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.066257]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.075010] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.075088] no locks held by swapper/0.
[    0.075090] Modules linked in:
[    0.075094] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.075097] Call Trace:
[    0.075101]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.075106]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.075111]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.075115]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.075120]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.075124]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.075129]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.075133]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.075138]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.075143]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.075148]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.075152]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.075158]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
[    0.075162]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.075166]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.075171]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.075175]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.075180]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.075184]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.075189]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.084057] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.084136] no locks held by swapper/0.
[    0.084139] Modules linked in:
[    0.084143] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.084145] Call Trace:
[    0.084150]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.084155]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.084159]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.084163]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.084169]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.084173]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.084178]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.084183]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.084187]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.084191]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.084196]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.084201]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.084206]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.084211]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.084216]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.084220]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.084225]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.084229]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.084233]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.084238]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.084242]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.093045] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.093126] no locks held by swapper/0.
[    0.093128] Modules linked in:
[    0.093132] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.093134] Call Trace:
[    0.093139]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.093143]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.093148]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.093152]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.093157]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.093161]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.093166]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.093170]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.093175]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.093180]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.093185]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.093190]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.093195]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.093199]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.093203]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.093208]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.093212]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.093217]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.093221]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.093226]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.102024] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.102104] no locks held by swapper/0.
[    0.102106] Modules linked in:
[    0.102110] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.102112] Call Trace:
[    0.102117]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.102122]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.102126]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.102130]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.102136]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.102141]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.102145]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.102150]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.102154]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.102159]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.102164]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.102169]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.102173]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.102179]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.102183]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.102187]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.102192]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.102196]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.102201]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.102205]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.102210]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.111000] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.111078] no locks held by swapper/0.
[    0.111081] Modules linked in:
[    0.111085] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.111087] Call Trace:
[    0.111092]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.111097]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.111101]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.111105]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.111111]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.111116]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.111120]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.111125]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.111129]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.111134]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.111139]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.111144]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.111149]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.111154]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.111158]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.111163]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.111167]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.111172]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.111176]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.111181]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.111185]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.120108] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.120186] no locks held by swapper/0.
[    0.120189] Modules linked in:
[    0.120193] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.120195] Call Trace:
[    0.120200]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.120205]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.120209]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.120213]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.120219]  [<ffffffff811bbd5f>] ? acpi_os_release_object+0xe/0x12
[    0.120223]  [<ffffffff811db561>] ? acpi_ps_free_op+0x27/0x29
[    0.120228]  [<ffffffff811db28b>] ? acpi_ps_delete_parse_tree+0x43/0x60
[    0.120232]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.120237]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.120241]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.120246]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.120251]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.120256]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.120261]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.120266]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.120270]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.120275]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.120279]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.120283]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.120288]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.120293]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
[    0.129041] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.129120] no locks held by swapper/0.
[    0.129122] Modules linked in:
[    0.129126] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
[    0.129129] Call Trace:
[    0.129133]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
[    0.129138]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
[    0.129143]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
[    0.129147]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
[    0.129152]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
[    0.129156]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
[    0.129161]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
[    0.129165]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
[    0.129170]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
[    0.129175]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
[    0.129180]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
[    0.129185]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
[    0.129190]  [<ffffffff811d91d1>] acpi_ns_parse_table+0x35/0x3c
[    0.129195]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
[    0.129199]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
[    0.129203]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
[    0.129208]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
[    0.129212]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
[    0.129217]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
[    0.129221]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106


-- 
Lei Ming
