Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZKBAhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZKBAhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZKBAhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:37:22 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:64622 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbZKBAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=khP5iZn4qA0k+7BUd5J0kgmybAO6cBc8hUZde5S154+ny0mRiAhIkN19C7vVlOUYtU
         p1Rp8FRqmNjAo5s6nqT8B5YHNUIJTcohFdRLlOY/r+NLsKKH/XrMnKDY/wbZrA181IJh
         KkEY9SjBFGrtOlHioJuRzDn86RT9JyiyWbGJc=
Date: Mon, 2 Nov 2009 01:37:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from
	crashing function graph tracer
Message-ID: <20091102003723.GF5263@nowhere>
References: <20091029205151.852744305@goodmis.org> <4AEA10EC.8000103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEA10EC.8000103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 06:02:20PM -0400, Masami Hiramatsu wrote:
> Steven Rostedt wrote:
> > Lately I've been testing with an allyesconfig. When I ran the function graph
> > tracer, it immediately crashed the kernel. Thanks to the new frame pointer
> > test in function graph, it reported directly what the issue was and then
> > panicked the kernel to prevent any unexpected damage from happening.
> > 
> > It pointed the error to be with jtcp_rcv_established. Which is a jprobe
> > function added to tcp_rcv_established at bootup when CONFIG_NET_TCPPROBE
> > is enabled.
> > 
> > Jprobes and the function graph tracer use the same mechanism to trace
> > the exit of a function. Unfortunately, only one can be done at a time.
> > The function graph tracer replaces the return address with its own handler,
> > but so does jprobes. The two are not compatible.
> 
> AFAIK, Jprobe doesn't trace the exit of a function. I assume that
> jprobe's user handler causes the problem, since the handler never
> returns normal way.
> Instead of that, it just calls jprobe_return() which causes
> int3 to be trapped by kprobe's break handler. And the break handler
> fixup regs->ip to back to traced function.
> 
> Actually, this will cause a problem with function graph tracer.
> The f-g-tracer push the return address into the special stack and replaces
> it with fixup function (This is similar (not same) mechanism of kretprobe.)
> And then the traced function returns, it returns to the fixup function and
> it pops the return address up and back to the real caller.
> 
> So, if the f-g-tracer traces jprobe user handler, the pop operation
> will be skipped because the the handler never returns.


I'm not sure I've well understood how is performed the call to the jprobe
handler.
But if I understand well we have:

	func() {
		int3() {
			jprobe_handler() {
				(-)
				set ip after iret to user_handler()
			}
		}
		user_handler() {
			jprobe_return() {
				(+)
				int3() {
					set ip after iret to func+...()
				}
			       |
			       |
			       |
                <--------------
                (execute the rest of func())
	}

If we replace (-) with pause_graph_tracing() and (+) with
unpause_graph_tracing(), this should do the trick...I hope.

