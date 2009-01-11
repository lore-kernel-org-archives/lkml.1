Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZAKTCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZAKTCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZAKTCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:02:09 -0500
Received: from relay3.sgi.com ([192.48.171.31]:43277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbZAKTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:02:08 -0500
Message-ID: <496A4228.5090807@sgi.com>
Date: Sun, 11 Jan 2009 11:02:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dieter Ries <clip2@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de>
In-Reply-To: <496A3F62.8090902@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> Hi,
> 
> Ingo Molnar schrieb:
>>>> * Dieter Ries <clip2@gmx.de> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
>>>>> When I try to boot it, that kind of works until init should start. Then
>>>>> nothing happens. I tried with init=/bin/bash, which sometimes works, and
>>>>> sometimes gets me a bash without the prompt flashing.
>>>>>
>>>>> I captured the output with netconsole, but I cannot see a problem there.
>>>>> It is attached.
>>>>>
>>>>> My config is also attached.
>>>>>
>>>>> The machine:
>>>>>
>>>>> Lenovo Thinkpad T60
>>>>> Core2Duo 2GHz
>>>>>
>>>>> Gentoo 64bit
>>>>>
>>>>>
>>>>> What else should I provide for debugging that?
>> Unless you can see some particular badness in the kernel messages 
>> (something that changed to the last working version) that narrows it down 
>> to some subsystem, i suspect this would have to be bisected ...
> 
> Bisected it:
> 
> ####################################################################
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:09 2009 -0800
> 
> cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> 
> Impact: use new cpumask API to reduce stack usage
> 
> Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr()
> with a work_on_cpu function for drv_read() and drv_write().
> 
> Basically converts do_drv_{read,write} into "work_on_cpu" functions that
> are now called by drv_read and drv_write.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ####################################################################
> 
> I reverted that patch, which makes my machine boot again. So I guess
> theres something wrong here. Please tell me which information you need
> to fix the problem, I will help as I can.
> 
> 
>> 	Ingo
>>
> 
> cu
> Dieter
> 

Thanks for catching this.

The work_on_cpu approach seems to create more problems than it solves.  And
testing it has proven difficult without the right combination of hardware.

Could you send me the console log and config file?

Rusty - any ideas on how to avoid these clashes with the get_online_cpus()
call in work_on_cpu()?  Or something else to indicate to lockdep that
the circular lock dependency is ok (as you mentioned before)?

Thanks,
Mike

