Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbYA3LWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbYA3LWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYA3LWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:22:07 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46666 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYA3LWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:22:05 -0500
X-Auth-Info: RdGgpKZmUG8+TPqsFx0nVYzHzIj+H07caJGNLtCTMIc=
X-Auth-Info: RdGgpKZmUG8+TPqsFx0nVYzHzIj+H07caJGNLtCTMIc=
X-Auth-Info: RdGgpKZmUG8+TPqsFx0nVYzHzIj+H07caJGNLtCTMIc=
X-Auth-Info: RdGgpKZmUG8+TPqsFx0nVYzHzIj+H07caJGNLtCTMIc=
X-Auth-Info: ABfcdLQX8ABRidkdMafIFnbqcI2oGu4/d9DRzO4BguM=
X-Auth-Info: ABfcdLQX8ABRidkdMafIFnbqcI2oGu4/d9DRzO4BguM=
X-Auth-Info: ABfcdLQX8ABRidkdMafIFnbqcI2oGu4/d9DRzO4BguM=
Message-ID: <47A05DD9.6060008@grandegger.com>
Date: Wed, 30 Jan 2008 12:22:01 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
References: <20080123145340.GE6200@pengutronix.de> <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com>
In-Reply-To: <20080130105715.GE24890@linux.vnet.ibm.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Wed, Jan 30, 2008 at 11:45:01AM +0100, Wolfgang Grandegger wrote:
>> Paul E. McKenney wrote:
>>> On Wed, Jan 30, 2008 at 09:18:49AM +0100, Wolfgang Grandegger wrote:
>>>> Paul E. McKenney wrote:
>>>>> On Tue, Jan 29, 2008 at 02:38:04PM +0100, Wolfgang Grandegger wrote:
>>>>>> Luotao Fu wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> Wolfgang Grandegger wrote:
>>>>>>> ..........
>>>>>>>> Do you still get high latencies with:
>>>>>>>>
>>>>>>>>   CONFIG_PREEMPT_RCU_BOOST=y
>>>>>>>>   CONFIG_RCU_TRACE=y
>>>>>>>>   CONFIG_NO_HZ is not set
>>>>>>>>
>>>>>>>> With this setting I have not yet realized latencies > 150us. Could you
>>>>>>>> please give it a try? If I change one of the parameters above, latency
>>>>>>>> increases in short time.
>>>>>>> I played through some combination of the RCU options and can back your
>>>>>>> observation this time: With the rcu Tracer or the priority boost turned
>>>>>>> off I also could measure reliably extraordinory high latencies. If they
>>>>>>> are both turned on, no high latencies could be measured. Turning on the
>>>>>>> dynamic ticker however doesn't seem to cause high latencies during my
>>>>>>> test runs. Seemed like an rcu issue here.
>>>>>> I'm just making a long test run on my TQM5200 module with my good
>>>>>> settings. After more than 4.5 hours under load, cyclictest shows a
>>>>>> maximum latency of 177 us. I'm going to re-check the effect of CONFIG_NO_HZ.
>>>>>>
>>>>>>> Further such results only appear if the target board is booted with
>>>>>>> nfsrootfs. (As I already have mentioned several times before), which
>>>>>>> leads my suspection to rcu usage in nfs implementation. In this case
>>>>>>> this problem might even be platformindependent. I'd have to do some
>>>>>>> tests on one of our arm boards later to test this. Since there're no
>>>>>>> reports like this for other architecture as powerpc till now, I doubt
>>>>>>> quite if this is verifiable.
>>>>>> It's also my suspicion that the high latencies are related to the RCU
>>>>>> usage in the network layer, where it's heavily used. What is really
>>>>>> wired is that switching off CONFIG_RCU_TRACE has a negative impact on
>>>>>> the latency. As I see it, it just adds some trace points, but I might
>>>>>> have missed something.
>>>>> I would expect that CONFIG_RCU_TRACE=n (as in "no" rather than "module")
>>>>> would have low latencies rather than high latencies.  So I am quite
>>>>> surprised by your result.  I will dig into this more.
>>>> Thanks a lot. To be clear. I need "CONFIG_PREEMPT_RCU_BOOST=y" *and*
>>>> "CONFIG_RCU_TRACE=y" to achieve reasonable latencies below 180us. With
>>>> CONFIG_PREEMPT_RCU_BOOST or CONFIG_RCU_TRACE not set or
>>>> CONFIG_RCU_TRACE=m is rmeasure latencies up to 600us within a minute or so.
>>> OK, thank you for the confirmation.
>>>
>>> The large latencies were from cyclictest, correct?  Did other tests
>>> also show these latencies?  In either case, could you please send the
>>> exact command line you used to run the test?
>> Yes, I used "$ cyclictest -n -t1 -p80 -i1000" to measure the latency. So
>> far, I have not done other tests. Any recommendation?
>> As no-rt load I used "while ls; do ls /bin; done" in one telnet window
>> and "while ./hackbench 10; do ./calibrator 400 32M cali; sleep 30; done"
>> in another. But already "while ls; do ls /bin; done" is enough to
>> trigger the high latencies quickly. Note also, that I work on a root
>> files-ystem mounted via NFS resulting in a lot of network traffic and
>> utilization.
> 
> I have to ask...
> 
> Did you see large latencies when -not- running on NFS?

I have not made test without NFS, but Fu has and he said:

"Further such results only appear if the target board is booted with
nfsrootfs."

Wolfgang.

