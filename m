Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYJQMpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYJQMpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbYJQMox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:44:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:53693 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbYJQMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DVgCON3Q2tZnobXYvViLq+YbeqwaUcKVHb9Ak0EFM5jS8BlE3IiLBlu9p1+cYYSpem
         S/EsgcwGQ/2zobf1WNQ/vAAbGzSQplHUi2tXR4ywMs1Gcsmenv4jw6nbVMr++EbgB/7D
         SsyYKtHU26qeH7Oja5JCmIdJFR6YJ7pHjtUmY=
Message-ID: <e7baa9c80810170544q1eaec469vc3a1ad2cba8e4ee0@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:44:51 +0800
From: "Lai Jiangshan" <eag0628@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] x86/proc: fix /proc/cpuinfo cpu offline bug
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081017114132.GA18994@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F852FD.7070108@cn.fujitsu.com>
	 <20081017114132.GA18994@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 7:41 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Oct 17, 2008 at 04:55:25PM +0800, Lai Jiangshan wrote:
>> In my test, I found that if a cpu has been offline,
>> the next cpus may not be shown in the /proc/cpuinfo.
>>
>> trivially reproduce this bug:
>>
>> 1) add these lines in the end of show_cpuinfo()
>>       if (m->size - m->count - 20 > 0)
>>               seq_printf(m, "%*s", (int)(m->size - m->count - 20), "show bug\n");
>
> What is it?
>
> Can you just show wrong /proc/cpuinfo ?
>
> Can someone with at least 4-way box please do so?

this is not wrong /proc/cpuinfo, this is an enlarged /proc/cpuinfo
this trivial example just use "show bug\n" as the enlarged content.

if you boot your machine with enough cpu, your /proc/cpuinfo
have been enlarged too, please use this:

#!/bin/sh
nr_cpus=16 #  i386
for ((i=1; i<nr_cpus; i++))
do
    echo 0 > /sys/devices/system/cpu/cpu$i/online
    cpus=$(grep processor /proc/cpuinfo | wc -l)
    (( cpus == nr_cpus -1 )) || break; # bug eccur
    echo 1 > /sys/devices/system/cpu/cpu$i/online
done
cat /proc/cpuinfo  # it shows this bug.

Lai

>
>> 3) offline cpu#1
>> 4) cat /proc/cpuinfo
>>    cpu#2 and cpu#3 .... cannot be shown in /proc/cpuinfo
>
>> --- a/arch/x86/kernel/cpu/proc.c
>> +++ b/arch/x86/kernel/cpu/proc.c
>> @@ -160,14 +160,16 @@ static void *c_start(struct seq_file *m, loff_t *pos)
>>  {
>>       if (*pos == 0)  /* just in case, cpu 0 is not the first */
>>               *pos = first_cpu(cpu_online_map);
>> -     if ((*pos) < nr_cpu_ids && cpu_online(*pos))
>> +     else
>> +             *pos = next_cpu_nr(*pos - 1, cpu_online_map);
>> +     if ((*pos) < nr_cpu_ids)
>>               return &cpu_data(*pos);
>>       return NULL;
>>  }
>>
>>  static void *c_next(struct seq_file *m, void *v, loff_t *pos)
>>  {
>> -     *pos = next_cpu(*pos, cpu_online_map);
>> +     (*pos)++;
>>       return c_start(m, pos);
>>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
