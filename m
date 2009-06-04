Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFDIpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFDIpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZFDIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:45:08 -0400
Received: from www.tglx.de ([62.245.132.106]:57863 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZFDIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:45:07 -0400
Date: Thu, 4 Jun 2009 10:44:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A275DDC.6020507@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0906041017220.3419@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com>
 <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain> <4A25E575.5000601@cn.fujitsu.com> <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain> <4A275DDC.6020507@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Xiao Guangrong wrote:
> > void debug_and_trace_timer_activate(....)
> > {
> > 	debug_timer_activate(...);
> > 	trace_timer_activate(...);
> > }
> > 
> > in the timer code:
> > 
> > -      debug_timer_activate(...);
> > +      debug_and_trace_timer_activate(...);
> > 
> > So this does not change the order of functions at all, but it avoids
> > sprinkling the real code with tons of extra crap.
> > 
> 
> See below code:
> 
> static inline int
> __mod_timer(......)
> {
> 	......
> 	......
>
 	
- 	debug_timer_activate(timer);
+	debug_and_trace_timer_activate(timer, expires);

  Does the trick nicely

> In addition, do you agree my humble opinion about not put __init_timer() and
> debug_timer_init() together? (can be found at:

No, I do not agree at all. I still see no value in those extra trace
points. As I showed you above you can hide all in extra arguments to a
combined debug_trace_xxx() function.

> http://marc.info/?l=linux-kernel&m=124399744614127&w=2)

>> But TRACE_EVENT not only be used in ftrace but also be used in
>> other probe module. Maybe detailed information of timer is
>> requisite in other probe funtion.  In this case, we must put
>> trace_timer_init() after __init_timer().

Please stop this handwaving about potential use cases. I still have
not seen a single technical argument which explains the benefit of
those extra trace points. If we follow your "maybe its needed" logic
then we have to add yet another dozen of tracepoints into the same
functions to gather all possible states which might be there.

Tracing is important but it needs to be done unintrusive to the code
and you have to apply common sense which information is really
valuable and necessary. Gathering random crap just because it might be
necessary at some point is useless.

Get your gear together, sit down and think hard about which
information a tracer or a probe needs to have to give us a useful
insight into a particular object or function.

As long as there is no technical convincing argument that the gathered
information is really useful I'm not going to apply any of those
patches to the code I maintain.

Thanks,

	tglx
