Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZCRHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZCRHDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 03:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZCRHDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 03:03:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62175 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZCRHDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 03:03:36 -0400
Message-ID: <49C09C77.3050300@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 15:02:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ftrace: fast path for do_ftrace_mod_code()
References: <49BE4BF7.6050407@cn.fujitsu.com>	 <1237225372.3624.15.camel@localhost.localdomain>	 <49BF9D8A.4070200@cn.fujitsu.com>  <49BF9E69.80908@cn.fujitsu.com> <1237300777.3624.36.camel@localhost.localdomain>
In-Reply-To: <1237300777.3624.36.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> I'm a bit nervous about this code. We do not get much benefit from it,
> because the NMI case is an anomaly, and is not a fast path anyway. This
> code only happens when we are running the stop_machine, and this adds
> added complexity for little benefit.
> 
> The original patch was to prevent an actual live lock I got in one of my
> tests. The problem was that the failure of the write caused a printk
> stack dump. But the time it took the print to go out over the serial was
> long enough that the next NMI triggered when it finished. The new NMI
> hit the same error and did another print. Thus, all I got was a lot of
> prints out over the serial, but the system was dead.
> 

Thank you. I understand.


> I like the first patch. but you remove the protection there. It should
> have been in this patch. But it should have still added the
> functionality of the previous method.

I separated it into two parts, I thought it will good for review.
But I wrote two bad patches.

>> @@ -161,6 +167,7 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
>>  {
>>  	mod_code_ip = (void *)ip;
>>  	mod_code_newcode = new_code;
>> +	mod_code_no_write = 0;
> 
> Here's another issue, if mod_code_status failed, we do not want to have
> mod_code_no_write become zero again. The logic may indeed prevent this,
> but I rather have the logic be straight forward, and just set this to
> one when we have a failure and forget about it. Yes, it is a bit more
> expensive, but it makes the code clearer.

It confused me.

do_ftrace_mod_code() is called sequently, mod_code_no_write should become zero
in new calls.

Not like old code, when the first patch is applied, there is no NMI
is attempt to call probe_kernel_write() when we just enter do_ftrace_mod_code(),
so setting mod_code_no_write to 0 is safe.(Because the flag is not set)

Lai.


