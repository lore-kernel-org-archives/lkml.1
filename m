Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZFIAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZFIAsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZFIAsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:48:04 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51982 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFIAsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FXJIjJZJWgERnGm9AfLzl9TKegwI7D/ydJwM2KsofclzC5sR4SpxfDpqzCDjztv6dn
         ti7ooR6NyQc0u4vTid4D1j/LYS1fGPTdTRHAg2ddHNtu98D3M7VyK3HQF6MGBDvdJZtc
         4Lh3iXpLURmwjIAqCzwgBe5pVoEiejUX8AYnY=
MIME-Version: 1.0
In-Reply-To: <20090608171501.GA15399@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	 <20090608081439.GB6372@elte.hu>
	 <20090608012845.9c428525.akpm@linux-foundation.org>
	 <a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com>
	 <20090608084807.GE6372@elte.hu>
	 <20090608092607.8b331bf0.akpm@linux-foundation.org>
	 <20090608171501.GA15399@elte.hu>
Date: Tue, 9 Jun 2009 08:48:03 +0800
Message-ID: <a8e1da0906081748t7e9bb6b2l66835f2d5112e8f1@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in 
	halt phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 1:15 AM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Mon, 8 Jun 2009 10:48:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>>
>> >
>> > * Dave Young <hidave.darkstar@gmail.com> wrote:
>> >
>> > > On Mon, Jun 8, 2009 at 4:28 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> > > > On Mon, 8 Jun 2009 10:14:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>> > > >
>> > > >>
>> > > >> * Dave Young <hidave.darkstar@gmail.com> wrote:
>> > > >>
>> > > >> > Add a halt_delay module parameter in printk.c used to read the
>> > > >> > printk messages in halt/poweroff/restart phase, delay each printk
>> > > >> > messages by halt_delay milliseconds. It is useful for debugging if
>> > > >> > there's no other way to dump kernel messages that time.
>> > > >> >
>> > > >> > The halt_delay max value is 65535, default value is 0, change it
>> > > >> > by:
>> > > >> >
>> > > >> > echo xxx > /sys/module/printk/parameters/halt_delay
>> > > >> >
>> > > >> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> > > >> > ---
>> > > >> > Documentation/kernel-parameters.txt | __ __5 +++++
>> > > >> > kernel/printk.c __ __ __ __ __ __ __ __ __ __ | __ 17 +++++++++++++++++
>> > > >> > 2 files changed, 22 insertions(+)
>> > > >> >
>> > > >> > --- linux-2.6.orig/kernel/printk.c __2009-06-08 13:55:35.000000000 +0800
>> > > >> > +++ linux-2.6/kernel/printk.c __ __ __ 2009-06-08 13:56:23.000000000 +0800
>> > > >> > @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
>> > > >> > __}
>> > > >> > __#endif
>> > > >> >
>> > > >> > +/* msecs delay after each halt/poweroff/restart phase printk,
>> > > >> > + unsigned short is enough for delay in milliseconds */
>> > > >> > +static unsigned short halt_delay;
>> > > >> > +
>> > > >> > +static inline void halt_delay_msec(void)
>> > > >> > +{
>> > > >> > + __ if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
>> > > >> > + __ __ __ __ __ __ __ __ __ __ __ __ __ || system_state == SYSTEM_POWER_OFF
>> > > >> > + __ __ __ __ __ __ __ __ __ __ __ __ __ || system_state == SYSTEM_RESTART)))
>> > > >> > + __ __ __ __ __ return;
>> > > >>
>> > > >> This is a tiny bit ugly (and goes into the vprintf path) but i can
>> > > >> see no other way either - a system_state > SYSTEM_RUNNING check
>> > > >> would needlessly include the suspend-to-disk state (which we dont
>> > > >> want to include here).
>> > > >>
>> > > >> In theory we could turn system_state into a bitmask and have a
>> > > >> print_delay_mask check instead of these flags ... but that is a far
>> > > >> wider change and i'm not sure it's a net step forwards.
>> > > >>
>> > > >> I've applied your patch to tip:core/printk with small edits to the
>> > > >> changelog - Linus & Andrew is Cc:ed, should they have any
>> > > >> objections.
>> > > >
>> > > > Could we not put just a single delay in there, immediately prior to halting,
>> > > > restarting or poweroffing?
>> > >
>> > > But, then prink messages will still flush too fast for us to see
>> > > the detail.
>>
>> Only if there are so many unlogged messages that they scroll of the
>> screen.  Is that the case?
>
> i have such an example in my logs:
>
> [  390.206118] md: stopping all md devices.
> [  391.208259] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  391.214877] igb 0000:01:00.1: PCI INT B disabled
> [  391.220445] igb 0000:01:00.0: PCI INT A disabled
> [  391.225897] Restarting system.
> [  391.229213] machine restart
> [  391.232833] ------------[ cut here ]------------
> [  391.237718] WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule+0x55/0x83()
> [  391.246276] Hardware name: X8DTN
> [  391.249762] Modules linked in:
> [  391.253146] Pid: 19807, comm: reboot Not tainted 2.6.30-rc8-tip #8
> [  391.259580] Call Trace:
> [  391.262287]  <IRQ>  [<ffffffff81021525>] ? native_smp_send_reschedule+0x55/0x83
> [  391.270136]  [<ffffffff8104a316>] warn_slowpath_common+0x77/0xa4
> [  391.276395]  [<ffffffff8104a352>] warn_slowpath_null+0xf/0x11
> [  391.282399]  [<ffffffff81021525>] native_smp_send_reschedule+0x55/0x83
> [  391.289182]  [<ffffffff8103629f>] resched_task+0x60/0x62
> [  391.294752]  [<ffffffff8103d976>] resched_cpu+0x4a/0x5e
> [  391.300237]  [<ffffffff8104627f>] scheduler_tick+0x19a/0x249
> [  391.306154]  [<ffffffff81054576>] update_process_times+0x4f/0x5f
> [  391.312417]  [<ffffffff8106ad80>] tick_sched_timer+0x76/0x96
> [  391.318331]  [<ffffffff8106ad0a>] ? tick_sched_timer+0x0/0x96
> [  391.324334]  [<ffffffff81061ea2>] __run_hrtimer+0x80/0xb4
> [  391.329993]  [<ffffffff81062abe>] hrtimer_interrupt+0xe7/0x145
> [  391.336081]  [<ffffffff81022801>] smp_apic_timer_interrupt+0x83/0x96
> [  391.342692]  [<ffffffff8100c6d3>] apic_timer_interrupt+0x13/0x20
> [  391.348953]  <EOI>  [<ffffffff81022a7c>] ? default_send_IPI_mask_allbutself_phys+0x67/0x73
> [  391.357752]  [<ffffffff8102532d>] ? physflat_send_IPI_allbutself+0x14/0x16
> [  391.364877]  [<ffffffff8102166a>] ? native_send_call_func_ipi+0x83/0xa5
> [  391.371747]  [<ffffffff81070cff>] ? smp_call_function_many+0x19b/0x1bb
> [  391.378529]  [<ffffffff810128b0>] ? stop_this_cpu+0x0/0x1c
> [  391.384270]  [<ffffffff81070d3f>] ? smp_call_function+0x20/0x24
> [  391.390448]  [<ffffffff81021575>] ? native_smp_send_stop+0x22/0x30
> [  391.396882]  [<ffffffff81020f93>] ? native_machine_shutdown+0x49/0x62
> [  391.403578]  [<ffffffff81020d62>] ? native_machine_restart+0x21/0x33
> [  391.410187]  [<ffffffff81020cd9>] ? machine_restart+0xa/0xc
> [  391.416016]  [<ffffffff81059d67>] ? kernel_restart+0x3f/0x43
> [  391.421935]  [<ffffffff81059eb8>] ? sys_reboot+0x140/0x174
> [  391.427677]  [<ffffffff810628c6>] ? hrtimer_nanosleep+0x104/0x119
> [  391.434025]  [<ffffffff81061e01>] ? hrtimer_wakeup+0x0/0x21
> [  391.439857]  [<ffffffff8106272d>] ? hrtimer_start_range_ns+0xf/0x11
> [  391.446379]  [<ffffffff8106292f>] ? sys_nanosleep+0x54/0x6c
> [  391.452210]  [<ffffffff8100bbeb>] ? system_call_fastpath+0x16/0x1b
> [  391.458643] ---[ end trace 4b05cad362f39345 ]---
>
> that's 44 lines so yes it can happen.

For lockdep issue, there will be more

>
>> > Plus often there's a loop in architecture code that tries various
>> > methods of reboot. We dont know which one works - and any of them
>> > could produce warning messages. (and this happened a number of times
>> > in the past)
>> >
>> > So this would mean having to find up to a hundred of 'reboot now'
>> > places in a two dozen architectures (and keeping them all maintained
>> > ongoing as well). Does not seem like a good choice to me.
>> >
>>
>> hm.  If we need to actually capture all of those.
>>
>> questions: is it possible for interrupts to be disabled at this
>> time? If so, can we get an NMI watchdog hit?
>
> no, we generally turn off the nmi watchdog during shutdown, disable
> the lapic and io-apic, etc.
>
>> Is the softlockup detector still running and if so, can it
>> trigger?
>
> in (non-emergency) reboot, last i checked, we stopped all other CPUs
> first, and then killed the current one. There's no chance for the
> watchdog thread to run.
>
> Anyway ... you seem to be uncomfortable about this patch - should i
> delay it for now to let it all play out? We are close to the merge
> window.
>
>        Ingo
>



-- 
Regards
dave
