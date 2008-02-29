Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYB2He0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYB2He0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYB2HeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:34:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbYB2HeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:34:12 -0500
Date: Thu, 28 Feb 2008 23:33:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Allard Hoeve <allard@byte.nl>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Scheduler lockup or nfsd problem in 2.6.24.2 and 2.6.23.17?
Message-Id: <20080228233311.c104ad53.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0802281452240.1709@office2.c1.internal>
References: <Pine.LNX.4.62.0802281452240.1709@office2.c1.internal>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:04:12 +0100 (CET) Allard Hoeve <allard@byte.nl> wrote:

> 
> Hello all,
> 
> The last few days our trusty NFS server has experienced several soft 
> lockups. These occur every 11 hours or so. The system does not respond 
> afterwards. Sending sysrq commands over the serial console seems to work 
> allthough we had to powercycle the server once.
> 
> First we thought it would be an NFS problem, and now that we tried 
> 2.6.23.17 instead of 2.6.24.2, we now have two different stacktraces that 
> share a trace through nfsd (nfsd_direct_splice_actor):
> 
> http://article.gmane.org/gmane.linux.nfs/19107

This:

BUG: soft lockup - CPU#0 stuck for 11s! [nfsd:2716]

Pid: 2716, comm: nfsd Not tainted (2.6.24.2-fwsh-byte #2)
EIP: 0060:[<c0140967>] EFLAGS: 00000286 CPU: 0
EIP is at find_get_pages_contig+0x67/0x73
EAX: 00000000 EBX: 00000001 ECX: c25cc520 EDX: c25cc520
ESI: 00000078 EDI: ca2fbdbc EBP: 00000001 ESP: dffb5c6c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f5d000 CR3: 1fc45000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c017c49c>] __generic_file_splice_read+0xa2/0x41e
 [<c0113b11>] sched_slice+0x15/0x6f
 [<c0131291>] getnstimeofday+0x31/0x105
 [<c0134301>] clockevents_program_event+0xbf/0x134
 [<c012ef49>] ktime_get_ts+0x15/0x47
 [<c01231ea>] run_timer_softirq+0x30/0x184
 [<c012a893>] __rcu_process_callbacks+0x76/0xbb
 [<c011f979>] tasklet_action+0x53/0x93
 [<c011f754>] __do_softirq+0xba/0xcf
 [<c010e20e>] smp_apic_timer_interrupt+0x2c/0x35
 [<c01032e0>] apic_timer_interrupt+0x28/0x30
 [<c017c88d>] generic_file_splice_read+0x75/0xc9
 [<c017d083>] do_splice_to+0x6e/0x90
 [<c017d144>] splice_direct_to_actor+0x9f/0x166
 [<f8f2cf72>] nfsd_direct_splice_actor+0x0/0xa [nfsd]
 [<c017c818>] generic_file_splice_read+0x0/0xc9
 [<f8f2d309>] nfsd_vfs_read+0x38d/0x3b1 [nfsd]
 [<f8f2b3b8>] nfsd_acceptable+0x0/0xd1 [nfsd]
 [<c016014f>] dentry_open+0x34/0x64
 [<f8f2d73c>] nfsd_read+0xee/0xfb [nfsd]
 [<f8f33b8b>] nfsd3_proc_read+0xfe/0x186 [nfsd]
 [<f8f354cb>] nfs3svc_decode_readargs+0x0/0xeb [nfsd]
 [<f8f29855>] nfsd_dispatch+0xc5/0x1ac [nfsd]
 [<c0445ab2>] svcauth_unix_set_client+0x116/0x165
 [<c0441ad1>] svc_process+0x4e9/0x6b4
 [<c01168e2>] default_wake_function+0x0/0x8
 [<f8f2963d>] nfsd+0x16a/0x290 [nfsd]
 [<f8f294d3>] nfsd+0x0/0x290 [nfsd]
 [<c0103463>] kernel_thread_helper+0x7/0x10
 =======================

> http://article.gmane.org/gmane.linux.nfs/19130
> 
> The second however, leads me to think the (relatively new) scheduler might 
> be involved through __check_preempt_curr_fair.

Nope, it looks like the splice code got stuck

> I'm now trying 2.6.22.19, which has a recent lockd issue with NFS fixed 
> but hasn't had the scheduler update.
> 
> How do I go about debugging this problem? What do you experts think?

This ex-expert has real worries about generic_file_splice_read().  For
starters, if __generic_file_splice_read() decides to return zero all the
time, that function will lock up.

Anyway.  Jens, I think we have a splice problem here.
