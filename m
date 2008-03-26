Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYCZX3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYCZX3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYCZX3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:29:25 -0400
Received: from www.tglx.de ([62.245.132.106]:47231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbYCZX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:29:24 -0400
Date: Thu, 27 Mar 2008 00:23:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/5] infrastructure to debug (dynamic) objects
In-Reply-To: <alpine.LFD.1.00.0803250915330.3781@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0803262352120.3781@apollo.tec.linutronix.de>
References: <20080321200300.310393657@linutronix.de> <20080321200321.650649403@linutronix.de> <20080324130454.ced60108.akpm@linux-foundation.org> <alpine.LFD.1.00.0803250915330.3781@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Thomas Gleixner wrote:
> On Mon, 24 Mar 2008, Andrew Morton wrote:
> > On Fri, 21 Mar 2008 20:26:18 -0000
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > The debugobjects core code keeps track of operations on static and
> > > dynamic objects by inserting them into a hashed list and sanity
> > > checking them on object operations and provides additional checks
> > > whenever kernel memory is freed.
> > 
> > Prime candidates for conversion to this interface are locks: spinlocks,
> > rwlocks, mutexes, etc.
> > 
> > a) it'd be interesting to get that done, as a proof-of-usefulness thing.
> 
> /me looks for volunteers :)

I had a look into that and it's not a friday afternoon project as it
needs some major distangling of lockdep, which seems to be on Peter's
todo list for quite a while.

vs. the proof-of-usefulness I just want to point out that having an
infrastructure which allows us to retrieve valuable debug information
with an exact pointer to the offending code from a live system is
useful by definition and it has proven it already in several cases.

I was able to fix two of those problems (use after free) myself, but
I'm unable to get this one resolved w/o twisting my brain:

http://bugzilla.kernel.org/show_bug.cgi?id=10068

But .... having such precise info:

ODEBUG: init active object: db112e94 timer_list
WARNING: at lib/debugobjects.c:63 debug_print_object()
Pid: 2023, comm: softmac Not tainted 2.6.24.2 #10
 [<c01c5181>] debug_object_op+0x89/0xe0
 [<c0120168>] init_timer+0x18/0x40
 [<e098f813>] ieee80211softmac_auth_req+0x6b/0x9c [ieee80211softmac]
 [<e0991543>] ieee80211softmac_assoc_work+0x292/0x392 [ieee80211softmac]
 [<e0991643>] ieee80211softmac_assoc_notify_scan+0x0/0x10 [ieee80211softmac]
 [<e0991ab6>] ieee80211softmac_notify_callback+0x40/0x48 [ieee80211softmac]
 [<e0991a76>] ieee80211softmac_notify_callback+0x0/0x48 [ieee80211softmac]
 [<e0991978>] ieee80211softmac_call_events_locked+0xdc/0xee [ieee80211softmac]
 [<e0991643>] ieee80211softmac_assoc_notify_scan+0x0/0x10 [ieee80211softmac]
 [<e0991a76>] ieee80211softmac_notify_callback+0x0/0x48 [ieee80211softmac]
 [<c01250bf>] run_workqueue+0x6b/0xdf
 [<c0335f0f>] schedule+0x1f0/0x20a
 [<c01256b2>] worker_thread+0x0/0xc2
 [<c0125766>] worker_thread+0xb4/0xc2
 [<c0127baa>] autoremove_wake_function+0x0/0x33
 [<c01256b2>] worker_thread+0x0/0xc2
 [<c0127a4a>] kthread+0x36/0x5c
 [<c0127a14>] kthread+0x0/0x5c
 [<c0104757>] kernel_thread_helper+0x7/0x10

instead of:

kernel BUG at kernel/timer.c: 607!
Invalid opcode: 0000 [#1]
Modules linked in: cpufreq_stats nls_cp437 sbp2 scsi_mod loop zd1211rw
ieee80211softmac parport_pc parport ohci1394 snd_intel8x0 ieee1394 sis900
ehci_hcd ide_cd cdrom fan asus_acpi backlight battery ac

Pid 3239, comm: firefox-bin Not tainted (2.6.24.2 #1)
EIP:0060 :[<c011e54b>] EFLAGS:00210007 CPU:0
EIP is at cascade+0x3b/0x57
EAX:0 EBX:0 ECX:5 EDX:d9eb3ca4
ESI:5 EDI:c0485640 EBP:d9ecdf30 ESP:d9ecdf30
DS:007b ES:007b FS:0000 GS:0033 SS:0068

...

Call trace

[<c011e6ad>] run_timer_softirq+0x55/0x141
[<c012b8e3>] tick_handle_periodic+0xf/0x54
[<c011bdcc>] __do_softirq+0x35/0x75
[<c011be2e>] do_softirq+022/0x26
[<c01055b0>] do_IRQ+0x58/0x6b
[<c033b1a7>] schedule+0x1f0/0x20a
[<c01045e7>] common_interrupt+0x23/0x28

Kernel Panic - not syncing: Fatal exception in interrupt

makes it useful enough - at least for me.

The fact, that this information has not been used by the knowledgable
developers of the offending code to fix the root cause within 14 days
is a totaly different problem.

Thanks,

	tglx
