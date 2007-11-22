Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXKVHrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXKVHrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXKVHqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:46:52 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37987 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbXKVHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:46:51 -0500
Date: Wed, 21 Nov 2007 23:46:52 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071122074652.GA6502@vmware.com>
References: <20071116221404.GC31527@vmware.com> <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com> <20071117010352.GA13666@vmware.com> <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com> <20071119185116.GA28173@vmware.com> <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com> <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu> <20071120180643.GD4736@vmware.com> <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 10:47:52PM +0100, Dmitry Adamushko wrote:
> btw., what's your system? If I recall right, SD_BALANCE_NEWIDLE is on
> by default for all configs, except for NUMA nodes.

It's a dual AMD64 Opteron.

So, I recompiled my 2.6.23.1 kernel without NUMA support, and with
your patch for scheduling domain flags in /proc. It looks like with
NUMA disabled, my test case no longer shows the CPU imbalance
problem. Cool.

With NUMA disabled (and my test running smoothly), the flags show that
SD_BALANCE_NEWIDLE is set:

root@micah-64:~# cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
55

Next I turned it off:

root@micah-64:~# echo 53 > /proc/sys/kernel/sched_domain/cpu0/domain0/flags
root@micah-64:~# echo 53 > /proc/sys/kernel/sched_domain/cpu1/domain0/flags

Oddly enough, I still don't observe the CPU imbalance problem.

Now I reboot into a kernel which has NUMA re-enabled but which is
otherwise identical. I verify that now I can reproduce the CPU
imbalance again.

root@micah-64:~# cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
1101

Now I set cpu[10]/domain0/flags to 1099, and the imbalance immediately
disappears. I can reliably cause the imbalance again by setting it
back to 1101, and remove the imbalance by setting them to 1099.

Do these results make sense? I'm not sure I understand how
SD_BALANCE_NEWIDLE could be the whole story, since my /proc/schedstat
graphs do show that we continuously try to balance on idle, but we
can't successfully do so because the idle CPU has a much higher load
than the non-idle CPU. I don't understand how the problem I'm seeing
could be related to the time at which we run the balancer, rather than
being related to the load average calculation.

Assuming the CPU imbalance I'm seeing is actually related to
SD_BALANCE_NEWIDLE being unset, I have a couple of questions:

 - Is this intended/expected behaviour for a machine without
   NEWIDLE set? I'm not familiar with the rationale for disabling
   this flag on NUMA systems.

 - Is there a good way to detect, without any kernel debug flags
   set, whether the current machine has any scheduling domains
   that are missing the SD_BALANCE_NEWIDLE bit? I'm looking for
   a good way to work around the problem I'm seeing with VMware's
   code. Right now the best I can do is disable all thread priority
   elevation when running on an SMP machine with Linux 2.6.20 or
   later.

Thank you again for all your help.
--Micah
