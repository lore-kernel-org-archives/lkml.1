Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbZFJJoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbZFJJoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbZFJJmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:42:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760013AbZFJJmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:42:04 -0400
Message-ID: <4A2F8006.506@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 17:42:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com> <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain> <4A25E575.5000601@cn.fujitsu.com> <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain> <4A275DDC.6020507@cn.fujitsu.com> <alpine.LFD.2.00.0906041017220.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906041017220.3419@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas:

Sorry for the delayed reply.

> Please stop this handwaving about potential use cases. I still have
> not seen a single technical argument which explains the benefit of
> those extra trace points. If we follow your "maybe its needed" logic
> then we have to add yet another dozen of tracepoints into the same
> functions to gather all possible states which might be there.
> 
> Tracing is important but it needs to be done unintrusive to the code
> and you have to apply common sense which information is really
> valuable and necessary. Gathering random crap just because it might be
> necessary at some point is useless.
> 

I see your point, and I agree with you on this.

> Get your gear together, sit down and think hard about which
> information a tracer or a probe needs to have to give us a useful
> insight into a particular object or function.
> 
> As long as there is no technical convincing argument that the gathered
> information is really useful I'm not going to apply any of those
> patches to the code I maintain.
> 

Those tracepoints are wanted and useful:

1) We can detect a timer's delay if jiffies info is added, like this:

	XXX: timer_start: timer=e0b374e0 func=test_timerfuc expires=4294941565
	XXX: timer_expire: timer=e0b374e0 func=test_timerfuc jiffies=4294941567
 
   We expect the timer expires at 4294941565, actually the timer expires at
   4294941567, so it is delayed by 2 jiffies.

2) We can monitor the lifecycle and behaviors of a timer, for example, when
   monitoring dirty writeback timer, I found reading /proc/sys/vm/dirty_writeback_centisecs
   will reset the timer:

         pdflush-244   [000]  0.554131: timer_start: timer=c077ef20 func=wb_timer_fn expires=2757949
          <idle>-0     [000]  5.544769: timer_expire: timer=c077ef20 func=wb_timer_fn
          <idle>-0     [000]  5.544770: timer_cancel: timer=c077ef20 func=wb_timer_fn
         pdflush-244   [000]  5.544807: timer_start: timer=c077ef20 func=wb_timer_fn expires=2762949
             cat-2326  [000]  5.618852: timer_cancel: timer=c077ef20 func=wb_timer_fn
             cat-2326  [000]  6.618858: timer_start: timer=c077ef20 func=wb_timer_fn expires=2764025

3) We are developing "flight-record" using crash. It can read out the ring
   buffer from the dump file, and let us know what was happening before
   kernel panic, so we may find the cause of the panic. This requires
   well-defined tracepoints in different kernel subsystems, especially some
   core subsystems, timer is surely one of them.

I'll revise those patches according to your suggestions.

Thanks,
Xiao Guangrong

> Thanks,
> 
> 	tglx
> 
> 
