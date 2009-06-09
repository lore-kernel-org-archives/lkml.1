Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZFITfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZFITfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFITfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:35:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbZFITfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:35:38 -0400
Date: Tue, 9 Jun 2009 12:34:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       oleg@redhat.com, dipankar@in.ibm.com
Subject: Re: [PATCH -mm] cpuhotplug: introduce try_get_online_cpus() take 3
Message-Id: <20090609123438.b936137e.akpm@linux-foundation.org>
In-Reply-To: <4A2E506D.9090107@cn.fujitsu.com>
References: <4A1F9CEA.1070705@cn.fujitsu.com>
	<20090530015342.GA21502@linux.vnet.ibm.com>
	<20090530043739.GA12157@in.ibm.com>
	<4A27708C.6030703@cn.fujitsu.com>
	<20090605153714.GB6778@linux.vnet.ibm.com>
	<20090608041934.GB17979@in.ibm.com>
	<20090608142520.GA6961@linux.vnet.ibm.com>
	<4A2E506D.9090107@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 20:07:09 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> get_online_cpus() is a typically coarsely granular lock.
> It's a source of ABBA deadlock.
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
>     down_write(&cpu_hotplug.lock)             |
>   __raw_notifier_call_chain(CPU_DOWN_PREPARE) |  get_online_cpus()
> ------------------------------------------------------------------------
>     Lock a-kernel-lock.(wait thread2)         |    down_read(&cpu_hotplug.lock)
>                                                    (wait thread 1)

Confused.  cpu_hotplug_begin() doesn't do
down_write(&cpu_hotplug.lock).  If it _were_ to do that then yes, we'd
be vulnerable to the above deadlock.

