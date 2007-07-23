Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbXGWNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbXGWNVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762877AbXGWNVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:21:25 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:48952 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762602AbXGWNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:21:24 -0400
Subject: Re: [PATCH] virtual sched_clock() for s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       anton@samba.org
In-Reply-To: <1185182149.5783.11.camel@localhost.localdomain>
References: <1184842661.6546.14.camel@localhost.localdomain>
	 <469F8342.7060000@goop.org> <20070719160025.GA31815@elte.hu>
	 <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
	 <20070720072245.GA4020@elte.hu>
	 <1185182149.5783.11.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 23 Jul 2007 15:24:08 +0200
Message-Id: <1185197048.7816.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 09:15 +0000, Jan Glauber wrote:
> > > As with s390, 64-bit PowerPC also uses CONFIG_VIRT_CPU_ACCOUNTING. 
> > > That affects how tsk->utime and tsk->stime are accumulated (we call 
> > > account_user_time and account_system_time directly rather than calling 
> > > update_process_times) as well as the system hardirq/softirq time, idle 
> > > time, and stolen time.
> > 
> > tsk->utime and tsk->stime is only used for a single purpose: to 
> > determine the 'split' factor of how to split up the precise total time 
> > between user and system time.

At least for s390 and powerpc the utime and stime already contain a very
precise value how much time was spent in the user and system context.
For s390 the granularity is a microsecond. The other values nice, idle,
iowait, irq, softirq and steal are precise as well.

> > > When you say "precise task statistics for /proc", where are they 
> > > accumulated?  I don't see any changes to the way that tsk->utime and 
> > > ctime are computed.
> > 
> > we now use p->se.sum_exec_runtime that measures (in nanoseconds) the 
> > precise amount of time spent executing (sum of system and user time) - 
> > and ->stime and ->utime is used to determine the 'split'. [this allows 
> > us to gather ->stime and ->utime via low-resolution sampling, while 
> > keeping the 'total' precise. Accounting at every system entry point 
> > would be quite expensive on most platforms.]

With the exact accounting of utime and stime that would mean that
p->se.sum_exec_runtime is utime + stime, no?
Precise Accounting at every cpu context switch has some cost, but for
s390 it is not as bad as it sounds. We do 2 store-cpu-timer (STPT)
instructions, 2 64 bit adds and 2 64 bit subtracts. In terms of cycles
it is less than 30 cycles on each system entry on the latest machine.

> Using se.sum_exec_runtime to generate ->utime and ->stime breaks
> the process accounting we have on s390 (and probably on PowerPC too).
> With CONFIG_VIRT_CPU_ACCOUNTING we already have precise values in
> ->utime and ->stime. Can we make the calculation of the CFS-based time
> values conditional by CONFIG_VIRT_CPU_ACCOUNTING?

Imho, we just have to update utime and stime when the process accounting
values are requested and set se.sum_exec_runtime to the sum of utime and
stime for CONFIG_VIRT_CPU_ACCOUNTING=y.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



