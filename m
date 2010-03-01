Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0CANRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:17:12 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34082 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0CANRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y3NVnxKbZDvejTWSvCFDKULhxBj5ROW+VahMpiB3aKYZ1b3nUSywQG/M/IwqHMYfBU
         0YtkWnSXIUZDU0MC0xKzsn0yp+dd5LRi9krhorO1+9mdh//s6+JO5Mu/6IWRSMetF+R4
         XXij1wFBubfs8DTusXca6oq1InoqpI/ZjkgsA=
Date: Mon, 1 Mar 2010 14:17:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
Message-ID: <20100301131701.GA5562@nowhere>
References: <20100227150942.GA6394@elte.hu> <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain> <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain> <20100301080058.GA8049@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301080058.GA8049@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 09:00:58AM +0100, Ingo Molnar wrote:
> Weird. It seems to be around multiples of .8: 0.8, 1.6, 2.4, with some extra 
> overhead.
> 
> Almost as if some calibration routine or some other busy-loop misses the train 
> occasionally.
> 
> The way i'd go about debugging this is to narrow down the approximate place 
> the slowdown happens, then enable CONFIG_FUNCTION_TRACER (and disable 
> CONFIG_DYNAMIC_FTRACE=y, to not have to deal with the dynamic patching 
> aspects), and do a single-shot tracing session of only that section, on only 
> one CPU:
> 
> 	if (smp_processor_id() == 7)
> 		ftrace_enabled = 1;
> 
> 	... bootup sequence ...
> 
> 	if (smp_processor_id() == 7)
> 		ftrace_enabled = 0;
> 
> And recover the resulting trace from /debug/tracing/trace - it should have the reason
> in it plain and simple.
> 
> ( Unfortunately i'm not 100% sure that setting ftrace_enabled to 1 is enough. 
>   I asked for a simple ad-hoc enable/disable function tracing mechanism _ages_ 
>   ago - Steve, Frederic, what happened to that? ftrace_start()/stop() does not 
>   seem to allow that. )



I don't remember such request. But that would be useful indeed.
We could simply pair the setting of an early tracer with tracing
disabled and then manually delimit the places to trace with
tracing_on/tracing_off().

Whatever.

For now what you can do is setting the function_graph tracer
on bootup:

	ftrace=function_graph

and call ftrace_graph_stop() in the place you want the trace
to finish (you could use ftrace_graph_filter= to delimit
the function tracing window, but that won't work without
dynamic tracing, neither with __init functions).

So, after the boot you can look at /debug/tracing/per_cpu/cpu7/trace
and the end of the trace should contain what you want.

