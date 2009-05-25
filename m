Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbZEYRBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbZEYRBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZEYRBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:01:44 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38288 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZEYRBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N5eQRUT3hzSBKiJ9VRhSlf36JZRAbbWWO9Jq/jcWQqZuNNk35PdPpjWPWcJosMWx6e
         +zAfCtDaKLIbaBT3E1jSVykeEgnK/j1vxLR/4SzbgpoTmQitI6r9PkoOFEZRalgIJCVZ
         8aDEak6azGXf2Xa4u6ent1QgOqpLy3tcBQDt0=
Date: Mon, 25 May 2009 19:01:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090525170138.GA7862@nowhere>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <20090522115108.GA10992@elte.hu> <7BEB795002534E81BFA42E0464AEFD72@zhaoleiwin> <20090525164511.GC7121@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525164511.GC7121@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 06:45:13PM +0200, Frederic Weisbecker wrote:
> On Mon, May 25, 2009 at 04:59:26PM +0800, Zhaolei wrote:
> > * From: "Ingo Molnar" <mingo@elte.hu>
> > > 
> > > it still fails to build:
> > > 
> > > kernel/built-in.o: In function `ftrace_event_enable_disable':
> > > trace_events.c:(.text+0x4df08): undefined reference to `tracing_stop_cmdline_record'
> > > trace_events.c:(.text+0x4df1f): undefined reference to `tracing_start_cmdline_record'
> > > 
> > > config attached.
> > 
> > Hello, Ingo
> > 
> > Thanks for your report.
> > 
> > I found reason.
> > It is because CONFIG_TRACING is on(But CONFIG_FTRACE is off),
> > which compiles trace_events but leaves trace_sched_switch.
> > (It is different with problem that I fixed in v1->v2, but... sorry......)
> > 
> > I have fixed it, I'll send v3 after following test:
> > 1: CONFIG_TRACING on, CONFIG_FTRACE off
> > 2: CONFIG_ENABLE_EVENT_TRACING on, CONFIG_ENABLE_CONTEXT_SWITCH_TRACER off
> > 2: CONFIG_ENABLE_EVENT_TRACING on, CONFIG_ENABLE_CONTEXT_SWITCH_TRACER on
> > 
> > And RFC:
> > IMHO, trace_sched_switch should not have relationship with trace_events,
> > in other words, trace_events should run without trace_sched_switch linked.
> > 
> > Can we move codes for record cmdline out of trace_sched_switch.c and put them
> > into new cmdline_record.c?
> > Then, trace_functions.c and trace_events.c will only need cmdline_record.c
> 
> 
> The problem is that the cmdline recording is very tight to the sched
> switch tracer. tracing_start_cmdline_record() registers the sched switch
> tracer tracepoints and use them to avoid any loss of pid to cmdline
> mapping.
> 
> BTW, I have a doubt about this system.
> Isn't tracing_record_cmdline() sufficient for that?
> 
> We only need to record the cmdline of the traced task, not all
> of them.
> 
> No?
> 


Ah I understand now.

tracing_record_cmdline() is useful for tracers that raise few traces.
It only record the cmdlines it needs and that's it.

Instead the tracing_start/stop_cmdline pair is useful when we have a lot of
traces. Then we won't call tracing_record_cmdline() dozen of times in a
single task quantum but only each time it is scheduled.

Ok.

