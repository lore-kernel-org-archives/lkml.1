Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYJVEna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYJVEna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYJVEnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:43:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYJVEnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:43:20 -0400
Message-ID: <48FEAE6B.70809@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 12:39:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/proc: fix /proc/cpuinfo cpu offline bug
References: <48F852FD.7070108@cn.fujitsu.com>	 <20081017114132.GA18994@x200.localdomain> <e7baa9c80810170544q1eaec469vc3a1ad2cba8e4ee0@mail.gmail.com>
In-Reply-To: <e7baa9c80810170544q1eaec469vc3a1ad2cba8e4ee0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Ingo and Alexey,

I have changed my changelog. please review again.

Thanks, Lai.

Lai Jiangshan wrote:
> On Fri, Oct 17, 2008 at 7:41 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> On Fri, Oct 17, 2008 at 04:55:25PM +0800, Lai Jiangshan wrote:
>>> In my test, I found that if a cpu has been offline,
>>> the next cpus may not be shown in the /proc/cpuinfo.
>>>
>>> trivially reproduce this bug:
>>>
>>> 1) add these lines in the end of show_cpuinfo()
>>>       if (m->size - m->count - 20 > 0)
>>>               seq_printf(m, "%*s", (int)(m->size - m->count - 20), "show bug\n");
>> What is it?
>>
>> Can you just show wrong /proc/cpuinfo ?
>>
>> Can someone with at least 4-way box please do so?
> 
> this is not wrong /proc/cpuinfo, this is an enlarged /proc/cpuinfo
> this trivial example just use "show bug\n" as the enlarged content.
> 
> if you boot your machine with enough cpu, your /proc/cpuinfo
> have been enlarged too, please use this:
> 
> #!/bin/sh
> nr_cpus=16 #  i386
> for ((i=1; i<nr_cpus; i++))
> do
>     echo 0 > /sys/devices/system/cpu/cpu$i/online
>     cpus=$(grep processor /proc/cpuinfo | wc -l)
>     (( cpus == nr_cpus -1 )) || break; # bug eccur
>     echo 1 > /sys/devices/system/cpu/cpu$i/online
> done
> cat /proc/cpuinfo  # it shows this bug.
> 
> Lai
> 
>>> 3) offline cpu#1
>>> 4) cat /proc/cpuinfo
>>>    cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo
>>> --- a/arch/x86/kernel/cpu/proc.c
>>> +++ b/arch/x86/kernel/cpu/proc.c
>>> @@ -160,14 +160,16 @@ static void *c_start(struct seq_file *m, loff_t *pos)
>>>  {
>>>       if (*pos == 0)  /* just in case, cpu 0 is not the first */
>>>               *pos = first_cpu(cpu_online_map);
>>> -     if ((*pos) < nr_cpu_ids && cpu_online(*pos))
>>> +     else
>>> +             *pos = next_cpu_nr(*pos - 1, cpu_online_map);
>>> +     if ((*pos) < nr_cpu_ids)
>>>               return &cpu_data(*pos);
>>>       return NULL;
>>>  }
>>>
>>>  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
>>>  {
>>> -     *pos = next_cpu(*pos, cpu_online_map);
>>> +     (*pos)++;
>>>       return c_start(m, pos);
>>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 


