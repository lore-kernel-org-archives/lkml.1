Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZFJBng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZFJBng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZFJBn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:43:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbZFJBn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:43:28 -0400
Date: Tue, 9 Jun 2009 18:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       oleg@redhat.com, dipankar@in.ibm.com
Subject: Re: [PATCH -mm resend] cpuhotplug: introduce try_get_online_cpus()
 take 3
Message-Id: <20090609184238.06b38c3e.akpm@linux-foundation.org>
In-Reply-To: <4A2F08D6.6060309@cn.fujitsu.com>
References: <4A1F9CEA.1070705@cn.fujitsu.com>
	<20090530015342.GA21502@linux.vnet.ibm.com>
	<20090530043739.GA12157@in.ibm.com>
	<4A27708C.6030703@cn.fujitsu.com>
	<20090605153714.GB6778@linux.vnet.ibm.com>
	<20090608041934.GB17979@in.ibm.com>
	<20090608142520.GA6961@linux.vnet.ibm.com>
	<4A2E506D.9090107@cn.fujitsu.com>
	<20090609123438.b936137e.akpm@linux-foundation.org>
	<20090609234757.GH16117@linux.vnet.ibm.com>
	<4A2F08D6.6060309@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 09:13:58 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> It's for -mm tree.
> 
> It also works for mainline if you apply this at first:
> http://lkml.org/lkml/2009/2/17/58
> 
> Subject: [PATCH -mm] cpuhotplug: introduce try_get_online_cpus() take 3
> 
> get_online_cpus() is a typically coarsely granular lock.
> It's a source of ABBA or ABBCCA... deadlock.
> 
> Thanks to the CPU notifiers, Some subsystem's global lock will
> be required after cpu_hotplug.lock. Subsystem's global lock
> is coarsely granular lock too, thus a lot's of lock in kernel
> should be required after cpu_hotplug.lock(if we need
> cpu_hotplug.lock held too)
> 
> Otherwise it may come to a ABBA deadlock like this:
> 
> thread 1                                      |        thread 2
> _cpu_down()                                   |  Lock a-kernel-lock.
>   cpu_hotplug_begin()                         |
>     mutex_lock(&cpu_hotplug.lock)             |
>   __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
> ------------------------------------------------------------------------
>     Lock a-kernel-lock.(wait thread2)         |    mutex_lock(&cpu_hotplug.lock)
>                                                    (wait thread 1)

uh, OK.

> But CPU online/offline are happened very rarely, get_online_cpus()
> returns success quickly in all probability.
> So it's an asinine behavior that get_online_cpus() is not allowed
> to be required after we had held "a-kernel-lock".
> 
> To dispel the ABBA deadlock, this patch introduces
> try_get_online_cpus(). It returns fail very rarely. It gives the
> caller a chance to select an alternative way to finish works,
> instead of sleeping or deadlock.

I still think we should really avoid having to do this.  trylocks are
nasty things.

Looking at the above, one would think that a correct fix would be to fix
the bug in "thread 2": take the locks in the correct order?  As
try_get_online_cpus() doesn't actually have any callers, it's hard to
take that thought any further.

