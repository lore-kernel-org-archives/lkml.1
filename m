Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYGNS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYGNS4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYGNS4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:56:33 -0400
Received: from gw.goop.org ([64.81.55.164]:36913 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYGNS4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:56:32 -0400
Message-ID: <487BA152.1070102@goop.org>
Date: Mon, 14 Jul 2008 11:56:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com> <200807142234.40700.rusty@rustcorp.com.au>
In-Reply-To: <200807142234.40700.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 14 July 2008 21:51:25 Christian Borntraeger wrote:
>   
>> Am Montag, 14. Juli 2008 schrieb Hidetoshi Seto:
>>     
>>> +	/* Wait all others come to life */
>>> +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
>>> +		if (time_is_before_jiffies(limit))
>>> +			goto timeout;
>>> +		cpu_relax();
>>> +	}
>>> +
>>>       
>> Hmm. I think this could become interesting on virtual machines. The
>> hypervisor might be to busy to schedule a specific cpu at certain load
>> scenarios. This would cause a failure even if the cpu is not really locked
>> up. We had similar problems with the soft lockup daemon on s390.
>>     
>
> 5 seconds is a fairly long time.  If all else fails we could have a config 
> option to simply disable this code.
>
>   
>> It would be good to not-use wall-clock time, but really used cpu time
>> instead. Unfortunately I have no idea, if that is possible in a generic
>> way. Heiko, any ideas?
>>     
>
> Ah, cpu time comes up again.  Perhaps we should actually dig that up again; 
> Zach and Jeremy CC'd.

Hm, yeah. But in this case, it's tricky. CPU time is an inherently
per-cpu quantity. If cpu A is waiting for cpu B, and wants to do the
timeout in cpu-seconds, then it has to be in *B*s cpu-seconds (and if A
is waiting on B,C,D,E,F... it needs to measure separate timeouts with
separate timebases for each other CPU). It also means that if B is
unresponsive but also not consuming any time (blocked in IO,
administratively paused, etc), then the timeout will never trigger.

So I think monotonic wallclock time actually makes the most sense here.

The other issue is whether cpu_relax() is the right thing to put in the
busywait. We don't hook it in pvops, so it's just an x86 "pause"
instruction, so from the hypervisor's perspective it just looks like a
spinning CPU. We could either hook cpu_relax() into a hypervisor yield,
or come up with a heavier-weight cpu_snooze() (cpu_relax() is often used
in loops which are expected to have a short duration, where doing a
hypercall+yield would be overkill).

J
