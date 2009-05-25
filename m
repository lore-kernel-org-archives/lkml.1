Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZEYI15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZEYI15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZEYI1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:27:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:34496 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEYI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bPdFza4YD9GuRvViyKHXIxwz7alcc5R4MbIFQWqoQorDVBq3uwSHdVezfb6cq3PT9N
         MRx2cFy3r6ytRP/i7gStuR5/GlOW2z0MV8NZKLGPvddoCklOCsbTbgvrCp9jbmi7IOVf
         RqkZHe3rgL8OdqWfvtn+eEfJKfyoGyI1rJ2nk=
Date: Mon, 25 May 2009 10:27:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090525082743.GA6215@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <4A1678F1.1060706@cn.fujitsu.com> <20090524204240.GB6471@nowhere> <8F90215D2B2846BDBCD0FACB72CD2B6C@zhaoleiwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8F90215D2B2846BDBCD0FACB72CD2B6C@zhaoleiwin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 11:54:27AM +0800, Zhaolei wrote:
> * From: "Frederic Weisbecker" <fweisbec@gmail.com>
> > Hi,
> > 
> > 
> > On Fri, May 22, 2009 at 06:05:37PM +0800, Zhaolei wrote:
> >> If we use trace_event alone(without function trace, .etc),
> >> it can't output enough task command information.
> >> 
> >> Before patch:
> >>  # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
> >>  # cat debugfs/tracing/trace
> >>  # tracer: nop
> >>  #
> >>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >>  #              | |       |          |         |
> >>             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
> >>             <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
> >>             <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
> >>             <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
> >>            <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
> >>             <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
> >>  ...
> >> 
> >> After patch:
> >>  # tracer: nop
> >>  #
> >>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >>  #              | |       |          |         |
> >>              bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
> >>              sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
> >>              bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
> >>              sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
> >>            <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
> >>          events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
> >>  ...
> >> 
> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > 
> > 
> > Thanks!
> > This is fine but I think it can be factorized.
> > 
> > You could call start_cmdline_record() from
> > 
> > ftrace_raw_reg_event_##call()
> > 
> > and the stop in
> > 
> > ftrace_raw_unreg_event_##call()
> > 
> > No?
> 
> Hello, Frederic
> 
> Thanks for your advice.
> 
> Actually, I considered to put start_cmdline_record() into ftrace_raw_reg_event_##call(),
> but finally I selected to put it into tracing_start_cmdline_record().
> 
> IMHO, we have following reason:
> 1: It can make source more readable.
>    Read function is more easy than read macro.
> 2: These two way have same performance.
> 3: Put start_cmdline_record() into ftrace_event_enable_disable() will reduce
>    binary file size than ftrace_raw_reg_event_##call().
> 
> So I think put start_cmdline_record() into ftrace_event_enable_disable() maybe better.
> 
> What is your opinion?
> 
> Thanks
> Zhaolei


Yeah, there are pros and cons. Putting it at the lower level will
increase image size but make easier the maintainance...

I don't know which one is better :)
I guess both are valuable.

Thanks.

