Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZLBNaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZLBNaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZLBNaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:30:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZLBNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:30:06 -0500
Date: Wed, 2 Dec 2009 14:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten
 __ticket_spin_trylock()
Message-ID: <20091202132937.GA1564@elte.hu>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
 <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:

> Commit-ID:  133ec7a235160dd44cbd4d82fff65a9983331df9
> Gitweb:     http://git.kernel.org/tip/133ec7a235160dd44cbd4d82fff65a9983331df9
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Fri, 27 Nov 2009 15:09:16 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 2 Dec 2009 11:11:11 +0100
> 
> locking, x86: Slightly shorten __ticket_spin_trylock()

-tip testing found that this causes a boot regression (locking during 
boot):

commit 133ec7a235160dd44cbd4d82fff65a9983331df9
Author: Jan Beulich <JBeulich@novell.com>
Date:   Fri Nov 27 15:09:16 2009 +0000

    locking, x86: Slightly shorten __ticket_spin_trylock()
    
    Since the callers generally expect a boolean value, there's no
    need to zero-extend the outcome of the comparison. It just
    requires that all of x86' trylock implementations return bo

After a couple of silent hangs in random places during bootup i got one 
bootup that has a more telling output:

CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8041.67 BogoMIPS).
BUG: spinlock wrong owner on CPU#0, swapper/1
 lock: 7b20b340, .magic: dead4ead, .owner: swapper/0, .owner_cpu: -1
Pid: 1, comm: swapper Not tainted 2.6.32-rc8-tip-02745-g401930b-dirty 
#9729
Call Trace:
 [<792a9959>] ? _raw_spin_unlock+0x46/0x76
 [<79a8729c>] ? _spin_unlock_irqrestore+0x8/0x12
 [<790268ae>] ? wait_task_inactive+0x73/0xa3
 [<7902a0b5>] ? kthread_bind+0x1e/0x8a
 [<79037b46>] ? start_workqueue_thread+0x13/0x1d
 [<79037f99>] ? __create_workqueue_key+0x10b/0x165
 [<7a02e26e>] ? init_workqueues+0x78/0x83
 [<7a01d2f4>] ? kernel_init+0x12b/0x1ae
 [<7a01d1c9>] ? kernel_init+0x0/0x1ae
 [<79002dbf>] ? kernel_thread_helper+0x7/0x10
device: 'platform': device_add
khelper used greatest stack depth: 3336 bytes left

at first quick sight, this bit looks odd:

+       union { int i; bool b; } new;

+       return new.b;

shouldnt that be short based, to work correctly in the 0-255 CPUs case?

	Ingo
