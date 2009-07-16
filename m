Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbZGPTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbZGPTNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbZGPTND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:13:03 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34436 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064AbZGPTNB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:13:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc1-mmotm0702 - ps command hangs inside kernel
In-Reply-To: Your message of "Tue, 14 Jul 2009 07:31:19 +0200."
             <1247549479.30711.8.camel@wall-e>
From: Valdis.Kletnieks@vt.edu
References: <47423.1247518491@turing-police.cc.vt.edu> <20090713143810.5e17bbdb.akpm@linux-foundation.org>
            <1247549479.30711.8.camel@wall-e>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247771564_4382P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2009 15:12:44 -0400
Message-ID: <46776.1247771564@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247771564_4382P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Jul 2009 07:31:19 +0200, Stefani Seibold said:
> Am Montag, den 13.07.2009, 14:38 -0700 schrieb Andrew Morton:
> > On Mon, 13 Jul 2009 16:54:51 -0400
> > Valdis.Kletnieks@vt.edu wrote:
> > 
> > > Several times recently, I've had the 'ps' command hang inside the kernel
> > > for extended periods of time - usually around 1100 seconds, but today I
> > > had one that hung there for 2351 seconds.

> i am the author of the get_stack_usage_bytes(). Because i have currently
> no 64bit machine running, i am not able to analyse your problem. Does it
> only happen on 32bit application on a 64bit kernel? Is it only affected
> to pcsd?

I've only seen it happen to pcscd.  However, most of the time it's one of
the very few 32-bit apps running on my laptop (I've got exactly *one* legacy
app for a secure-token that is stuck in 32-bit land).  So I can't tell if it's
a generic 32-bit issue.

> Can you give me a more accurate info what exactly the problem is?


