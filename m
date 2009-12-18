Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZLRPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZLRPeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZLRPe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:34:27 -0500
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:55868 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754577AbZLRPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:34:25 -0500
Message-ID: <4B2BA0FC.2050405@moving-picture.com>
Date: Fri, 18 Dec 2009 15:34:20 +0000
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrea Suisani <sickpig@opinioni.net>, linux-kernel@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: High load average on idle machine running 2.6.32
References: <4B1D8C5D.9040900@moving-picture.com>	 <4B2121E2.2030900@moving-picture.com> <4B267A9C.6010804@moving-picture.com>	 <4B2B871C.3040300@opinioni.net> <1261145551.20899.208.camel@laptop>
In-Reply-To: <1261145551.20899.208.camel@laptop>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
>>>So I guess, it is not just one patch that has caused the issue I'm 
>>>seeing, which I guess is to be expected as the above patch was part of 
>>>the 'scheduler updates for v2.6.32' patch set 
> 
> 
> Right, so the thing that seems most likely to cause such funnies is the
> introduction of TASK_WAKING state in .32, during development we had a
> brief period where we saw what you described, but I haven't seen it
> after:
> 
> commit eb24073bc1fe3e569a855cf38d529fb650c35524
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Sep 16 21:09:13 2009 +0200
> 
>     sched: Fix TASK_WAKING & loadaverage breakage

Yes, I did hit that while bisecting - and got load averages in the tens 
of thousands - this, of course, masked the load averages I was seeing - 
so I cheated and applied that patch to the bisects to proceed - I guess 
I should have mentioned that earlier. i.e. I'm not seeing ridiculously 
large load averages - but idle load averages of about 2 or 3

>>>I guess as no one else has reported this issue - it must be something to 
>>>do with my set up - could using NFS-root affect how the load average is 
>>>calculated?
> 
> 
> So the thing that contributes to load is TASK_UNINTERRUPTIBLE sleeps
> (and !PF_FREEZING) as tested by task_contributes_to_load().
> 
> Are you seeing a matching number of tasks being stuck in 'D' state when
> the load is high? If so, how are these tasks affected by iftop/hotplug?

No - but running 'echo w > /proc/sysreq-trigger' I occassionally see 
'portmap' in 'D' state

e.g.

SysRq : Show Blocked State
   task                        PC stack   pid father
portmap       D ffffffff8102e05e     0  3660      1 0x00000000
  ffff88043e5d4440 0000000000000082 0000000000000000 0000000000000000
  0000000000000000 ffff88043f84db00 0000000000000000 0000000100009921
  ffff88043e5d46b0 0000000081353f24 0000000000000000 000000003ea193b8

But I also see these with a 2.6.31 kernel when the load is O (or there 
abouts)

If I stop portmap, the load does drop - e.g from 3.0 to 1.5, but not to zero

Another thing I've noticed is that when running 'top' (I'm using CentOS 
4.7 as the distro) in 'SMP' mode (so all CPUs are listed), the % idle of 
one or more of the CPUs shows 0.0% - the other CPUs show a % idle of 
100.0% or 99.x% - I don't know if this top not reporting correctly, but 
I don't see this when running a 2.6.31 kernel - in this case, all the 
CPUs report 100.0% or 99.x% idle all the time.

e.g with 2.6.32 I see:

> top - 15:25:27 up 36 min,  3 users,  load average: 2.20, 2.21, 2.01
> Tasks: 171 total,   1 running, 170 sleeping,   0 stopped,   0 zombie
> Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu2  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu3  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu4  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu5  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu6  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu7  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si

I don't know if this is significant

Thanks

James Pearson
