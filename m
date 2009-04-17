Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZDQDDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZDQDDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZDQDDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:03:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZDQDDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:03:31 -0400
Date: Thu, 16 Apr 2009 23:03:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
In-Reply-To: <1239904428.23397.3278.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>  <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>  <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Peter Zijlstra wrote:

> On Thu, 2009-04-16 at 13:45 -0400, Steven Rostedt wrote:
> > On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> > 
> > > On Thu, 2009-04-16 at 12:15 -0400, Steven Rostedt wrote:
> > > > plain text document attachment
> > > > (0002-tracing-events-lockdep-move-tracepoints-within-recu.patch)
> > > > From: Steven Rostedt <srostedt@redhat.com>
> > > > 
> > > > With the current location of the tracepoints in lockdep, the system
> > > > can hard lockup in minutes when the tracepoints are enabled.
> > > > 
> > > > Moving the tracepoints outside inside the lockdep protection solves
> > > > the issue.
> > > 
> > > NAK
> > 
> > Can we at least add this as a workaround. Basically, the lockdep
> > tracepoints are broken as is. I do not plan on changing the logic of the 
> > events to prevent nesting. That's a feature I use. If we don't allow 
> > nesting, we must drop events, which is bad.
> 
> No, I would say any nesting is a bug, and should stop tracing and print
> a splat. No need to drop events.
> 
> > The other answer is simply to remove the trace points in lockdep, until 
> > they work again.
> 
> Well, they worked when I added them, so someone broke it.

I reverted my patch and added recursion detection, but I hit this nasty 
bug:

---------------------------------
CPU 0 
Modules linked in: radeon drm autofs4 hidp rfcomm l2cap bluetooth sunrpc 
ip6t_REJECT ip6table_filter ip6_tables ipv6 sbs sbshc battery sg evbug 
ide_cd_mod cdrom snd_intel8x0 snd_ac97_codec ac97_bus serio_raw 
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss e1000 snd_pcm button floppy snd_timer i2c_i801 
snd soundcore i2c_core snd_page_alloc ata_generic iTCO_wdt 
iTCO_vendor_support pata_acpi e752x_edac edac_core pcspkr dm_snapshot 
dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix libata sd_mod 
scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 3301, comm: pcscd Tainted: G        W  2.6.30-rc1 #1036 Precision 
WorkStation 470    
RIP: 0010:[<ffffffff803a59a2>]  [<ffffffff803a59a2>] strlen+0x2/0x20
RSP: 0018:ffff880033d19c40  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff807617df RCX: ffffffff807617de
RDX: ffff880033d19d48 RSI: ffff880033d19c58 RDI: 5b5b5b5b5b5b5b5b
RBP: ffff880033d19ca8 R08: 5b5b5b5b5b5b5b00 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000202 R12: 0000000000000000
R13: 5b5b5b5b5b5b5b5b R14: ffffffff81269b62 R15: ffff880033d19d08
FS:  0000000041b6f940(0063) GS:ffffffff80828000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006aec88 CR3: 0000000033c02000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process pcscd (pid: 3301, threadinfo ffff880033d18000, task 
ffff880033c48000)
Stack:
 ffffffff803a73e5 ffffffff81269b60 ffffffff8126ab60 0000000000000004
 0000000affffffff ffffffffffffffff 0000000000000000 ffff880033d19c98
 0000000000000246 ffff880033d19d08 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff803a73e5>] ? vbin_printf+0x1b5/0x2e0
 [<ffffffff802b77dc>] trace_vbprintk+0xbc/0x1c0
 [<ffffffff802887fe>] ? lock_acquire+0x10e/0x120
 [<ffffffff802bad29>] __trace_bprintk+0x79/0x80
 [<ffffffff80228ed6>] ? ftrace_call+0x5/0x2b
 [<ffffffff802b5dac>] ? tracing_record_cmdline+0x2c/0x100
 [<ffffffff80284920>] ftrace_event_lock_acquire+0x60/0x70
 [<ffffffff802887fe>] lock_acquire+0x10e/0x120
 [<ffffffff8030a744>] ? dput+0x64/0x170
 [<ffffffff80610336>] _spin_lock+0x36/0x70
 [<ffffffff8030a744>] ? dput+0x64/0x170
 [<ffffffff8039f98f>] ? _atomic_dec_and_lock+0x1f/0x50
 [<ffffffff8030a744>] dput+0x64/0x170
 [<ffffffff80315215>] dcache_dir_close+0x15/0x20
 [<ffffffff802f8a51>] __fput+0xd1/0x230
 [<ffffffff802f8f0b>] fput+0x1b/0x30
 [<ffffffff802f566d>] filp_close+0x5d/0x90
 [<ffffffff802f5746>] sys_close+0xa6/0x110
 [<ffffffff802291af>] system_call_fastpath+0x16/0x1b
Code: 01 48 83 f9 ff 0f 1f 40 00 74 0b 48 83 c7 01 0f b6 07 84 c0 75 e3 c9 
31 c0 c3 c9 48 89 f8 c3 66 2e 0f 1f 84 00 00 00 00 00 31 c0 <80> 3f 00 55 
48 89 e5 74 11 48 89 f8 66 90 48 83 c0 01 80 38 00 
RIP  [<ffffffff803a59a2>] strlen+0x2/0x20
 RSP <ffff880033d19c40>


Doing an objdump:

ffffffff803a59a0 <strlen>:
ffffffff803a59a0:       31 c0                   xor    %eax,%eax
ffffffff803a59a2:       80 3f 00                cmpb   $0x0,(%rdi)
ffffffff803a59a5:       55                      push   %rbp
ffffffff803a59a6:       48 89 e5                mov    %rsp,%rbp
ffffffff803a59a9:       74 11                   je     ffffffff803a59bc <strlen+0x1c>

The %rdi is: 5b5b5b5b5b5b5b5b

Either there's a bug in the vbin_printf, or we have some crazy lock->name?

TRACE_FORMAT(lock_acquire,
        TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
                int trylock, int read, int check,
                struct lockdep_map *next_lock, unsigned long ip),
        TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
        TP_FMT("%s%s%s", trylock ? "try " : "",
                read ? "read " : "", lock->name)
        );

I'll continue to look into this, and perhaps reboot and see what other 
nasties I hit.

-- Steve

