Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZCWUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZCWUjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZCWUji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:39:38 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:53723 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZCWUjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:39:37 -0400
Message-id: <49C7F368.5040304@acm.org>
Date: Mon, 23 Mar 2009 15:39:04 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org>
 <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org>
 <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org>
 <49C78BE0.9090107@fujitsu-siemens.com>
In-reply-to: <49C78BE0.9090107@fujitsu-siemens.com>
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done some experimenting with your patch and some more thinking.  
(BTW, setting the permissions of kipmid_max_busy to 0644 as Greg 
suggested makes changing the value for testing a lot easier :).

Results are not so good with the system I was working with.  I have a 
tool that measures latency of individual messages, averaging over a 
number of messages.  It's part of the openipmi library, if you want to 
grab it.

For a message that requires almost no CPU from the management controller 
(a Get MC ID command), it takes around 5ms per message round-trip and 
uses about 10% of a CPU.  Setting the the max busy to 500 causes it to 
take about 23ms per message round trip and the CPU usage is not measurable.

Fetching SDRs (sensor data repository items), which will require more 
work on the management controller, is a bit different.  Each message 
takes 22ms with max_busy disabled using about 50% of the CPU.  Setting 
it to 500 changes the value to 44ms per message, no measurable CPU.  
Still not great, but not 5 times worse, either.  (The reason you are 
seeing 100% CPU and I'm not is because ipmitool issues more than one 
fetch to the driver at a time so the next command is ready to go as soon 
as the driver finishes one, so the driver will not do a 1-tick sleep 
between messages).

I'm guessing that the difference is that there is a long delay between 
receiving the command and issuing the result in the SDR fetch command.  
With your patch, this puts the driver to sleep for a tick when this 
happens.  The individual byte transfers are short, so the tick-long 
sleep doesn't happen in that case.

I'm also pretty sure I know what is going on in general.  You are using 
ipmitool to fetch sensors with a short poll time and your management 
controller does not implement a useful feature.

The reason that some systems doing this use a lot of CPU and other 
systems do not has do with the management controller design.  Some 
management controllers implement a UUID and a timestamp on the SDR data. 
ipmitool will locally cache the data and if the UUID and timestamp are 
the same it will not fetch the SDRs.  Just fetching the sensor values 
will be very efficient, much like the Get MC ID command.   If this is 
not implemented in the management controller, ipmitool will fetch all 
the SDRs every time you run it, which is terribly inefficient.  I'm 
guessing that's your situation.

I'm ok with the patch with the feature disabled by default.  I'd prefer 
for it to be disabled by default because I prefer to reward vendors that 
make our lives better and punish vendors that make our lives worse :).  
You should run it through checkpatch; there were one or two coding style 
violations.

I also have a few suggestions for solving this problem outside of this 
patch:

   1. Get your vendor to implement UUIDs and timestamps.  This will make
      things run more than an order of magnitude faster and more
      efficient.  Even better than interrupts.
   2. If that's not possible, don't use ipmitool.  Instead, write a
      program with the openipmi library that stays up all the time (so
      the SDR fetch is only done once at startup) and dumps the sensors
      periodically.
   3. If that's not feasible, poll less often and use events to catch
      critical changes.  Of course, this being IPMI, some vendors don't
      properly implement events on their sensors, so that may not work.

-corey


Martin Wilck wrote:
> Hi Corey, hi Greg, hi all,
>
> first of all I need to apologize, because _the first patch I sent was 
> broken_. The attached patch should work better.
>
> I did some benchmarking with this patch. In short:
>
> 1. The kipmid_max_busy parameter is a tunable that behaves reasonably. 
> 2. Low values of this parameter use up almost as little CPU as the 
> "force_kipmid=0" case, but perform better.
> 3. It is important to distinguish cases with and without CPU load.
> 4. To offer this tunable to make a balance between max. CPU load of 
> kipmid and performance appears to be worthwhile for many users.
>
> Now the details ... The following tables are in CSV format. The 
> benchmark used was a script using ipmitool to read all SDRs and all 
> SEL events from the BMC 10x in a loop. This takes 22s with the default 
> driver (using nearly 100% CPU), and almost 30x longer without kipmid 
> (force_kipmid=off). The "busy cycles" in the table were calculated 
> from oprofile CPU_CLK_UNHALTED counts; the "kipmid CPU%" are output 
> from "ps -eo pcpu". The tested kernel was an Enterprise Linux kernel 
> with HZ=1000.
>
> "Results without load"
>         "elapsed(s)"    "elapsed (rel.)"        "kipmid CPU% (ps)" 
>  "CPU busy cycles (%)"
> "default       "        22      1       32      103.15
> "force_kipmid=0"        621     28.23   0       12.7
> "kipmid_max_busy=5000"  21      0.95    34      100.16
> "kipmid_max_busy=2000"  22      1       34      94.04
> "kipmid_max_busy=1000"  27      1.23    25      26.89
> "kipmid_max_busy=500"   24      1.09    0       69.44
> "kipmid_max_busy=200"   42      1.91    0       46.72
> "kipmid_max_busy=100"   68      3.09    0       17.87
> "kipmid_max_busy=50"    101     4.59    0       22.91
> "kipmid_max_busy=20"    163     7.41    0       19.98
> "kipmid_max_busy=10"    213     9.68    0       13.19
>
> As expected, kipmid_max_busy > 1000 has almost no effect (with 
> HZ=1000). kipmid_max_busy=500 saves 30% busy time losing only 10% 
> performance. With kipmid_max_busy=10, the performance result is 3x 
> better than just switching kipmid totally off, with almost the same 
> amount of CPU busy cycles. Note that the %CPU displayed by "ps", "top" 
> etc drops to 0 for kipmid_max_busy < HZ. This effect is an artefact 
> caused by the CPU time being measured only at timer interrupts. But it 
> will also make user complains about kipmid drop to 0 - think about it ;-)
>
> I took another run with a system under 100% CPU load by other 
> processes. Now there is hardly any performance difference any more. As 
> expected,
> the kipmid runs are all only slightly faster than the interrupt-driven 
> run which isn't affected by the CPU load. In this case, recording the 
> CPU load from kipmid makes no sense (it is ~0 anyway).
>
>         "elapsed(s)"    "elapsed (rel.)"        "kipmid CPU% (ps)"
> "Results with 100% CPU load"
> "default       "        500     22.73
> "force_kipmid=0"        620     28.18
> "kipmid_max_busy=1000"  460     20.91
> "kipmid_max_busy=500"   500     22.73
> "kipmid_max_busy=200"   530     24.09
> "kipmid_max_busy=100"   570     25.91
>
>
> As I said initially, these are results taken on a single system. On 
> this system the KCS response times (from start to end of the 
> SI_SM_CALL_WITH_DELAY loop) are between 200 and 2000 us:
>
> us    %wait finished until
> 200    0%
> 400    21%
> 600    39%
> 800    44%
> 1000    55%
> 1200    89%
> 1400    94%
> 1600    97%
>
> This may well be different on other systems, depending on the BMC, 
> number of sensors, etc. Therefore I think this should remain a 
> tunable, because finding an optimal value for arbitrary systems will 
> be hard. Of course, the impi driver could implement some sort of 
> self-tuning logic, but that would be overengineered to my taste. 
> kipmid_max_busy would give HW vendors a chance to determine an optimal 
> value for a given system and give a respective recommendation to users.
>
> Best regards
> Martin
>

