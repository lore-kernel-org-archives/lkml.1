Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZBJGPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZBJGPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 01:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBJGPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 01:15:04 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:12219 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZBJGPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JYhG9toe4OEy4jI+iLK6kcBQGmSxnGXNx0JG0wb1Mn0SYjJaCg4xt7zrWyxQp2Inh8
         NP9wSNufa4M7jEMY+HvaOjYhp9XNU9WgHgVlWvivS3R0gOZpy5mcWsTh+Rs3TfHWYTLe
         NgrFfGOkzZ0L1G0uw6G0yl0KHJjSxmXI07uE4=
MIME-Version: 1.0
In-Reply-To: <20090210045803.GA31755@kamineko.org>
References: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com>
	 <20090210045803.GA31755@kamineko.org>
Date: Tue, 10 Feb 2009 04:15:00 -0200
Message-ID: <cc0fa41f0902092215i44823962t39033f6b987f273f@mail.gmail.com>
Subject: Re: ACPI regression in 2.6.29 - cpufreq_performance doesn't work
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yeah mattia, you were right about ondemand module was being used on
cpu1, so i couldn't remove it.
with this commited patch, both cpu's can now have different speeds.
i was just comparing cat /proc/cpuinfo and didn't notice that cpu0 was
at 2268MHz.
cpufrequtils will need an update do deal with this change.
btw, this looks strange:

dub:~# echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
performance
ondemand

dub:~# cat /proc/cpuinfo | grep MH
cpu MHz         : 2268.000
cpu MHz         : 800.000

dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/cpuinfo_cur_freq
2267000
2267000

dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_min_freq
800000
800000

dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_available_frequencies
2268000 2267000 1600000 800000
2268000 2267000 1600000 800000

doesn't cpu0/cpufreq/scaling_min_freq needs to be 2268000 and
scaling_frequencies
just have 2268000 because it's set to "performance"?

am i forgetting anything else to set?

thanks,


On Tue, Feb 10, 2009 at 2:58 AM, Mattia Dongili <malattia@linux.it> wrote:
> On Tue, Feb 10, 2009 at 01:53:13AM -0200, Guilherme Malschitzky Schroeder wrote:
>> Hi,
>>
>> If i set performance for scaling_governor using 2.6.29-rc4-git2,
>> ondemand stills control my CPU.
>> I get just 800MHz instead of 2268MHz.
>>
>> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
>> 800000
>> dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
>> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
>> performance
>> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
>> 2267000
>>
>> But, /proc/cpuinfo still shows 800MHz:
>>
>> model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
>> stepping        : 6
>> cpu MHz         : 800.000
>>
>> And i cannot remove the ondemand module, that is not used anymore:
>>
>> dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
>> ERROR: Module cpufreq_ondemand is in use
>
> yes, I guess it is used by cpu1, you should repeat the above commands
> for /sys/devices/system/cpu/cpu1/cpufreq too.
>
> ...
>> I've git bisect from 2.6.28.4 (which was working) to 2.6.29-rc4-git2
>> and i get into this:
>>
>> alemao@dub:~/linux-2.6$ git bisect good
>> d96f94c604453f87fe24154b87e1e9a3a72511f8 is first bad commit
>> commit d96f94c604453f87fe24154b87e1e9a3a72511f8
>> Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>> Date:   Mon Feb 2 11:57:18 2009 -0800
>>
>>     ACPI: Enable bit 11 in _PDC to advertise hw coord
>>
>>     Bit 11 in intel PDC definitions is meant for OS capability to handle
>>     hardware coordination of P-states. In Linux we have always supported
>>     hwardware coordination of P-states. Just let the BIOSes know that we
>>     support it, by setting this bit.
>>
>>     Some BIOSes use this bit to choose between hardware or software coordination
>>     and without this change below, BIOSes switch to software coordination, which
>>     is not very optimal in terms of power consumption and extra
>> wakeups from idle.
>>
>>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>     Signed-off-by: Len Brown <len.brown@intel.com>
>
> the "coordination of P-states" is required when you have an SMP system
> that cannot scale cpu voltage independently on each cpu, so the best
> voltage/frequency have to be selected mediating between all the applied
> policies.
> The commit you found above just makes use hw coordination instead of sw
> and the message explains why.
>
> If you make sure you change *all* of the cpu policies you won't see the
> behaviour you describe.
>
> hth
> --
> mattia
> :wq
>
