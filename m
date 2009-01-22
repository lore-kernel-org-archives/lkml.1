Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZAVVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZAVVIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZAVVIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:08:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZAVVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:08:47 -0500
Subject: Re: lockdep and preemptoff tracer are fighting again.
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901221523400.5838@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901221523400.5838@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 22:08:38 +0100
Message-Id: <1232658518.4739.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 15:40 -0500, Steven Rostedt wrote:
> 
> Hey guys, I can consistently hit this bug when running the preempt tracer:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2899 check_flags+0x154/0x18b()
> Hardware name: Precision WorkStation 470    
> Modules linked in: radeon drm autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_conn
> track_netbios_ns ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_fi
> lter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sb
> s sbshc battery ac snd_intel8x0 snd_ac97_codec sg ac97_bus snd_seq_dummy snd_seq
> _oss snd_seq_midi_event floppy snd_seq snd_seq_device snd_pcm_oss ide_cd_mod snd
> _mixer_oss cdrom snd_pcm e1000 serio_raw snd_timer snd i2c_i801 button soundcore
>  ata_generic i2c_core iTCO_wdt snd_page_alloc e752x_edac iTCO_vendor_support shp
> chp edac_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod 
> ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 3855, comm: sshd Not tainted 2.6.29-rc2-tip #366
> Call Trace:
>  [<ffffffff80245e9f>] warn_slowpath+0xd8/0xf7
>  [<ffffffff80297154>] ? ring_buffer_unlock_commit+0x24/0xa3
>  [<ffffffff80299501>] ? trace_function+0xad/0xbc
>  [<ffffffff8025c1ff>] ? remove_wait_queue+0x4d/0x52
>  [<ffffffff8029e5dc>] ? trace_preempt_on+0x113/0x130
>  [<ffffffff8029e4ba>] ? check_critical_timing+0x12e/0x13d
>  [<ffffffff8025c1ff>] ? remove_wait_queue+0x4d/0x52
>  [<ffffffff8029f75b>] ? stack_trace_call+0x249/0x25d
>  [<ffffffff802da06e>] ? fput+0x4/0x1c
>  [<ffffffff802e7edc>] ? free_poll_entry+0x26/0x2a
>  [<ffffffff802da06e>] ? fput+0x4/0x1c
>  [<ffffffff8020c2d6>] ? ftrace_call+0x5/0x2b
>  [<ffffffff8029f75b>] ? stack_trace_call+0x249/0x25d
>  [<ffffffff80543dec>] ? _spin_lock_irqsave+0xb/0x59
>  [<ffffffff802699bf>] check_flags+0x154/0x18b
>  [<ffffffff8026de66>] lock_acquire+0x41/0xa9
>  [<ffffffff80543dfd>] ? _spin_lock_irqsave+0x1c/0x59
>  [<ffffffff80543e27>] _spin_lock_irqsave+0x46/0x59
>  [<ffffffff8029519c>] ? ring_buffer_reset_cpu+0x31/0x6b
>  [<ffffffff8029519c>] ring_buffer_reset_cpu+0x31/0x6b
>  [<ffffffff80299ec6>] tracing_reset+0x46/0x9b
>  [<ffffffff8029e33f>] trace_preempt_off+0x100/0x14d
>  [<ffffffff8024b491>] ? local_bh_disable+0x12/0x14
>  [<ffffffff8024b44f>] ? __local_bh_disable+0xc0/0xf0
>  [<ffffffff8024b491>] ? local_bh_disable+0x12/0x14
>  [<ffffffff80543b95>] ? _spin_lock_bh+0x16/0x4c
>  [<ffffffff80546df1>] add_preempt_count+0x12d/0x132
>  [<ffffffff8024b44f>] __local_bh_disable+0xc0/0xf0
>  [<ffffffff8024b491>] local_bh_disable+0x12/0x14
>  [<ffffffff80543b95>] _spin_lock_bh+0x16/0x4c
>  [<ffffffff804ab49a>] lock_sock_nested+0x28/0xe5
>  [<ffffffff80292c90>] ? ftrace_list_func+0x24/0x39
>  [<ffffffff8020c2d6>] ? ftrace_call+0x5/0x2b
>  [<ffffffff804eff87>] tcp_sendmsg+0x27/0xac2
>  [<ffffffff803556c7>] ? cap_socket_sendmsg+0x4/0xd
>  [<ffffffff80292c90>] ? ftrace_list_func+0x24/0x39
>  [<ffffffff8020c2d6>] ? ftrace_call+0x5/0x2b
>  [<ffffffff804a82b0>] sock_aio_write+0x109/0x11d
>  [<ffffffff8029f75b>] ? stack_trace_call+0x249/0x25d
>  [<ffffffff8020c2d6>] ? ftrace_call+0x5/0x2b
>  [<ffffffff802d8881>] do_sync_write+0xf0/0x137
>  [<ffffffff8025c002>] ? autoremove_wake_function+0x0/0x3d
>  [<ffffffff8020c2d6>] ? ftrace_call+0x5/0x2b
>  [<ffffffff803553ca>] ? cap_file_permission+0x9/0xd
>  [<ffffffff80353c88>] ? security_file_permission+0x16/0x18
>  [<ffffffff802d921c>] vfs_write+0x103/0x17d
>  [<ffffffff802d978f>] sys_write+0x4e/0x8c
>  [<ffffffff8020c64b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 713cc9df66b54d6e ]---
> 
> 
> The cause is simple. The following happens:
> 
> local_bh_disable is called, which calls __local_bh_disable which does a 
> add_preempt_count(SOFTIRQ_OFFSET).
> 
> Thus, add_preempt_count adds the SOFTIRQ_OFFSET to the preempt_count of 
> current, and then calls trace_preempt_off.
> 
> This goes into the preempt tracer which calls start_critical_timing, and 
> this will reset the ring buffer for the CPU, because this is the start of 
> the trace.
> 
> ring_buffer_reset_cpu() calls spin_lock_irqsave() which eventually calls 
> spin_acquire which is lock_acquire in lockdep.
> 
> lock_acquire calls check_flags which performs this check:
> 
> 	if (!hardirq_count()) {
> 		if (softirq_count())
> 			DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
> 		else
> 			DEBUG_LOCKS_WARN_ON(!current->softirqs_enabled);
> 	}
> 
> With this:
> 
> #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
> #define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
> 
> 
> The hardirq_count returns false, but the softirq_count returns true and 
> softirqs_enalbed is also true. The problem lies in local_bh_disable:
> 
> static void __local_bh_disable(unsigned long ip)
> {
> 	unsigned long flags;
> 
> 	WARN_ON_ONCE(in_irq());
> 
> 	raw_local_irq_save(flags);
> 	add_preempt_count(SOFTIRQ_OFFSET); <-- here softirq_count is true
> 	/*
> 	 * Were softirqs turned off above:
> 	 */
> 	if (softirq_count() == SOFTIRQ_OFFSET)
> 		trace_softirqs_off(ip); <-- here softirqs_enabled is false
> 	raw_local_irq_restore(flags);
> }
> 
> If we call into lockdep between softirq_count == true and 
> softirqs_enabled == false, we hit the WARN_ON.
> 
> The trace_softirqs_off() sets softirs_enabled to false. But because the 
> tracer calls into lockdep between the two, we hit this warning.
> 
> If we try to swap the trace_softirqs_off with the add_preempt_count we hit 
> another warning thatch checks to make sure softirq_count is true in the 
> trace_softirqs_off code.
> 
> We need a way to have lockdep and the preempt tracer to be able to talk to 
> each other and let it know that it should not fail here.

something like so?

__local_bh_disable()
{
	unsigned long flags;

	raw_local_irq_save(flags);

	/*
	 * comment explaining why add_preempt_count() doesn't work
	 */
	preempt_count() += SOFTIRQ_OFFSET;
	if (softirq_count() == SOFTIRQ_OFFSET)
		trace_softirqs_off(ip);
	if (preempt_count() == SOFTIRQ_OFFSET)
		trace_preempt_off(CALLER_ADDR0, ...);
	raw_local_irq_restore(flags);
}

