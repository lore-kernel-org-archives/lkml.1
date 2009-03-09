Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZCIUkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZCIUkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZCIUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:40:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:11317 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZCIUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9nD4UtBbSxWiKUNGrQJ6/nrn77KP1+Bvs2pJln+lX/q+AvM4vPs27kXEQ25t8oLT+
         LZC6r4TbkuuoepUn8cSoZoLAX3pgLRU5fc02n+TiWeetrG+nSVDrp2E2lYe4TnTJZ43c
         vYdpIG+Xzq+3JTcL2GHSObXh1W93NwaWckJpQ=
Date: Mon, 9 Mar 2009 21:40:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090309204013.GB5010@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <20090308162444.GG19658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308162444.GG19658@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 05:24:44PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +static const struct syscall_trace_entry syscall_trace_entries[] = {
> > +	/* For open, the first argument is a string, hence the given mask */
> > +	[SYSCALL_TRACE_OPEN]	= SYS_TRACE_ENTRY(open, 3, 0x1),
> > +	[SYSCALL_TRACE_CLOSE]	= SYS_TRACE_ENTRY(close, 1, 0),
> > +	[SYSCALL_TRACE_READ]	= SYS_TRACE_ENTRY(read, 3, 0),
> > +	[SYSCALL_TRACE_WRITE]	= SYS_TRACE_ENTRY(read, 3, 0),
> > +};
> 
> s/read/write in the last entry i guess.
> 
> But i think the whole concept of duplicating the syscall table 
> is the wrong way around.
> 
> Note that we dont have to build this information at all - in 
> 2.6.29-rc1 all syscalls got wrapper macros:
> 
>  SYSCALL_DEFINE1(nice, int, increment)
>  SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
>  SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
>                  unsigned long __user *, user_mask_ptr)
> 
> We also have the syscall table itself.
> 
> So what we can do: by changing the SYSCALL_DEFINEX() macros we 
> can emit the following information into a table:
> 
>   (syscall_fn_address, syscall_name_string, #of arguments, array 
>    of argument names and type sizeof()s)
> 
> then during bootup we can match up the sys_call_table[] to the 
> secondary table we built, so that we can order the secondary 
> table based on syscall NR. 99% of the syscalls will match up 
> just fine.
> 
> 	Ingo

Yes, I didn't know the SYSCALL_DEFINEx() macro until Peter told me.
That's indeed a much better way to proceed, I will look at all that.


Thanks!

