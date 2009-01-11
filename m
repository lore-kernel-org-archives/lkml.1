Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZAKTO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZAKTO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZAKTOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:14:48 -0500
Received: from relay3.sgi.com ([192.48.171.31]:33630 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752910AbZAKTOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:14:47 -0500
Message-ID: <496A451C.5030400@sgi.com>
Date: Sun, 11 Jan 2009 11:14:36 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dieter Ries <clip2@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <20090111190218.GA18651@elte.hu>
In-Reply-To: <20090111190218.GA18651@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dieter Ries <clip2@gmx.de> wrote:
> 
>> Bisected it:
>>
>> ####################################################################
>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
>> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
>> Author: Mike Travis <travis@sgi.com>
>> Date:   Sun Jan 4 05:18:09 2009 -0800
>>
>> cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>>
>> Impact: use new cpumask API to reduce stack usage
> 
> thanks, this is very helpful!
> 
> Mike, most of the work_on_cpu() patches you did so far were rather 
> problematic. Especially something like cpufreq can run rather early during 
> bootup or during suspend/resume, so i'm not sure it's correct to rely on 
> keventd for it.
> 
> I dont see anything particularly wrong in the commit itself - but 
> obviously it causes this boot hang - if the bug is not found we'll revert 
> it .

All of these are low use functions, primarily used when bringing up
cpus.  So reverting the patches does not have a big effect on the stack
size problem.
> 
> Also, this bit in get_cur_val():
> 
> +       if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
> +               return 0;
> 
> how is that supposed to work? If we fail to allocate a cpumask we just 
> ignore the call silently? That cannot be right. (but has no connection to 
> this boot problem)
> 
> 	Ingo

Well I did have a different approach but Rusty seemed to really be
attached to work_on_cpu.  (The alternate was to add a 2nd cpumask to the
task struct to hold current->cpus_allowed while setting it to a special
cpus_allowed mask.)

In any case, except for the get_online_cpus() call, work_on_cpu is a
fairly straight forward approach.  But I'm just not familiar enough
with the whole locking scheme to determine whether the cpu hotplug lock
has already been taken, which is causing this weird lockdep warning.
And I don't know of an adaptive way to do it (figure out in work_on_cpu()
if get_online_cpus() should be called or not.)

About the return 0, it was the default return for another error case.
Should the function panic because it can't read a cpu reg?  That seems
wrong too.

Thanks,
Mike
