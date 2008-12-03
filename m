Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYLCLpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYLCLpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYLCLpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:45:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYLCLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:45:00 -0500
Date: Wed, 3 Dec 2008 06:44:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/5] ftrace: print real return in dumpstack for function
 graph
In-Reply-To: <20081203081151.GE21006@elte.hu>
Message-ID: <alpine.DEB.1.10.0812030639300.29045@gandalf.stny.rr.com>
References: <20081203045001.367443457@goodmis.org> <20081203045043.769665847@goodmis.org> <20081203081151.GE21006@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This does give a funny side effect in the stack tracer output:
> > 
> >         Depth   Size      Location    (80 entries)
> >         -----   ----      --------
> >   0)     4144      48   save_stack_trace+0x2f/0x4d
> >   1)     4096     128   ftrace_call+0x5/0x2b
> >   2)     3968      16   mempool_alloc_slab+0x16/0x18
> >   3)     3952     384   return_to_handler+0x0/0x73
> >   4)     3568    -240   stack_trace_call+0x11d/0x209
> >   5)     3808     144   return_to_handler+0x0/0x73
> >   6)     3664    -128   mempool_alloc+0x4d/0xfe
> >   7)     3792     128   return_to_handler+0x0/0x73
> >   8)     3664     -32   scsi_sg_alloc+0x48/0x4a [scsi_mod]
> > 
> > As you can see, the real functions are now negative. This is due
> > to them not being found inside the stack.
> 
> Can we do something to output something less funny?

Yeah, I can fix that up. This is a side effect of the change, the funny 
output is a stack trace fix. It did not handle not finding the function in 
the stack very well. It's not a dangling pointer or anything. It is just 
a hickup in the calculation:

> >   4)     3568    -240   stack_trace_call+0x11d/0x209
> >   5)     3808     144   return_to_handler+0x0/0x73  

Notice that 3568 + 240 = 3808

But how about I make it this:

> >   4)     3808      -1   stack_trace_call+0x11d/0x209
> >   5)     3808     144   return_to_handler+0x0/0x73  

The -1 will be a way to flag that it was not found in the stack.

-- Steve

