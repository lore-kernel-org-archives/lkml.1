Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZH0QDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZH0QDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZH0QDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:03:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZH0QDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:03:42 -0400
Date: Thu, 27 Aug 2009 12:03:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090827155939.GA11070@Krystal>
Message-ID: <alpine.DEB.2.00.0908271201010.11745@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <4A95E737.5080805@cn.fujitsu.com>
 <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com> <20090827143902.GA3552@Krystal> <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com> <20090827151118.GD3552@Krystal> <alpine.DEB.2.00.0908271125030.11745@gandalf.stny.rr.com>
 <20090827155939.GA11070@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:
> > 
> > For this race to occur, the probe (code that hooks to the tracepoint) must 
> > be in module that does not contain the tracepoint. We don't even need more 
> > than one module, this could occur even with a core tracepoint. If a module 
> > registers it, if it unregisters before unloading, the tracepoint may be 
> > hit before the unregister and executing while the module is unloading.
> > 
> > I don't think we need to worry about this with the case of TRACE_EVENT and 
> > ftrace.h. The reason is that the trace point and probes are always in the 
> > same location. The MACROS set up the probe code with the modules. Thus, to 
> > remove the module, you must also remove the tracepoint itself along with 
> > the probe. If you can be executing in the probe, then you must have hit 
> > the trace point. If you hit the trace point, then you are executing code 
> > inside the module you are removing, which is a bug in the module code 
> > itself.
> > 
> > Using the ftrace.h MACROS limits the use of tracepoints and this race 
> > does not exist. I feel we are safe not needing to have the 
> > tracepoint_synchronize_unregister within the ftrace.h code.
> > 
> 
> Looks right. If you can guarantee that the probe is only called from
> tracepoints located within the same module as the probe, you should be
> safe without tracepoint_synchronize_unregister. It's worth adding a
> comment in ftrace.h explaining that though.

Yeah, I tried to trick the code to see if I can get a probe in another 
module than the trace point, and I get nothing but linking errors. I'm 
sure if I work hard enough, I may trick it to do so, but if anyone does 
that, I'll slap a big fat NAK on it ;-)

OK, I modify my fix to add a comment to this effect.

Thanks,

-- Steve
