Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZJMVWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZJMVWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZJMVWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:22:14 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:38910 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbZJMVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:22:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFAB+I1EpMRK1g/2dsb2JhbACBUdhhhC0E
Date: Tue, 13 Oct 2009 17:21:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
	ret with jmp
Message-ID: <20091013212126.GA8039@Krystal>
References: <20091013203349.814936710@goodmis.org> <20091013203425.042034383@goodmis.org> <20091013204702.GA4533@Krystal> <1255468214.7113.2396.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1255468214.7113.2396.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:17:57 up 56 days,  8:07,  2 users,  load average: 0.72, 0.40,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2009-10-13 at 16:47 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > The function graph tracer replaces the return address with a hook to
> > > trace the exit of the function call. This hook will finish by returning
> > > to the real location the function should return to.
> > > 
> > > But the current implementation uses a ret to jump to the real return
> > > location. This causes a imbalance between calls and ret. That is
> > > the original function does a call, the ret goes to the handler
> > > and then the handler does a ret without a matching call.
> > > 
> > > Although the function graph tracer itself still breaks the branch
> > > predictor by replacing the original ret, by using a second ret and
> > > causing an imbalance, it breaks the predictor even more.
> > > 
> > > This patch replaces the ret with a jmp to keep the calls and ret
> > > balanced. I tested this on one box and it showed a 1.7% increase in
> > > performance. Another box only showed a small 0.3% increase. But no
> > > box that I tested this on showed a decrease in performance by making this
> > > change.
> > 
> > This sounds exactly like what I proposed at LPC. I'm glad it shows
> > actual improvements.
> 
> This is what we discussed at LPC. We both were under the assumption that
> a jump would work. The question was how to make that jump without hosing
> registers.
> 
> We lucked out that this is the back end of the return sequence. Where we
> can still clobber callie registers. (just not the ones holding the
> return code).
> 
> > 
> > Just to make sure I understand, the old sequence was:
> > 
> > call fct
> >   call ftrace_entry
> >   ret to fct
> > ret to ftrace_exit
> > ret to caller
> > 
> > and you now have:
> > 
> > call fct
> >   call ftrace_entry
> >   ret to fct
> > ret to ftrace_exit
> > jmp to caller
> > 
> > Am I correct ?
> 
> Almost.
>  
> What it was:
> 
> call function
>   function:
>   call mcount
>      mcount:
>      call ftrace_entry
>        ftrace_entry:
>        mess up with return code of caller
>        ret
>      ret
> 
>    [function code]
> 
>    ret to ftrace_exit
>      ftrace_exit:
>      get real return
>      ret to original
> 
> So for the function we have 3 calls and 4 rets
> 
> Now we have:
> 
> What it was:
> 
> call function
>   function:
>   call mcount
>      mcount:
>      call ftrace_entry

Can we manage to change this call

>        ftrace_entry:
>        mess up with return code of caller
>        ret

.. and this ret for 2 jmp instructions too ?

Given that we have no choice but to kill call/ret prediction logic, I
think it might be good to try to use this logic as little as possible
(by favoring jmp jmp over call/ret when the return target is invariant).

That's just an idea, benchmarks could prove me right/wrong.

Mathieu

>      ret
> 
>    [function code]
> 
>    ret to ftrace_exit
>      ftrace_exit:
>      get real return
>      jmp to original
> 
> Now we have 3 calls and 3 rets
> 
> Note the first call still does not match the ret, but we don't do two
> rets anymore.
> 
> -- Steve
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
