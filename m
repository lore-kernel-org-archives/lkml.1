Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYIWRHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYIWRHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYIWRH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:07:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYIWRHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:07:25 -0400
Message-ID: <48D921B3.2060809@redhat.com>
Date: Tue, 23 Sep 2008 13:04:51 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com> <48D901FE.5060604@redhat.com> <20080923150410.GA28341@Krystal> <48D90B84.4030905@redhat.com> <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 23 Sep 2008, Masami Hiramatsu wrote:
>> 2.00GHz is the maximum(model) frequency. And 'cpu MHz' means
>> current frequency. (yep, now I'm using cpufreq)
>> Anyway, when I measured TSC drift, I killed cpuspeed service and
>> fixed freq to 2000. ;-)
> 
> Ahh. I have an idea..
> 
> Maybe that thing does thermal throttling? 
> 
> Fixing the frequency at the highest setting is actually one of the worst 
> things you can do, because if the device is thermally limited, it will 
> still do the whole throttling thing, but now it won't do it by changing 
> the frequency any more, it will do it by essentially forxing the external 
> frequency down.
> 
> And that is going to be *very* inefficient. You really really don't want 
> that. Your performance will actually be _worse_ than if the CPU went to a 
> lower frequency. And it might explain the unreliable TSC too, because I 
> suspect constant TSC is really constant only wrt the bus clock to the CPU.
> 
> The termal throttling thing is a "protect the CPU from overheating" last 
> ditch effort, and because it doesn't lower voltage, it isn't actually at 
> all as efficient at saving power (and thus cooling the CPU) as a real 
> frequency change event would be.
> 
> And fixing the frequency to the highest frequency in a tight laptop 
> enclosure is the best way to force that behavior (in contrast - in a 
> desktop system with sufficient cooling, it's usually not a problem at all 
> to just say "run at highest frequency").
> 
> And btw, that also explains why you had so *big* changes in frequency: the 
> throttling I think happens with a 1/8 duty cycle thing, iirc.
> 
> It's supposed to be very rare with Core 2. Thermal throttling was quite 
> common with the P4 one, and was the main overheating protection initially. 
> These days, you should only see it for really badly designed devices that 
> simply don't have enough thermal cooling, but if the design calls for 
> mostly running at low frequency because it's some thing-and-light notebook 
> with insufficient cooling (or some thick-and-heavy thing that is just 
> total crap), and you force it to always run at full speed, I can imagine 
> it kicking in to protect the CPU.
> 
> It's obviously also going to be much easier to see if the ambient 
> temperature is high. If you want to get best peformance, take one of those 
> compressed-air spray-cans, and spray on the laptop with the can held 
> upside down (the can will generally tell you _not_ to do that, because 
> then you'll get the liquid itself rather than gas, but that's what you 
> want for cooling).
> 
> So if you can test this, try it with 
>  (a) cpufreq at a fixed _low_ value (to not cause overheating)
>  (b) with the spray-can cooling the thing and cpufreq at a fixed high 
>      value
> and see if the TSC is constant then.

Hi Linus,

Thank you for your advice. I tested it again according your advice,
I did:
- service cpuspeed stop
- echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
  and checked /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq is
  1000000.
- echo 1 >  /proc/acpi/thermal_zone/THM/polling_frequency
- cooling with spray-can :)
- cat /proc/acpi/thermal_zone/THM/temperature
  temperature:             39 C

and ran the test.
---
p0: c:1107576,	 ns:990280	 ratio:111
p0: c:1805640,	 ns:1008787	 ratio:178
p0: c:1998324,	 ns:1000127	 ratio:199
p0: c:946380,	 ns:990280	 ratio:95
p0: c:871728,	 ns:1000267	 ratio:87
p0: c:1807380,	 ns:1007949	 ratio:179
p0: c:1784808,	 ns:1000127	 ratio:178
p0: c:1768488,	 ns:991676	 ratio:178
p0: c:1802292,	 ns:1008299	 ratio:178
p0: c:1787088,	 ns:1000406	 ratio:178
p0: c:1999176,	 ns:1000896	 ratio:199
p0: c:881364,	 ns:991956	 ratio:88
p0: c:1802712,	 ns:1008019	 ratio:178
p0: c:1787088,	 ns:998590	 ratio:178
---
this seems not so stable yet. :-(

After test I checked temperature again.
# cat /proc/acpi/thermal_zone/THM/temperature
temperature:             39 C

Hmm, 39 C is not so high. I wouldn't be surprised even if this
is an individual product bug. Anyway, currently, Linux itself
works well on this laptop with hpet.:-)

Thank you,


> 
> 			Linus

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

