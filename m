Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbZGOBdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbZGOBdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZGOBdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:33:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbZGOBdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:33:31 -0400
Message-ID: <4A5D31E2.9030402@cn.fujitsu.com>
Date: Wed, 15 Jul 2009 09:33:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ftrace: add tracepoint for hrtimer
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6AE.5020204@cn.fujitsu.com> <alpine.LFD.2.00.0907062209190.19480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907062209190.19480@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
>
>   Here I'd like to see a callback_done entry as well, so we can check
>   for long lasting callbacks.
> 

I am trying to address your comment that move trace_timer_expires()
form hrtimer_interrupt()/hrtimer_run_queues() to __run_hrtimer() to
trace the execution time of hrtimer's callback, like below:
 
 __run_hrtimer()
 {
 	.....
   +	trace_hrtimer_expires();
 	restart = fn(timer);
   +	trace_hrtimer_callback_done();
 	......
 }

But I meet a problem here that I can't get the timestamps when hrtimer
expires in __run_hrtimer(), which is used to calculate the latency of
hrtimer. I think it's Ok to not move trace_hrtimer_expires(), that is:

 hrtimer_interrupt()
 {
 	 ......
   +	 trace_hrtimer_expires();
 	 __run_hrtimer(timer);
 	 ......
  }
 	 
  __run_hrtimer()
  {
 	......
	restart = fn(timer);
   +	trace_hrtimer_callback_done();
 	......
 }
 
But if more accurate execution time is a require, we'd better use the
tracepoints added by Anton Blanchard <anton@samba.org>. That is:

 hrtimer_interrupt()
 {
 	 ......
   +	 trace_hrtimer_expires();
 	 __run_hrtimer(timer);
 	 ......
 }
 
 __run_hrtimer()
 {
 	......
  + 	trace_hrtimer_callback_entry()
 	restart = fn(timer);
  +	trace_hrtimer_callback_exit();
 	......
 }


Thanks,
Xiao
