Return-Path: <linux-kernel-owner+w=401wt.eu-S1030218AbXBFWrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbXBFWrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030200AbXBFWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:47:09 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59264 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030218AbXBFWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:47:08 -0500
Message-ID: <45C9056A.8060504@vmware.com>
Date: Tue, 06 Feb 2007 14:47:06 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/11] Sched clock paravirt op
References: <200702060352.l163qeAf000727@zach-dev.vmware.com> <20070206123256.GF47229@muc.de>
In-Reply-To: <20070206123256.GF47229@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>  	.write_msr = native_write_msr,
>>  	.read_tsc = native_read_tsc,
>>  	.read_pmc = native_read_pmc,
>> +	.get_scheduled_cycles = native_read_tsc,
>> +	.get_cpu_khz = native_calculate_cpu_khz,
>>  	.load_tr_desc = native_load_tr_desc,
>>     
> Description missing? 
>   

I missed a title / signed-off on this guy.


Internally, sched_clock runs in units of nanoseconds, not CPU cycles.  
This was wrong in my previous patch.  Fix it so everyone can use the 
same cycles_2_ns code in tsc.c.

Signed-off-by: Zachary Amsden <zach@vmware.com>

> Please write at least two paragraphs or more on each new hook
> you want to add.
>   

Not a new hook; I just changed the name.

> My feeling is that rdtsc should work fine here. If not please explain.
>   

It depends.  Scheduled clock must be in units of available time - stolen 
time is not always evenly distributed.  If you make rdtsc just be 
scheduled clock, that almost works.  But most places that use rdtsc 
expect it to be in cycles of approximate real time, and to leap forward 
if something like SMM comes along and steals time.

Not that this is pretty.  Arguably, the TSC should just run at a fixed 
rate, not progress during stolen time.  This idealized TSC assumption is 
not however how Linux is making use of the TSC today.  TSC is more like 
real time, only in a VM, it can't quite keep up with real time, so it 
gets simulated.

Scheduled (or available) time and real time are good notions.  Stolen 
time is debatable.  But TSC is basically just always wrong.  That's why 
I don't want to overload the rdtsc operation.

Zach
