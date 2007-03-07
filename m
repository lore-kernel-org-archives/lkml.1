Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXCGBpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXCGBpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXCGBpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:45:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44459 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161175AbXCGBpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:45:20 -0500
Message-ID: <45EE190E.4060904@vmware.com>
Date: Tue, 06 Mar 2007 17:44:46 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0A68.6010406@vmware.com> <1173230571.24738.534.camel@localhost.localdomain>
In-Reply-To: <1173230571.24738.534.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 01:44:40.0849 (UTC) FILETIME=[2C374010:01C7605A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2007 05:22 PM, Thomas Gleixner wrote:
> On Tue, 2007-03-06 at 16:42 -0800, Dan Hecht wrote:
>>>> accounting would be wrong.  Instead, we should allow the 
>>>> tick_sched_timer in cases (c) and (d) to have runtime configurable 
>>>> period, and then scale the time value accordingly before passing to 
>>>> account_system_time.  This is probably something the Xen folks will want 
>>>> also, since I think Xen itself only gets 100hz hard timer, and so it can 
>>>> implement at best a oneshot virtual timer with 100hz resolution.  Any 
>>>> objections to us doing something like this?
>>> Yes. It's gross hackery. 
>>>
>>> 1) We want to have a cleanup of the tick assumptions _all_ over the
>>> place and this is going to be real hard work.
>>>
>>> 2) As I said above. The time accounting for virtualization needs to be
>>> fixed in a generic way.
>>>
>>> I'm not going to accept some weird hackery for virtualization, which is
>>> of exactly ZERO value for the kernel itself. Quite the contrary it will
>>> make the cleanup harder and introduce another hard to remove thing,
>>> which will in the worst case last for ever.
>>>
>> Okay, to confirm I'm on the same page as you, you want to move process 
>> time accounting from being periodic sampled based to being trace based? 
>> i.e. at the system-call/interrupt boundaries, read clocksource and 
>> compute directly the amount of system/user/process time?
> 
> At least for the paravirt guests this is the correct approach. Once the
> CPU vendors come up with a sane solution for a reliable and fast clock
> source we might use that on real hardware as well.
> 

I thought your preference was to not do things differently from real 
hardware?  I guess this case you are okay with since you'd like to see 
the real hardware case follow eventually?

In any case, in paravirt the costs of reading timers and doing system 
call transitions are a bit different than on native, so we'll need to 
figure out what makes sense given those costs.

>> Do you know if anyone has explored this?  I thought there was a 
>> discussion about this a while back but it was rejected due to the 
>> sample-based approach having much lower overheads on high system call 
>> rate workloads.
> 
> Yes, with todays hardware it is simply a PITA. PowerPC has some basic
> support for this though, IIRC.
> 

I think S390 maybe too.
