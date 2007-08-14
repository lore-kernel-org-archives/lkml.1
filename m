Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbXHNIjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbXHNIjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXHNIir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:38:47 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:17742 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXHNIin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:38:43 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu>
In-Reply-To: <20070812163225.GA11996@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 14 Aug 2007 10:37:47 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708141037.48001.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2nd try with correct email address, sorry for the duplicates.

Am Sonntag, 12. August 2007 schrieb Ingo Molnar:
> Linus, please pull the latest scheduler git tree from:

Hello Ingo,

this is a followup to the discussion in 
http://lkml.org/lkml/2007/7/19/538

Since 2.6.12, s390 already does precise accouting for system and user time.  
Depending on CONFIG_VIRT_CPU_ACCOUNTING, we  use two 64bit hardware timers on 
s390: the first returns the wall clock time and is stepped even if the 
virtual cpu is not backed by a physical cpu. The second timer is only 
stepped, when the virtual cpu is backed by a physical cpu. The timers have a 
very high accurancy, and the architecture guarantees that bit 51 is increased 
by one/microsecond. We store both timers on each context switch, irq, 
syscall, and machinecheck in entry.S. The calculation are made in 
arch/s390/kernel/vtime.c in accouting_system_vtime and friends with 
microsecond accurracy. This is also used for irq accouting (see the 
definition of irq_enter). It basically boils down to precise numbers in the 
cpu stat and the utime/stime for processes as well as knowledge about time 
stolen by the hypervisor. 

With CFS the accounting was changed, and everything is now based on 
sum_exec_runtime.  There is now an accounting regression on s390 (and maybe 
ppc64), as the default jiffy implemenation does not know anything about 
virtual cpus.

While looking for a solution, I started with a very quick hack and reverted 
b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa for the procfs related changes. If I 
revert that commit, it seems that I get the old behaviour -  but of course 
this is just a hack.

I see some options now:

1. Jan could finish his sched_clock implementation for s390 and we would get 
close to the precise numbers. This would also let CFS make better decisions. 
Downside: its not as precise as before as we do some math on the numbers and 
it will burn cycles to compute numbers we already have 
(utime=sum*utime/stime). 
2. set sum_exec_runtime based on the precise utime and stime. Dont know enough 
about CFS if this would show different scheduling behaviour than 1
3. ifdef fs/proc/array.c depending on CONFIG_VIRT_CPU_ACCOUNTING. This will 
save some cycles, and the numbers are precise to a microsecond. Downside: the 
scheduler gets no information about virtual cpus and steal time so its 
probably not completely fair
4. implement sched_clock AND reuse the exisiting utime and stime numbers.
5. other clever solutions I cannot see

Any suggestions?

Christian
