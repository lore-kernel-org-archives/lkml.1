Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYK0OHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYK0OHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYK0OHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:07:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYK0OHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:07:40 -0500
Date: Thu, 27 Nov 2008 09:07:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
In-Reply-To: <20081127112953.GA23702@elte.hu>
Message-ID: <alpine.DEB.1.10.0811270905310.18691@gandalf.stny.rr.com>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu> <1227783300.4454.1410.camel@twins> <20081127112953.GA23702@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Nov 2008, Ingo Molnar wrote:

> 
> mockup:
> 
> ----------------------------------------------------------------
> CPU)     task-PID   |     cost    |  function
> ----------------------------------------------------------------
> 
>   0)     bash-54320 |             |  sys_read() {
>   0)     bash-54320 |    0.331 us |    fget_light();
>   0)     bash-54320 |             |    vfs_read() {
>   0) mycomman-1234  |             |      rw_verify_area() {
>   0) mycomman-1234  |  121.444 us |        func();
> 
> Note some details:
> 
> 1) longer comm names can be stripped off at 7 chars - 7 chars is 
>    enough to recognize most of the things and the PID is good enough 
>    for extra separation)
> 
> 2) the ssssssss-12345 task identifier is _center_ aligned. It's a rare 
>    alignment case but useful here: most people look at the command 
>    portion and the whole string must be greppable and useful in traces 
>    as an identifier - so right-aligning the PID is not a good 
>    solution.
> 
> 3) there's vertical separation after the task portion as well. This 
>    helps us ignore the task portion when we want to look at only the 
>    code and the cost of it. (the common case)
> 
> > comm/pid only in the separator is useless, you cannot grep stuff 
> > like that, also, what's up with those '8's ?
> 
> yeah, that context-switch separator is horrible.
> 
> We can keep the separator, but as something saner, like:
> 
> ---------------------------------------------------------
> CPU)     cost    |  function
> ---------------------------------------------------------
> 
>   0)             |  sys_read() {
>   0)    0.331 us |    fget_light();
>   0)             |    vfs_read() {
>   0)             |      rw_verify_area() {
>   0)             |        security_file_permission() {
>   0)    0.306 us |          cap_file_permission();
>   0)    0.300 us |          cap_file_permission();
>   0)    8.909 us |        }
>   0)    0.993 us |      }
>   0)   11.649 us |    }
>   0)             |    do_sync_read() {
>                  .   -------------------------
>   0)             ==> [ bash-2794 => cat-1234 ]
>                      -------------------------
> 
>   0)             |        __sock_recvmsg() {
>   0)             |          security_socket_recvmsg() {
>   0)  100.319 us |            cap_socket_recvmsg();
> ---------------------------------------------------------

Yes please. I like the separator better. Sure, we could add a trace_option
that will let us print the name on all lines, which will make it grepable
better. But this is better to see when the switch happens.

Also, Frederic could use my ftrace_trace_pid to filter only on a single 
thread. But that will need to wait till we figure out this namespace 
issue.

-- Steve

