Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYFMIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYFMIiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYFMIiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:38:04 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:41944 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYFMIiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:38:01 -0400
Message-ID: <485231E6.30101@aitel.hist.no>
Date: Fri, 13 Jun 2008 10:37:58 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jakub Jozwicki <jozwicki@aster.pl>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sched_yield() on 2.6.25
References: <aCBfw-3Cv-23@gated-at.bofh.it> <aCBfw-3Cv-21@gated-at.bofh.it>  <aCJd6-3IF-11@gated-at.bofh.it> <aCRaM-8cM-33@gated-at.bofh.it>  <20080611152807.0682218F62@be1.lrz> <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com> <Pine.LNX.4.58.0806130006530.8419@be10.lrz>
In-Reply-To: <Pine.LNX.4.58.0806130006530.8419@be10.lrz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Thu, 12 Jun 2008, Leon Woestenberg wrote:
>   
[...]
>>
>> As the code after sched_yield() has to be executed the thread will be
>> rescheduled soon (or even immediately) anyway.
>>     
>
> The code after yield() is most likely to not run successfully (and as a
> result will return to the yield call) unless some time passes, and this
> time can pass while another process gets the CPU. It might even depend on
> another process to change the system state.
>
> Besides that, "Schedule another process, if you can" is part of the 
> semantics of yield. The code after yield should therefore be expected to 
> NOT be the very next code to run.
>
> If you can't do that, it's fine, the process will abuse some more innocent 
> electrons for busy waiting, but if you can support this yield() semantics, 
> the system will perform much better. Won't it?
>   
The system as a whole will perform better if the busy-wait is avoided - yes.
A multithreaded app actually using yield this way may suffer badly though.

Consider a case where two threads use yield() for synchronization, and 
there is
some contention. Ideally, the two threads want to ping-pong the cpu between
them. In the precence of other processes, they want to use up their fair 
amount of
cpu in this manner. If they busy-wait, then both the app and the system 
overall gets
slower.

Now, consider what happens if yield() really do lower the priority, or 
does something
like "sleep(1)  unless there really is nothing else to run". 
Busy-waiting will disappear,
and the overall performance will be fine. The app running alone will 
also seem fine.

The app running with some contention - massive use of yield - on a machine
with some other load will almost stop. Every yield will wait for all the 
other
processes on the system, not only the process/thread we needed to wait for.

Ideally, yield() from a non-realtime process should cause a segfault, 
that would
crash all software abusing it, forcing a change. Too drastic though. :-/

>> The users not understanding the limited scope where sched_yield()
>> behaves deterministicly, seem to think that _yield() will yield() AND
>> lower the thread's dynamic priority for SCHED_OTHER. Is downgrading
>> the dynamic priority a behavioral option?
>>     
>
> I expect it to be. It may cause lower-nice-level processes to run,
> but the (lack of) definition allows it.
>   
And this is the problem - suddenly those niced cpu hogs trumps an
interactive process that seems hopelessly stuck.

Helge Hafting
