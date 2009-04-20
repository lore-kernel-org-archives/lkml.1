Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZDTT4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZDTT4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZDTTz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:55:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZDTTz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:55:56 -0400
Date: Mon, 20 Apr 2009 15:55:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <alpine.DEB.2.00.0904201540400.26147@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904201554420.26147@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192917.GB25629@elte.hu> <alpine.DEB.2.00.0904201540400.26147@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Steven Rostedt wrote:

> 
> On Mon, 20 Apr 2009, Ingo Molnar wrote:
> > Running tests on all trace events:
> > Testing all events: <4>Tracing recursion: HC[0]:SC[0]:NMI[0]
> 
> Recursion is wrong :-/
> 
> > ------------[ cut here ]------------
> > WARNING: at kernel/trace/ring_buffer.c:1510 ring_buffer_lock_reserve+0xf7/0x1ce()
> > Hardware name: To Be Filled By O.E.M.
> > Pid: 1, comm: swapper Not tainted 2.6.30-rc2-tip-01538-ge8201b9-dirty #37740
> > Call Trace:
> >  <IRQ>  [<ffffffff80268a01>] warn_slowpath+0xcc/0x114
> >  [<ffffffff80299ed3>] ? trace_hardirqs_on_caller+0x11d/0x179
> >  [<ffffffff80299ba6>] ? mark_held_locks+0x60/0x95
> >  [<ffffffff802ca335>] ring_buffer_lock_reserve+0xf7/0x1ce
> >  [<ffffffff802ceb60>] trace_buffer_lock_reserve+0x34/0x7e
> >  [<ffffffff810c8f97>] ? do_IRQ+0xf/0xe8
> >  [<ffffffff802cf949>] trace_current_buffer_lock_reserve+0x36/0x4c
> >  [<ffffffff802d9da4>] function_test_events_call+0x7e/0xe2
> >  [<ffffffff80216313>] ? ret_from_intr+0x0/0x16
> >  [<ffffffff80215616>] ftrace_call+0x5/0x2b
> >  [<ffffffff8021630e>] ? common_interrupt+0xe/0x13
> >  [<ffffffff810c8f9c>] ? do_IRQ+0x14/0xe8
> 
> The function tracer was called before we updated the hardirq_count :-/
> 
> I liked the fact that we can detect same level recursion. Perhaps I'll 
> just make a depth test instead. Have a max of 16? times we can recurse 
> (should be plenty) and then bug if we hit it?
> 

The other option is not to trace any interrupt function that is called 
before "irq_enter". That would mean we would need to add notrace to do_IRQ 
and friends.

-- Steve

