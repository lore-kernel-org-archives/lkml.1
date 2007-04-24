Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbXDXGwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbXDXGwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161361AbXDXGwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:52:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161339AbXDXGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:52:33 -0400
Date: Mon, 23 Apr 2007 23:49:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070423234910.50149faf.akpm@linux-foundation.org>
In-Reply-To: <20070327215827.871954359@goop.org>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 14:49:20 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The softlockup watchdog is currently a nuisance in a virtual machine,
> since the whole system could have the CPU stolen from it for a long
> period of time.  While it would be unlikely for a guest domain to be
> denied timer interrupts for over 10s, it could happen and any softlockup
> message would be completely spurious.
> 
> Earlier I proposed that sched_clock() return time in unstolen
> nanoseconds, which is how Xen and VMI currently implement it.  If the
> softlockup watchdog uses sched_clock() to measure time, it would
> automatically ignore stolen time, and therefore only report when the
> guest itself locked up.  When running native, sched_clock() returns
> real-time nanoseconds, so the behaviour would be unchanged.
> 
> Note that sched_clock() used this way is inherently per-cpu, so this
> patch makes sure that the per-processor watchdog thread initialized
> its own timestamp.

This patch
(ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/ignore-stolen-time-in-the-softlockup-watchdog.patch)
causes six failures in the locking self-tests, which I must say is rather
clever of it.


Here's the first one:

[17179569.184000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[17179569.184000] ... MAX_LOCKDEP_SUBCLASSES:    8
[17179569.184000] ... MAX_LOCK_DEPTH:          30
[17179569.184000] ... MAX_LOCKDEP_KEYS:        2048
[17179569.184000] ... CLASSHASH_SIZE:           1024
[17179569.184000] ... MAX_LOCKDEP_ENTRIES:     8192
[17179569.184000] ... MAX_LOCKDEP_CHAINS:      16384
[17179569.184000] ... CHAINHASH_SIZE:          8192
[17179569.184000]  memory used by lock dependency info: 992 kB
[17179569.184000]  per task-struct memory footprint: 1200 bytes
[17179569.184000] ------------------------
[17179569.184000] | Locking API testsuite:
[17179569.184000] ----------------------------------------------------------------------------
[17179569.184000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[17179569.184000]   --------------------------------------------------------------------------
[17179569.184000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184001]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184002]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184003]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184004]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184005]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184006]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184006]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[17179569.184006]   --------------------------------------------------------------------------
[17179569.184006]               recursive read-lock:             |  ok  |             |  ok  |
[17179569.184006]            recursive read-lock #2:             |  ok  |             |  ok  |
[17179569.184007]             mixed read-write-lock:             |  ok  |             |  ok  |
[17179569.184007]             mixed write-read-lock:             |  ok  |             |  ok  |
[17179569.184007]   --------------------------------------------------------------------------
[17179569.184007]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[17179569.184007]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[17179569.184007]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[17179569.184007]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[17179569.184007]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |irq event stamp: 458
[17179569.184007] hardirqs last  enabled at (458): [<c01e4116>] irqsafe2A_rlock_12+0x96/0xa3
[17179569.184007] hardirqs last disabled at (457): [<c01095b9>] sched_clock+0x5e/0xe9
[17179569.184007] softirqs last  enabled at (454): [<c01e4101>] irqsafe2A_rlock_12+0x81/0xa3
[17179569.184007] softirqs last disabled at (450): [<c01e408b>] irqsafe2A_rlock_12+0xb/0xa3
[17179569.184007] FAILED| [<c0104cf0>] dump_trace+0x63/0x1ec
[17179569.184007]  [<c0104e93>] show_trace_log_lvl+0x1a/0x30
[17179569.184007]  [<c01059ec>] show_trace+0x12/0x14
[17179569.184007]  [<c0105a45>] dump_stack+0x16/0x18
[17179569.184007]  [<c01e1eb5>] dotest+0x6b/0x3d0
[17179569.184007]  [<c01eb249>] locking_selftest+0x915/0x1a58
[17179569.184007]  [<c048c979>] start_kernel+0x1d0/0x2a2
[17179569.184007]  =======================
[17179569.184007] 
[17179569.184007]        sirq-safe-A => hirqs-on/21:irq event stamp: 462
[17179569.184007] hardirqs last  enabled at (462): [<c01e3eb2>] irqsafe2A_spin_21+0x1b/0xa3
[17179569.184007] hardirqs last disabled at (461): [<c01095b9>] sched_clock+0x5e/0xe9
[17179569.184007] softirqs last  enabled at (454): [<c01e4101>] irqsafe2A_rlock_12+0x81/0xa3
[17179569.184007] softirqs last disabled at (450): [<c01e408b>] irqsafe2A_rlock_12+0xb/0xa3
[17179569.184007]   ok  |irq event stamp: 466


It's a challenge to even find the code which corresponds with this failure,
so good luck.


It seems fairly sensitive to .config settings.  See
http://userweb.kernel.org/~akpm/config-sony.txt

Unfortunately this causes lockdep to disable itself, thus hiding all the
other bugs which people have contributed, so I'll drop your patch for now.
