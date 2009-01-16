Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbZAPQWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbZAPQWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZAPQWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:22:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61549 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbZAPQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:22:29 -0500
Date: Fri, 16 Jan 2009 11:22:27 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
In-Reply-To: <20090116160202.GA15209@elte.hu>
Message-ID: <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com>
 <20090116160202.GA15209@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> > [...] We can register a function to be traced via the function pointer, 
> > and we can pick which functions to trace, but we can not separate out 
> > different functions for different traces.
> 
> Why not? We could have a hash of all traced functions with metadata 
> attached. Since patching functions in/out would be a relatively rare 
> operation, this would be a highly efficient read-mostly hash.

I was afraid you would say that :-)

Yes, we could add something to do this. It would take some thought on a 
good api, and implementation. This is not an easy task by any means. We 
need a way to map between a function call and a tracer, where a function 
call can call more than one tracer.

Probably be best for the tracer to have its own hash. This way the tracer 
could do a look up to determine if it should record or not. When filtering 
on a function, it is all functions that get called that are registered. 
For instance, the stack_tracer hooks to all functions to test the size of 
the stack. When the function tracer is hooked in, it does not notice that 
a stack tracer is there.

But we could design it that with the "function[:tracer]" api to 
set_ftrace_filter. Where if you specify a ":tracer" it will only effect 
those functions. In fact, we could have those functions be the only one 
that call multiple tracers. Right now, if only one function is added, the 
dynamic tracer will have the mcount call that function directly. If you 
add a second function (in the case of the stack tracer and function tracer 
running simultaneously) it will change mcount to call an internal function 
that calls each registered function. With a new design, we can have some 
functions call a function together, or call the list. We could have the 
list check the hash to determine which function to call, but that may be 
difficult.

-- Steve

