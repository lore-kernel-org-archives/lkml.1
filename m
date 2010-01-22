Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788Ab0AVCEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0AVCEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630Ab0AVCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:04:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:62082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0AVCEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UFYIi411AQbZqrZRYex2Z/vqXo2WuYmywXNDRy6VyVh3Yc0FrhrCL7Kxmh5tYyBjI5
         gsC1FApumeJ8bqpPuEcVMLgPf2hTeSTGz+GNfBvpJwxv79vNu+dy3yOJaxO8i6R7xjc2
         P1Ly7tcnWiCBUdY3BWPfa1I1/38d+8Ostv+tc=
Date: Fri, 22 Jan 2010 03:04:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH 02/10] ftrace: Ensure tracing has really stopped
	before leaving unregister_ftrace_graph
Message-ID: <20100122020403.GA8140@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-3-git-send-regression-fweisbec@gmail.com> <1264125108.31321.304.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264125108.31321.304.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 08:51:48PM -0500, Steven Rostedt wrote:
> On Fri, 2010-01-22 at 02:16 +0100, Frederic Weisbecker wrote:
> > When we run under dynamic tracing, we know that after calling
> > unregister_ftrace_graph(), tracing has really stopped because of
> > the hot patching and use of stop_machine().
> 
> This is incorrect. Even after unregister_ftrace_graph() with
> stop_machine(), we still have no guarantee that a call back is not being
> called. This is the reason I use sub tracing instead of NULLs. The call
> to the trace function could have been loaded in a register and then
> preempted. Even after stop_machine() that trace function can be called.
> This is also the reason that I never let modules add hooks to the
> function tracer (although I can easily make a wrapper to do so).



Ah, you are utterly right! I forgot about all that. And looks like
nothing can easily help this.

I just dream about a magic synchronize_trace().

 
> > 
> > But in static tracing case, we only set stub callbacks. This is
> > not sufficient on archs that have weak memory ordering to assume
> > the older callbacks won't be called right after we leave
> > unregister_ftrace_graph().
> > 
> > Insert a read/write memory barrier in the end of
> > unregister_ftrace_graph() so that the code that follow can safely
> > assume tracing has really stopped. This can avoid its older tracing
> > callbacks to perform checks about various states like ensuring
> > needed buffers have been allocated, etc...
> 
> There's no guarantee, even with a smp_mb() that a trace function will
> not be called after being unregistered.



Yeah, indeed...

