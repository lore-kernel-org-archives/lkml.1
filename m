Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZDPAeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZDPAeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZDPAek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:34:40 -0400
Received: from gw.goop.org ([64.81.55.164]:58361 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZDPAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:34:40 -0400
Message-ID: <49E67D1D.8020704@goop.org>
Date: Wed, 15 Apr 2009 17:34:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problem with CREATE_TRACE_POINTS and recursion safety
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a problem with CREATE_TRACE_POINTS being too indiscriminate.  
The trouble is that it not only creates tracepoint definitions for the 
intended tracepoints, but any other tracepoint definitions which get 
included incidentally.

For example, I'm seeing my paravirt tracepoints being instantiated in 
both kernel/sched.o and kernel/irq/manage.o as side-effects of the 
scheduler and irq tracepoints being instantiated.

I'm experimenting with a different scheme, wherein a subsystem defines 
CREATE_FOO_TRACE_POINTS in the .c file where it wants to instantiate the 
tracepoints - rather than CREATE_TRACE_POINTS - and its 
trace/events/foo.h does:

    #ifdef CREATE_FOO_TRACE_POINTS
    #undef CREATE_FOO_TRACE_POINTS	/* avoid infinite recursion */
    #include <trace/instantiate_trace.h>
    #else
    #include <trace/define_trace.h>
    #endif

where instantiate_trace.h is:

    #define CREATE_TRACE_POINTS
    #include <trace/define_trace.h>
    #undef CREATE_TRACE_POINTS

(Just to prevent a bit more repeated boilerplate in each events 
definition file.)

This seems to work.  (Update: no it doesn't.  WTF has paravirt-trace.o 
got duplicate kmem tracepoints?!)

A related problem is that the TRACE_INCLUDE_FILE mechanism doesn't work, 
because if any tracepoint definition header sets it, it overrides the 
setting for all others, so, for example, arch/x86/include/asm/paravirt.h 
ends up being included as the source of definitions for events/sched.h.  
I gave up and moved paravirt-trace.h to trace/events/pvops.h rather than 
try to deal with it.

Lucky for you Steven, none of this is getting any more pretty, so you 
may yet get your prize.

    J
