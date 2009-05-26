Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZEZQix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZEZQix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZEZQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:38:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbZEZQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:38:39 -0400
Date: Tue, 26 May 2009 12:38:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: create events only when configed
In-Reply-To: <4A167307.7020905@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905261227470.26705@gandalf.stny.rr.com>
References: <4A167307.7020905@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 May 2009, Lai Jiangshan wrote:

> 
> There some unneeded events in debugfs/tracing/ftrace/ when the
> corresponding CONFIG_XXXX=n.
> 
> And when CONFIG_ENABLE_EVENT_TRACING=n, various events
> are still created.
> 
> Now when CONFIG_ENABLE_EVENT_TRACING=n, various events are
> not created, trace_export.c is compiled only for creating
> TRACEPOINTs.
> 
> [Impact:] cleanup

I have an issue with this patch. I purposely kept the 
debugfs/tracing/ftrace events there since you may have a binary buffer 
that you want to read that has those events but you are not running a 
kernel that enabled them. But I guess the counter arguement for that is 
then those events may not be the same offset as the kernel that ran it. 
OK, maybe it would be fine to disable the events if the kernel does not 
use them. We should also put the same #ifdef's around the structs to make 
sure no other trace uses them.

Still seems a bit messy with all those ifdefs :-/

The second change with the CONFIG_ENABLE_EVENT_TRACER is something that we 
are having issue with the make scripts. We want EVENT_TRACE enabled 
anytime TRACING is enabled. We do _not_ want to disable it.

The config option is there to enable event_tracer when on other tracing is 
enabled. But we can't get rid of the option when tracing is enabled, 
because we run into circular dependecies. Here's what we want:

	config TRACING
		select CONFIG_EVENT_TRACER

	config CONFIG_ENABLE_EVENT_TRACING
		prompt "select event tracer"
		depends on !TRACING
		select CONFIG_EVENT_TRACER

but!

	config CONFIG_EVENT_TRACER
		select TRACING

Which we then get an error creating the kbuild system due to dependency 
problems.

The event tracer prompt should not be there when tracing is selected, 
since we already have events, but I have yet to figure out how to get rid 
of it.

Thus, I'll be OK with the first part of your patch, but I'm against the 
second part.

-- Steve


