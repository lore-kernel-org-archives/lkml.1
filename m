Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0CEPGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:06:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0CEPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:06:46 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=1w7EyjGFqIuEKHxF0M8A:9 a=2optNa1TnJxSLgOd41HvVNIqwdAA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=_oeuOwmZL1R1kA_z:21 a=Gv4Kac4auHPU8feU:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 10:06:43 -0500
Message-ID: <1267801603.10871.1725.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 15:16 +0800, Américo Wang wrote:
> On Fri, Mar 5, 2010 at 12:14 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > On Thu, Mar 4, 2010 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
> >>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
> >>> the soft lockup. On my machine, it is pretty easy, just run:
> >>>
> >>> echo function_graph > current_tracer
> >>>

> >
> > I can't say that because I didn't try -rc6.
> >
> 
> Sigh, 2.6.33-rc6 doesn't work, even 2.6.32 doesn't work...

So basically you are saying that the function_graph tracer, when enabled
has a high overhead? Well, unfortunately, that's expected.

The function_graph tracer traces the start and end of every function. It
uses the same mechanism as function tracer to trace the start of the
function (mcount), but to trace the exit of a function, in the enter of
the function it hijacks the return address and replaces it to call a
trampoline. This trampoline will do the trace and then jump back to the
original return address.

Doing this breaks branch prediction in the CPU, as the CPU uses call/ret
as part of its branch prediction analysis. So function graph tracing is
not just twice as slow as function tracing, it actually has a bigger
impact than that.

So my question to you is, have you seen the function graph perform
better with the same configs in previous kernels? Also, the function
graph makes other debugging (like lockdep) have a greater impact to
performance than they usually do.

Now some things you can do to help performance. One is not to trace
functions that are known to have a high hit rate. You can do this with
the set_ftrace_notrace file, or add "ftrace_notrace=func1,func2,func3"
to the command line where func1,func2,func3 are the functions you do not
want to trace. This just adds these by default to the set_ftrace_notrace
and can be removed at runtime.


The functions I commonly write to are:

echo '*spin_lock*' '*spin_unlock*' '*spin_try*' '*rcu_read*' > set_ftace_notrace

since these functions are hit quite intensively, by not tracing them it
helps a bit with performance.

-- Steve


