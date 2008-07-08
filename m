Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYGHTmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYGHTmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYGHTmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:42:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51262 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYGHTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:42:44 -0400
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
X-Auth-Info: 8uROT6kskmrUGyIiyNQmNV3aai+iakU2Yf8kn7CQJOg=
Message-ID: <4873C363.3070306@grandegger.com>
Date: Tue, 08 Jul 2008 21:43:31 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luotao Fu <l.fu@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU	issue?
References: <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com> <48709348.6000101@grandegger.com> <20080708150826.GA30586@pengutronix.de>
In-Reply-To: <20080708150826.GA30586@pengutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fun,

Luotao Fu wrote:
> Hi,
> 
> I found some time and played with my mpc5200B Board again on this issue
> (2.6.25.8-rt7, same test environment)
> 
> On Sun, Jul 06, 2008 at 11:41:28AM +0200, Wolfgang Grandegger wrote:
> ....
>> Yep, in 2.6.25.8-rt7 trace_mark() is not used any more, maybe for that  
>> reason. Nevertheless, this "bug" kept the latency on my MPC5200 box low.
>> I will try with the old tracer to understand what the real cause of the  
>> high latencies is (with CONFIG_RCU_TRACE disabled).
>>
> As you said, in 2.6.25.8-rt7 there're rcu_trace_boost_unboost_called() and
> rcu_trace_boost_unboosted() are used instead of trace_mark. I still haven't had
> time to take a closer look waht these routines exactly do. Seemed however to me,
> that they possibly do the same thing. I played a little bit around with
> the RCU_TRACE and RCU_BOOST Option. Also I tried to comment out the
> rcu_trace_boost_unboost_called() and rcu_trace_boost_unboosted() calls. My Tests
> last appr. 30 Minutes with non-rt Payload "while [ 1 ]; do ls /;done". None of
> my test showed extraordinary results. My worstcase values stay at about 220 us
> with all my test combinations. I will attache a config with RCU_BOOST and
> RCU_TRACE turned off to this mail, which provide a worst case value at 223 us
> after about 40 Minutes test run on my board.

I think I understood why CONFIG_RCU_TRACEin 2.6.24-rt helped to keep 
latencies low. See:

   ttp://marc.info/?l=linux-rt-users&m=121499677026236&w=4

But as Steven pointed out, the preempt_enable_noresched at that place 
might be illegal, anyway. In 2.6.25-rt, trace_mark() is no longer used 
and I do not see an improvement with CONFIG_RCU_TRAC any more. Latencies 
go up to 600us. I also tried with CONFIG_RCU_BOOST disabled, but it did 
not improve the latencies. Actually, I still measure significantly 
different latencies with 2.6.24.4-rt4, 2.6.24.7-rt14 and 2.6.25.8-rt7, 
which is quite frustrating. As you seem not be able to reproduce my high 
latencies, I wonder if there are some toolchain or glibc related issues.

Using ftrace to localized the latency spot would be the next step. But 
it's not yet available for PowerPC. Looking into that now.

> Are you using the FEC all a pci network card?

I use only the FEC. There is no PCI device.

Wolfgang.


