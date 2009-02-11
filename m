Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZBKCPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZBKCPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZBKCPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:15:38 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:54554 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZBKCPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=pdbs85qTXxcumcGgwfbufdmhIOfMDebZH1bzw3yehpBdmj8N6MnFobjrz4X0Uff43c
         WK0NmrRpD1Fjv66WWq+2xPXWsHQBW0XlskrFM1TywZkVYxdcQLRYnBq2qPY4QO18psHf
         njgWS4DOSmjXKwjpecP1WupGEH/CrRxgiu4sM=
MIME-Version: 1.0
In-Reply-To: <cc0fa41f0902101810m77d7054ar7df7b3804cc61e66@mail.gmail.com>
References: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com>
	 <20090210045803.GA31755@kamineko.org>
	 <cc0fa41f0902092215i44823962t39033f6b987f273f@mail.gmail.com>
	 <20090210110802.GB31755@kamineko.org>
	 <cc0fa41f0902101810m77d7054ar7df7b3804cc61e66@mail.gmail.com>
Date: Wed, 11 Feb 2009 00:15:35 -0200
Message-ID: <cc0fa41f0902101815s149b3b06mb3fbb72363b49765@mail.gmail.com>
Subject: Re: ACPI regression in 2.6.29 - cpufreq_performance doesn't work
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:08 AM, Mattia Dongili <malattia@linux.it> wrote:
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> On Tue, Feb 10, 2009 at 04:15:00AM -0200, Guilherme Malschitzky Schroeder wrote:
>> yeah mattia, you were right about ondemand module was being used on
>> cpu1, so i couldn't remove it.
>> with this commited patch, both cpu's can now have different speeds.
>
> afair this has always been the case. the only difference the patch
> introduces is telling the BIOS where the coordination is actually done.
>> i was just comparing cat /proc/cpuinfo and didn't notice that cpu0 was
>> at 2268MHz.
>> cpufrequtils will need an update do deal with this change.
>
> why? what's wrong with cpufrequtils?

The thing i said about changing cpufrequtils it's because cpufreq-set
just set cpu0 governor.
With 2.6.29, it'll need to change cpu1 too from what i have understood right?

2.6.28:

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
ondemand
ondemand
# cpufreq-set -g performance
# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
performance
performance

2.6.29:

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
performance
performance
# cpufreq-set -g ondemand
# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
ondemand
performance

>
>> btw, this looks strange:
>>
>> dub:~# echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
>> dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
>> performance
>> ondemand
>>
>> dub:~# cat /proc/cpuinfo | grep MH
>> cpu MHz         : 2268.000
>> cpu MHz         : 800.000
>>
>> dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/cpuinfo_cur_freq
>> 2267000
>> 2267000
>
> well the former displays what the kernel thinks the frequency is, the
> latter reads from hw registers and displays the real frequency.
> It's consistent. The kernel doesn't (and can't) know about what the hw
> is doing behind its back and present the user consistent information.

Still, i have a doubt with the frequencie of cpu1:

# uname -a
Linux dub 2.6.28.4 #1 SMP Tue Feb 10 16:35:16 BRST 2009 x86_64 GNU/Linux

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
ondemand
ondemand

# echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
performance
performance

# cat /proc/cpuinfo | grep MH
cpu MHz         : 2268.000
cpu MHz         : 2268.000

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/cpuinfo_cur_freq
2267000
2267000

# echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
ondemand
ondemand

# uname -a
Linux dub 2.6.29-rc4 #28 SMP Tue Feb 10 02:22:06 BRST 2009 x86_64 GNU/Linux

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
ondemand
ondemand

# echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_governor
performance
ondemand

# cat /proc/cpuinfo | grep MH
cpu MHz         : 2268.000
cpu MHz         : 800.000

# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/cpuinfo_cur_freq
2267000
2268000

So, cpu1 is working at 2268MHz or 800? It's using the ondemand
governor or performance governor?

>
>> dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_min_freq
>> 800000
>> 800000
>>
>> dub:~# cat /sys/devices/system/cpu/cpu{0,1}/cpufreq/scaling_available_frequencies
>> 2268000 2267000 1600000 800000
>> 2268000 2267000 1600000 800000
>>
>> doesn't cpu0/cpufreq/scaling_min_freq needs to be 2268000 and
>> scaling_frequencies
>> just have 2268000 because it's set to "performance"?
>>
>> am i forgetting anything else to set?
>
> no, if I understand your question correctly you're just misinterpreting
> what those files are for, take a look at Documentation/cpu-freq
>
>> thanks,
>>
>>
>> On Tue, Feb 10, 2009 at 2:58 AM, Mattia Dongili <malattia@linux.it> wrote:
>> > On Tue, Feb 10, 2009 at 01:53:13AM -0200, Guilherme Malschitzky Schroeder wrote:
>> >> Hi,
>> >>
>> >> If i set performance for scaling_governor using 2.6.29-rc4-git2,
>> >> ondemand stills control my CPU.
>> >> I get just 800MHz instead of 2268MHz.
>> >>
>> >> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
>> >> 800000
>> >> dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
>> >> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
>> >> performance
>> >> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
>> >> 2267000
>> >>
>> >> But, /proc/cpuinfo still shows 800MHz:
>> >>
>> >> model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
>> >> stepping        : 6
>> >> cpu MHz         : 800.000
>> >>
>> >> And i cannot remove the ondemand module, that is not used anymore:
>> >>
>> >> dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
>> >> ERROR: Module cpufreq_ondemand is in use
>> >
>> > yes, I guess it is used by cpu1, you should repeat the above commands
>> > for /sys/devices/system/cpu/cpu1/cpufreq too.
>> >
>> > ...
>> >> I've git bisect from 2.6.28.4 (which was working) to 2.6.29-rc4-git2
>> >> and i get into this:
>> >>
>> >> alemao@dub:~/linux-2.6$ git bisect good
>> >> d96f94c604453f87fe24154b87e1e9a3a72511f8 is first bad commit
>> >> commit d96f94c604453f87fe24154b87e1e9a3a72511f8
>> >> Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
>> >> Date:   Mon Feb 2 11:57:18 2009 -0800
>> >>
>> >>     ACPI: Enable bit 11 in _PDC to advertise hw coord
>> >>
>> >>     Bit 11 in intel PDC definitions is meant for OS capability to handle
>> >>     hardware coordination of P-states. In Linux we have always supported
>> >>     hwardware coordination of P-states. Just let the BIOSes know that we
>> >>     support it, by setting this bit.
>> >>
>> >>     Some BIOSes use this bit to choose between hardware or software coordination
>> >>     and without this change below, BIOSes switch to software coordination, which
>> >>     is not very optimal in terms of power consumption and extra
>> >> wakeups from idle.
>> >>
>> >>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> >>     Signed-off-by: Len Brown <len.brown@intel.com>
>> >
>> > the "coordination of P-states" is required when you have an SMP system
>> > that cannot scale cpu voltage independently on each cpu, so the best
>> > voltage/frequency have to be selected mediating between all the applied
>> > policies.
>> > The commit you found above just makes use hw coordination instead of sw
>> > and the message explains why.
>> >
>> > If you make sure you change *all* of the cpu policies you won't see the
>> > behaviour you describe.
>> >
>> > hth
>> > --
>> > mattia
>> > :wq
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> mattia
> :wq!
>