> 
> > OK, thanks for the analysis.
> > 
> > > Here's the traceback of the ps, as reported by 2 alt-sysrq-t several
> > > minutes apart:
> > > 
> > > 
> > > ps            R  running task     3936 26646  26580 0x00000080
> > >  ffff88005a599bd8 ffffffff81499842 ffff88000213bf80 0000000000000000
> > >  ffff88005a599b78 ffffffff8103589b ffffffff81035805 ffff88007e71ea40
> > >  ffff88000213bf80 ffff8800657d8fe0 000000000000df78 ffff8800657d8fe8
> > > Call Trace:
> > >  [<ffffffff81499842>] ? thread_return+0xb6/0xfa
> > >  [<ffffffff8103589b>] ? finish_task_switch+0xd1/0xf4
> > >  [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
> > >  [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
> > >  [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > >  [<ffffffff8101f76b>] smp_apic_timer_interrupt+0x81/0x8f
> > >  [<ffffffff81046231>] ? irq_exit+0xaf/0xb4
> > >  [<ffffffff8100bd80>] ? restore_args+0x0/0x30
> > >  [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
> > >  [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
> > >  [<ffffffff810b8f22>] ? follow_page+0x28/0x2e3
> > >  [<ffffffff810b91d9>] ? follow_page+0x2df/0x2e3
> > >  [<ffffffff811219d8>] ? proc_pid_status+0x5e0/0x694
> > >  [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
> > >  [<ffffffff8111e42c>] ? proc_single_show+0x57/0x74
> > >  [<ffffffff810e90b4>] ? seq_read+0x249/0x49b
> > >  [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
> > >  [<ffffffff810d05e1>] ? vfs_read+0xe0/0x141
> > >  [<ffffffff810d8191>] ? path_put+0x1d/0x21
> > >  [<ffffffff810d06f8>] ? sys_read+0x45/0x69
> > >  [<ffffffff8100b2ab>] ? system_call_fastpath+0x16/0x1b
> > 
> The double follow_page looks strange for me... I will have a look on it.

It's possible that one of the two follow_page() entries is stale and just
happened to be left on the stack.  A large chunk of proc_pid_status() is
inlined, so it's possible that two calls were made and left their return
addresses in different locations on the stack.

I am pretty sure that follow_page+0x28 is the correct one, as I see it
in 2 more tracebacks today (see below)...

Got a better idea than just sticking in a printk() to dump the starting
values of stkpage and vma->vm_start in get_stack_usage_in_bytes()? I suspect
that for a 32-bit process, those 2 values aren't lined up the way we think
they are, and as a result that for loop ends up walking across a *lot* of
pages unintentionally.

> > Another possibility is that pcscd has gone off on a long in-kernel sulk
> > (polling hardware?) while holding some lock which ps needs (eg, mmap_sem).
> > 
> > It would be useful if you can grab a pcscd backtrace during the stall.

Got bit again this morning - here's the relevant tracebacks. Looks like pcscd
is off sulking in select() and nanosleep(), which are pretty normal places for
programs to go sulk.

(pcscd has 2 threads, apparently. I had 2 ps commands hung up, thus the
two entries for it)

pcscd         S 0000000000000000  4656  2100      1 0x00020080
 ffff88007da3f948 0000000000000046 ffff88007da3f8b8 ffffffff81052b2e
 ffff88007f90e340 ffff88007e08db30 0000000000000000 0000000000000001
 ffff88007da3f8d8 ffff880074ee4fa0 000000000000df78 ffff880074ee4fa0
Call Trace:
 [<ffffffff81052b2e>] ? queue_work_on+0x5e/0x6c
 [<ffffffff81056bec>] ? add_wait_queue+0x1b/0x42
 [<ffffffff8149a70b>] schedule_hrtimeout_range+0x3f/0x11f
 [<ffffffff8149bb91>] ? _spin_unlock_irqrestore+0x72/0x80
 [<ffffffff81056c0b>] ? add_wait_queue+0x3a/0x42
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810de040>] poll_schedule_timeout+0x33/0x4c
 [<ffffffff810deb82>] do_select+0x4b7/0x4f5
 [<ffffffff810df064>] ? __pollwait+0x0/0xc7
 [<ffffffff810df12b>] ? pollwake+0x0/0x51
 [<ffffffff810a8d3a>] ? get_page_from_freelist+0x38a/0x63c
 [<ffffffff811bb5c4>] ? list_del+0xbc/0xea
 [<ffffffff810a7561>] ? __rmqueue+0x124/0x2bf
 [<ffffffff81034de2>] ? get_parent_ip+0x11/0x42
 [<ffffffff8149e770>] ? sub_preempt_count+0x35/0x49
 [<ffffffff810a8ed8>] ? get_page_from_freelist+0x528/0x63c
 [<ffffffff8105b908>] ? __update_sched_clock+0x2f/0x8e
 [<ffffffff8105bb72>] ? sched_clock_cpu+0x20b/0x219
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810542bf>] ? alloc_pid+0x2ce/0x3e3
 [<ffffffff810542bf>] ? alloc_pid+0x2ce/0x3e3
 [<ffffffff81034de2>] ? get_parent_ip+0x11/0x42
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff81107bf7>] compat_core_sys_select+0x183/0x23d
 [<ffffffff8149e770>] ? sub_preempt_count+0x35/0x49
 [<ffffffff8149bb91>] ? _spin_unlock_irqrestore+0x72/0x80
 [<ffffffff81030930>] ? task_rq_unlock+0xc/0xe
 [<ffffffff8103ab25>] ? wake_up_new_task+0x169/0x174
 [<ffffffff8103eaf6>] ? do_fork+0x37a/0x424
 [<ffffffff8105e2e2>] ? current_kernel_time+0x28/0x50
 [<ffffffff81107f48>] compat_sys_select+0x96/0xbe
 [<ffffffff8107d8b0>] ? audit_syscall_entry+0x170/0x19c
 [<ffffffff8102b538>] sysenter_dispatch+0x7/0x2c

pcscd         S ffff88007e1fbf48  5640  2106      1 0x00020080
 ffff88007e1fbe28 0000000000000046 ffff88007e1fbd88 ffffffff8149bb91
 ffff88007e1fbe78 0000000000000001 ffff88007e1fbe18 ffffffff81059d91
 0000000000000000 ffff880074d6ac20 000000000000df78 ffff880074d6ac20
Call Trace:
 [<ffffffff8149bb91>] ? _spin_unlock_irqrestore+0x72/0x80
 [<ffffffff81059d91>] ? __hrtimer_start_range_ns+0x35b/0x36d
 [<ffffffff8149a882>] do_nanosleep+0x88/0xee
 [<ffffffff81059e75>] hrtimer_nanosleep+0xac/0x121
 [<ffffffff8105935d>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81075da2>] compat_sys_nanosleep+0x7b/0xe1
 [<ffffffff8102b538>] sysenter_dispatch+0x7/0x2c
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f

ps            R  running task     3936 45836  45832 0x00000080
 ffff88004dc09b98 ffffffff81065f3f 0000000000000001 00000388525af000
 ffff88004dc09bb8 ffffffff81065f3f 0000000000000000 000003886bc2b000
 ffff88004dc09ce8 ffffffff8149b2a6 0000000000000000 ffff88000212cf68
Call Trace:
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff81065f3f>] trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149b2a6>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8101f76b>] ? smp_apic_timer_interrupt+0x81/0x8f
 [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
 [<ffffffff810b8f22>] ? follow_page+0x28/0x2e3
 [<ffffffff811219d8>] proc_pid_status+0x5e0/0x694
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8111e42c>] proc_single_show+0x57/0x74
 [<ffffffff810e90b4>] seq_read+0x249/0x49b
 [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
 [<ffffffff810d05e1>] vfs_read+0xe0/0x141
 [<ffffffff810d8191>] ? path_put+0x1d/0x21
 [<ffffffff810d06f8>] sys_read+0x45/0x69
 [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b

ps            R  running task     5584 45948  45868 0x00000080
 ffff88004de81bb8 0000000000000046 ffff88004de81b18 ffffffff81035142
 ffff880002120f80 0000000000000000 ffff88004de81b68 ffffffff8103589b
 ffffffff81035805 ffff8800653fc460 000000000000df78 ffff8800653fc468
Call Trace:
 [<ffffffff81035142>] ? mmdrop+0x2b/0x3d
 [<ffffffff8103589b>] ? finish_task_switch+0xd1/0xf4
 [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
 [<ffffffff81499842>] ? thread_return+0xb6/0xfa
 [<ffffffff814999d1>] preempt_schedule_irq+0x56/0x74
 [<ffffffff8100be96>] retint_kernel+0x26/0x30
 [<ffffffff81094996>] ? ftrace_likely_update+0x12/0x14
 [<ffffffff8100bd80>] ? restore_args+0x0/0x30
 [<ffffffff810b8222>] IS_ERR+0x25/0x2c
 [<ffffffff810b8f22>] follow_page+0x28/0x2e3
 [<ffffffff81094990>] ? ftrace_likely_update+0xc/0x14
 [<ffffffff811219d8>] proc_pid_status+0x5e0/0x694
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8111e42c>] proc_single_show+0x57/0x74
 [<ffffffff810e90b4>] seq_read+0x249/0x49b
 [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
 [<ffffffff810d05e1>] vfs_read+0xe0/0x141
 [<ffffffff810d8191>] ? path_put+0x1d/0x21
 [<ffffffff810d06f8>] sys_read+0x45/0x69
 [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b

Just for comparison, here's the pcscd stack traces right now, when things
are working just fine. One thread in select, one in nanosleep, just like
when it was broken.

pcscd         S 0000000000000000  4656  2000      1 0x00020080
 ffff880073037948 0000000000000046 ffff8800730378a8 ffffffff81030461
 0000000000000000 0000000000000000 ffff880000000000 ffffffff81499842
 ffff8800730378d8 ffff88007ebf9120 000000000000df78 ffff88007ebf9120
Call Trace:
 [<ffffffff81030461>] ? need_resched+0x3a/0x40
 [<ffffffff81499842>] ? thread_return+0xb6/0xfa
 [<ffffffff81056bec>] ? add_wait_queue+0x1b/0x42
 [<ffffffff8149a70b>] schedule_hrtimeout_range+0x3f/0x11f
 [<ffffffff8149bb91>] ? _spin_unlock_irqrestore+0x72/0x80
 [<ffffffff81056c0b>] ? add_wait_queue+0x3a/0x42
 [<ffffffff810df122>] ? __pollwait+0xbe/0xc7
 [<ffffffff810de040>] poll_schedule_timeout+0x33/0x4c
 [<ffffffff810deb82>] do_select+0x4b7/0x4f5
 [<ffffffff810df064>] ? __pollwait+0x0/0xc7
 [<ffffffff810df12b>] ? pollwake+0x0/0x51
 [<ffffffff810a8d3a>] ? get_page_from_freelist+0x38a/0x63c
 [<ffffffff811bb5c4>] ? list_del+0xbc/0xea
 [<ffffffff810a7561>] ? __rmqueue+0x124/0x2bf
 [<ffffffff81034de2>] ? get_parent_ip+0x11/0x42
 [<ffffffff8149e770>] ? sub_preempt_count+0x35/0x49
 [<ffffffff810a8ed8>] ? get_page_from_freelist+0x528/0x63c
 [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149bc01>] ? _spin_unlock_irq+0x62/0x6f
 [<ffffffff8103589b>] ? finish_task_switch+0xd1/0xf4
 [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
 [<ffffffff81030461>] ? need_resched+0x3a/0x40
 [<ffffffff81499842>] ? thread_return+0xb6/0xfa
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff81107bf7>] compat_core_sys_select+0x183/0x23d
 [<ffffffff81499a4d>] ? preempt_schedule+0x5e/0x67
 [<ffffffff8149bb9a>] ? _spin_unlock_irqrestore+0x7b/0x80
 [<ffffffff81030930>] ? task_rq_unlock+0xc/0xe
 [<ffffffff8103ab25>] ? wake_up_new_task+0x169/0x174
 [<ffffffff8103eaf6>] ? do_fork+0x37a/0x424
 [<ffffffff81107f48>] compat_sys_select+0x96/0xbe
 [<ffffffff8107d80b>] ? audit_syscall_entry+0xcb/0x19c
 [<ffffffff8102b538>] sysenter_dispatch+0x7/0x2c

pcscd         S ffff88007cf99f48  4896  2006      1 0x00020080
 ffff88007cf99e28 0000000000000046 ffff88007cf99d88 ffffffff8149bb91
 ffff88007cf99e78 0000000000000001 ffff88007cf99e18 ffffffff81059d91
 0000000000000000 ffff88007e4da3e0 000000000000df78 ffff88007e4da3e0
Call Trace:
 [<ffffffff8149bb91>] ? _spin_unlock_irqrestore+0x72/0x80
 [<ffffffff81059d91>] ? __hrtimer_start_range_ns+0x35b/0x36d
 [<ffffffff8149a882>] do_nanosleep+0x88/0xee
 [<ffffffff81059e75>] hrtimer_nanosleep+0xac/0x121
 [<ffffffff8105935d>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff81075da2>] compat_sys_nanosleep+0x7b/0xe1
 [<ffffffff8102b538>] sysenter_dispatch+0x7/0x2c
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f



--==_Exmh_1247771564_4382P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKX3uscC3lWbTT17ARAn3wAKDbcIOBd7tBlVbT/5UpAOOoMOp6zACfSN0m
t2J10zIThfhXrkBqCY0aDS0=
=gnln
-----END PGP SIGNATURE-----

--==_Exmh_1247771564_4382P--
