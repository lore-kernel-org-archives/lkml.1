Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZBOJs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZBOJs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZBOJsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:48:19 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:39666 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZBOJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:48:17 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected) [Bug
	12465]
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       bugme-daemon@bugzilla.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <ROx6X68CGJG.A.54H.w40lJB@chimera>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera>
	 <ROx6X68CGJG.A.54H.w40lJB@chimera>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Sun, 15 Feb 2009 20:18:04 +1030
Message-Id: <1234691284.4967.23.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 21:50 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).

Yes, this should still be listed.

I just tested against 2.6.29-rc5 and the problem is as bad as ever
(perhaps worse?)

--- hermes-old.wumi.org.au ping statistics ---
900 packets transmitted, 448 received, +317 errors, 50% packet loss, time 899845ms
rtt min/avg/max/mdev = 0.131/420.015/10890.699/1297.022 ms, pipe 11

The guest being pinged crashed during the test - the QEMU monitor was
accessible, but the guest didn't respond to "sendkey alt-sysrq-s", etc.
This was the last thing in the guest syslog after reboot:

Feb 15 19:48:58 hermes-old kernel: ------------[ cut here ]------------
Feb 15 19:48:58 hermes-old kernel: WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0x111/0x195()
Feb 15 19:48:58 hermes-old kernel: NETDEV WATCHDOG: eth0 (8139too): transmit timed out
Feb 15 19:48:58 hermes-old kernel: Pid: 0, comm: swapper Not tainted 2.6.27.10 #1
Feb 15 19:48:58 hermes-old kernel:  [<c011d75c>] warn_slowpath+0x5c/0x81
Feb 15 19:48:58 hermes-old kernel:  [<c02f5f7c>] nf_hook_slow+0x44/0xb1
Feb 15 19:48:58 hermes-old kernel:  [<c02d93f1>] dev_queue_xmit+0x3da/0x411
Feb 15 19:48:58 hermes-old kernel:  [<c030043d>] ip_finish_output+0x1f9/0x231
Feb 15 19:48:58 hermes-old kernel:  [<c01daeee>] __next_cpu+0x12/0x21
Feb 15 19:48:58 hermes-old kernel:  [<c0116b42>] find_busiest_group+0x232/0x69f
Feb 15 19:48:58 hermes-old kernel:  [<c01160dc>] update_curr+0x41/0x65
Feb 15 19:48:58 hermes-old kernel:  [<c02e33b5>] dev_watchdog+0x111/0x195
Feb 15 19:48:58 hermes-old kernel:  [<c011822f>] enqueue_task_fair+0x16/0x24
Feb 15 19:48:58 hermes-old kernel:  [<c0115645>] enqueue_task+0xa/0x14
Feb 15 19:48:58 hermes-old kernel:  [<c01156d5>] activate_task+0x16/0x1b
Feb 15 19:48:58 hermes-old kernel:  [<c0119c8c>] try_to_wake_up+0x131/0x13a
Feb 15 19:48:58 hermes-old kernel:  [<c02e32a4>] dev_watchdog+0x0/0x195
Feb 15 19:48:58 hermes-old kernel:  [<c012424c>] run_timer_softirq+0xf5/0x14a
Feb 15 19:48:58 hermes-old kernel:  [<c0120f60>] __do_softirq+0x5d/0xc1
Feb 15 19:48:58 hermes-old kernel:  [<c0120ff6>] do_softirq+0x32/0x36
Feb 15 19:48:58 hermes-old kernel:  [<c012112c>] irq_exit+0x35/0x40
Feb 15 19:48:58 hermes-old kernel:  [<c010e8db>] smp_apic_timer_interrupt+0x6e/0x7b
Feb 15 19:48:58 hermes-old kernel:  [<c01035ac>] apic_timer_interrupt+0x28/0x30
Feb 15 19:48:58 hermes-old kernel:  [<c0107386>] default_idle+0x2a/0x3d
Feb 15 19:48:58 hermes-old kernel:  [<c0101900>] cpu_idle+0x5c/0x84
Feb 15 19:48:58 hermes-old kernel:  =======================
Feb 15 19:48:58 hermes-old kernel: ---[ end trace eff10a8043ac4e7b ]---
Feb 15 19:49:01 hermes-old kernel: eth0: Transmit timeout, status 0d 0000 c07f media d0.
Feb 15 19:49:01 hermes-old kernel: eth0: Tx queue start entry 839  dirty entry 839.
Feb 15 19:49:01 hermes-old kernel: eth0:  Tx descriptor 0 is 0008a03c.
Feb 15 19:49:01 hermes-old kernel: eth0:  Tx descriptor 1 is 0008a062.
Feb 15 19:49:01 hermes-old kernel: eth0:  Tx descriptor 2 is 0008a062.
Feb 15 19:49:01 hermes-old kernel: eth0:  Tx descriptor 3 is 0008a05b. (queue head)
Feb 15 19:49:01 hermes-old kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x05E1

I think I saw some patches to fix the latency tracer for non-RT tasks on
the mailing list a while ago. If that's still going to be a useful test,
can someone give me some hints on which kernel tree and/or patches to
download to get that working? The simpler you can make it, the better ;)

Cheers,
Kevin.


