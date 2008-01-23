Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYAWQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYAWQgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYAWQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:36:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:51011 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYAWQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:36:26 -0500
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
X-Auth-Info: AL8qzvYyXaX8BF+OqhX4T4D1m1TwwvRuDSxG7pudQW8=
Message-ID: <47976D06.1010900@grandegger.com>
Date: Wed, 23 Jan 2008 17:36:22 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Wolfgang Grandegger <wg@grandegger.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080123145340.GE6200@pengutronix.de>
In-Reply-To: <20080123145340.GE6200@pengutronix.de>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fu,

Luotao Fu wrote:
> Hi folks,
> 
> On Thu, Jan 17, 2008 at 11:13:26AM +0100, Wolfgang Grandegger wrote:
>> It builds and runs fine on my Icecube-MPC5200 board, now also with the
>> latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
>> reports latencies up to 400 us and therefore I tried to trigger and save
>> a high latency trace using:
>>
>>   # ./cyclictest -n -p80 -i1000 -b400
>>   1.21 0.33 0.11 4/42 1048
>>
>>   T: 0 (  914) P:80 I:1000 C:  38726 Min:     61 Act:  107 Avg:  106
>> Max:     377
>>   [   91.042169] (      cyclictest-914  |#0): new 39733427 us user-latency.
>>   bash-3.00# cat /proc/latency_trace > trace.log
>>
> 
> I was doing some tests on my mpc5200b Board to reproduce the high latency as
> measured by wolfgang.
> 
> I ran some tests with 
> while [ 1 ]; do ls /bin;done
> as non-rt workload, as in Wolfgangs Scenario.

I also did some more measurements and made, by chance, interesting
observations. I will summarize in more detail later on. Here are some
preliminary results. My high latencies of up to 570us (without latency
tracer) seem to be caused mainly by the following setting:

  CONFIG_RCU_TRACE=m

which is the default if CONFIG_MODULES=y. With CONFIG_RCU_TRACE=y
latencies go down significantly. I furthermore realized some bad impact
of CONFIG_NO_HZ and CONFIG_PPC_BESTCOMM_GEN_BD. With the following
settings the latencies did not yet exceed 140 us.

  CONFIG_PREEMPT_RCU_BOOST=y
  CONFIG_RCU_TRACE=y
  # CONFIG_PPC_BESTCOMM_GEN_BD is not set
  # CONFIG_NO_HZ is not set

With CONFIG_NO_HZ=y or CONFIG_PPC_BESTCOMM_GEN_BD=y the latency
increases by approx. 100..150us, each.

> Now I also got some strange values. My latency lies at round about 100 and the
> max. latency keep pending normally at about 150us-200us. However the max. value
> will occasionally break out to very high values. I got a max. about 850us after
> some rounds of measurement, which is definitively too high for the processor. I
> made some traces and attached the last "interesting" path to this mail.
> trace_600_1.log and trace_600_2.log are both taken with -b600. For comparation I
> also added a "normal" trace taken with -b150. In the traces with abnormal long
> latency there're a big "hole" between the last call, which is
> clockevents_program_event() in both long traces and the actual schedule()
> call. The holes are both about 600 us long, which is the main part of the
> latency actually.
> 
> Two important things I also noted during my tests: 
> 1. I got the unusual latencies on a system booted with nfsrootfs. I ran the same
> test scenario on system booted from flash and got no extraordinory results.
> After serveral hours test my max. latency lies at round about 200us.  
> 2. Even on a nfsrootfs system I could not get the high latencies if I run
> hackbench as non-rt workload.
> 
> Hence I suppose the unusual results are caused by network/Filesystemaccess.
> However I have no idea what could be the reason for the "hole"s in the trace.
> Looks almost like the cpu is doing nothing. As I don't have a trace on other
> architecture at hand at the moment. I can't say for 100 procent if the tracer is
> "missing" anything.
> 
> Any comments, ideas?

Could you check your .config and try the __good__ settings mentioned
above? Can you back my observations? Don't ask me why. Maybe somebody
else could shed some light on this.

Wolfgang,

