Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYITD3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYITD3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 23:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYITD3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 23:29:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:15138 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYITD3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 23:29:41 -0400
Message-ID: <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
Date: Fri, 19 Sep 2008 20:29:39 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
	 <20080919142801.GA5816@senthil-lnx.users.atheros.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 6:13 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Sep 19, 2008 at 5:01 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> I'll pull wireless-testing and run that kernel for another 8 hours.
>> What's the URL for the repo? Surely you don't mean the
>> wireless-testing on git.kernel.org that hasn't been touched for almost
>> a week?
>
> Yes, that's the guy. This week was the Kernel Summit and the Linux
> Plumbers Conference too so there is understandably some lag in pulls
> as developers are getting drunk.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>
>> I kind of wish there was a better debugging facility in ath9k.
>
> Patches are welcomed ;)
>
> Also, we have a few interrupt levels you can use. In this case we are
> debugging interrupts.
>
>> With
>> ATH_DBG_INTERRUPTS, I see several hundred messages per second, which
>> fills log files up like crazy (I switched to ftrace_printk as Ingo
>> suggested, which has alleviated this somewhat). Is there a way to make
>> it less verbose (perhaps so that it prints data at a rate of no more
>> than 2 or 3 messages per second)? Or maybe the rate at which it prints
>> this stuff is indicative something's wrong?
>
> No, interrupts do happen quite often so that is what you get, perhaps
> we can enhance this by not printing on some interrupts but the point
> is to debug interrupts after all. To help us debug in userspace in a
> nicer way we can use sadc and sar. So you can try this:
>
> On a window leave this running:
>
> /usr/lib/sysstat/sadc -I 1 irqlog.sar
>
> And when you are seeing your latency issues, run this:
>
> sar -I 17 -f irqlog.sar | less

Thanks for informing me about this useful utility. I wasn't aware of
its existence.

However, this profiler seems broken. When I check individual or 'ALL'
statistics, they're all 0.00 IRQs/sec, but SUM shows the actual number
of total IRQs per second. I suspect it's only broken because of some
kernel config option not being enabled.

Anyway, there definitely is an interrupt storm here. Let me demonstrate...

This is when the system is operating normally:
[...]
19:14:39          sum   1271.00
19:14:40          sum   1286.14
19:14:41          sum   1373.00
19:14:42          sum   1691.00
19:14:43          sum   1380.00
19:14:44          sum    902.00
19:14:45          sum    772.00
19:14:46          sum   1155.00
19:14:47          sum    804.00
19:14:48          sum    809.00
19:14:49          sum    965.00
19:14:50          sum   1077.23
Average:          sum    615.69


Here's while the latency issue is occurring, which can now safely be
called an interrupt storm:
[...]
20:21:07          sum  18864.08
20:21:08          sum  21152.73
20:21:09          sum  19221.35
20:21:10          sum  20786.14
20:21:11          sum  19891.92
20:21:12          sum  19816.16
20:21:13          sum  19430.69
20:21:14          sum  20432.00
20:21:15          sum  19657.84
20:21:16          sum  19386.00
20:21:17          sum  19386.79
20:21:18          sum  20152.94
20:21:19          sum  19077.88
20:21:20          sum  19852.00
Average:          sum  19958.91


And here's the change as I unload and reload ath9k:

[...]
20:21:38          sum  20138.83
20:21:40          sum  21576.09
20:21:41          sum  17678.38
20:21:42          sum  19834.34
20:21:43          sum  19845.10
20:21:44          sum  19470.00
20:21:45          sum   9273.00  <--- ath9k unloaded/reloaded
20:21:46          sum    187.00
20:21:47          sum   1066.00
20:21:48          sum    610.00
20:21:49          sum    106.93
20:21:50          sum    670.00
20:21:51          sum    742.00
20:21:52          sum    781.00
Average:          sum  19562.56

- Steven
