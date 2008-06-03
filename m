Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYFCVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYFCVcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYFCVcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:32:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:54682 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbYFCVbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,585,1204531200"; 
   d="scan'208";a="287752477"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Date: Tue, 3 Jun 2008 14:31:50 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC017C44B2@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080603210125.1724C26FC96@magilla.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Thread-Index: AcjFvcIlI/jYoa7JRC+nODv6B0DIxwAAdTeA
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com><20080523041940.39E8726FA24@magilla.localdomain><3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com><20080526001527.81E1126FA9E@magilla.localdomain><3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com><3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com><20080527040454.053C526FA9E@magilla.localdomain><3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com><20080527061209.9A24426FAA6@magilla.localdomain><1211869515.29836.2.camel@elijah.suse.cz><3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com><48450864.6080707@suse.cz><48455619.6040608@suse.cz> <20080603210125.1724C26FC96@magilla.localdomain>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Roland McGrath" <roland@redhat.com>, "Petr Tesarik" <ptesarik@suse.cz>
Cc: "Luming Yu" <luming.yu@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 03 Jun 2008 21:31:52.0058 (UTC) FILETIME=[3CDDADA0:01C8C5C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What do you mean by "extra"?  There is a SIGTRAP sent after execve
> completes when ptraced, even when PTRACE_SYSCALL is not being used.
> So for an execve that succeeds under PTRACE_SYSCALL, there is a
> ptrace_notify at syscall entry, then a SIGTRAP queued (i.e., not seen
> by ptrace if blocked), then a ptrace_notify at syscall exit.  If
> that's what's happening (including the blocked SIGTRAP not being seen
> by the ptracer, i.e. strace), then there is no mystery (and no bug).

This might not be the same bug ... but I do have a definite 100%
reproducible bug (latest git kernel, old version of strace (4.5.15-1.el4.1))

Run:

	$ strace -o logit -f make

in any directory where make is actually going to have to do some
work.  You'll see that the command hangs after make outputs the
first action that it will take.  Looking at the stack traces of
the 3 processes involved it seems that make forked, the child
stopped in ptrace waiting for some action from strace, but strace
isn't woken from its sleep in wait().

Backtrace of pid 6442 (strace)

Call Trace:
 [<a0000001007069b0>] schedule+0x11f0/0x1380
                                sp=e0000001b28cfdb0 bsp=e0000001b28c0e00
 [<a0000001000842d0>] do_wait+0x1110/0x1520
                                sp=e0000001b28cfdd0 bsp=e0000001b28c0d58
 [<a0000001000849c0>] sys_wait4+0x140/0x1a0
                                sp=e0000001b28cfe30 bsp=e0000001b28c0cd8
 [<a00000010000aa60>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000001b28cfe30 bsp=e0000001b28c0cd8
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000001b28d0000 bsp=e0000001b28c0cd8

Backtrace of pid 6443 (make)

Call Trace:
 [<a0000001007069b0>] schedule+0x11f0/0x1380
                                sp=e0000001b768fb40 bsp=e0000001b7680d58
 [<a000000100707800>] schedule_timeout+0x40/0x180
                                sp=e0000001b768fb60 bsp=e0000001b7680d28
 [<a000000100706d60>] wait_for_common+0x220/0x380
                                sp=e0000001b768fb90 bsp=e0000001b7680cd8
 [<a000000100706f00>] wait_for_completion+0x40/0x60
                                sp=e0000001b768fbf0 bsp=e0000001b7680cb8
 [<a0000001000794d0>] do_fork+0x430/0x4a0
                                sp=e0000001b768fbf0 bsp=e0000001b7680c60
 [<a00000010000a340>] sys_clone+0x60/0x80
                                sp=e0000001b768fc20 bsp=e0000001b7680c10
 [<a00000010000a990>] ia64_trace_syscall+0xd0/0x110
                                sp=e0000001b768fe30 bsp=e0000001b7680c10
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000001b7690000 bsp=e0000001b7680c10

Backtrace of pid 6444 (make)

Call Trace:
 [<a0000001007069b0>] schedule+0x11f0/0x1380
                                sp=e0000001b803fd60 bsp=e0000001b8030dd8
 [<a000000100097590>] ptrace_stop+0x2d0/0x380
                                sp=e0000001b803fd80 bsp=e0000001b8030da0
 [<a000000100097c90>] get_signal_to_deliver+0x1d0/0x6a0
                                sp=e0000001b803fd80 bsp=e0000001b8030d38
 [<a000000100034a10>] ia64_do_signal+0xb0/0xd00
                                sp=e0000001b803fd80 bsp=e0000001b8030c90
 [<a000000100012c60>] do_notify_resume_user+0x100/0x180
                                sp=e0000001b803fe20 bsp=e0000001b8030c60
 [<a00000010000b0c0>] notify_resume_user+0x40/0x60
                                sp=e0000001b803fe20 bsp=e0000001b8030c10
 [<a00000010000aff0>] skip_rbs_switch+0xe0/0x110
                                sp=e0000001b803fe30 bsp=e0000001b8030c10
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000001b8040000 bsp=e0000001b8030c10

