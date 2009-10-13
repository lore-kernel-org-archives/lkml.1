Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbZJMVMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbZJMVMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbZJMVMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:12:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZJMVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:12:13 -0400
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
 ret with jmp
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091013204702.GA4533@Krystal>
References: <20091013203349.814936710@goodmis.org>
	 <20091013203425.042034383@goodmis.org>  <20091013204702.GA4533@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 17:10:14 -0400
Message-Id: <1255468214.7113.2396.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 16:47 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The function graph tracer replaces the return address with a hook to
> > trace the exit of the function call. This hook will finish by returning
> > to the real location the function should return to.
> > 
> > But the current implementation uses a ret to jump to the real return
> > location. This causes a imbalance between calls and ret. That is
> > the original function does a call, the ret goes to the handler
> > and then the handler does a ret without a matching call.
> > 
> > Although the function graph tracer itself still breaks the branch
> > predictor by replacing the original ret, by using a second ret and
> > causing an imbalance, it breaks the predictor even more.
> > 
> > This patch replaces the ret with a jmp to keep the calls and ret
> > balanced. I tested this on one box and it showed a 1.7% increase in
> > performance. Another box only showed a small 0.3% increase. But no
> > box that I tested this on showed a decrease in performance by making this
> > change.
> 
> This sounds exactly like what I proposed at LPC. I'm glad it shows
> actual improvements.

This is what we discussed at LPC. We both were under the assumption that
a jump would work. The question was how to make that jump without hosing
registers.

We lucked out that this is the back end of the return sequence. Where we
can still clobber callie registers. (just not the ones holding the
return code).

> 
> Just to make sure I understand, the old sequence was:
> 
> call fct
>   call ftrace_entry
>   ret to fct
> ret to ftrace_exit
> ret to caller
> 
> and you now have:
> 
> call fct
>   call ftrace_entry
>   ret to fct
> ret to ftrace_exit
> jmp to caller
> 
> Am I correct ?

Almost.
 
What it was:

call function
  function:
  call mcount
     mcount:
     call ftrace_entry
       ftrace_entry:
       mess up with return code of caller
       ret
     ret

   [function code]

   ret to ftrace_exit
     ftrace_exit:
     get real return
     ret to original

So for the function we have 3 calls and 4 rets

Now we have:

What it was:

call function
  function:
  call mcount
     mcount:
     call ftrace_entry
       ftrace_entry:
       mess up with return code of caller
       ret
     ret

   [function code]

   ret to ftrace_exit
     ftrace_exit:
     get real return
     jmp to original

Now we have 3 calls and 3 rets

Note the first call still does not match the ret, but we don't do two
rets anymore.

-- Steve



