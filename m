Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYLDO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYLDO5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYLDO5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:57:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYLDO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:57:42 -0500
Date: Thu, 4 Dec 2008 09:57:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
In-Reply-To: <m163m0umml.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812040953470.5240@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <m163m0umml.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Eric W. Biederman wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> >
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 10b1d7c..eb57dc1 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -49,6 +49,7 @@ static int last_ftrace_enabled;
> >  
> >  /* set when tracing only a pid */
> >  struct pid *ftrace_pid_trace;
> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
> 
> The initializer should be spelled &init_struct_pid instead of (struct pid *)1;
> 
> Except for the special case of finding this unhashed pid, by making the
> attach_pid(p, PIDTYPE_PID, pid) unconditional in copy_process, you can
> make the rest of the special cases go away.

Not that easy. It turns out that all idle tasks share the init_struct_pid, 
and if you add the attach_pid() outside the if statement, you only change 
the owner of the init_struct_pid to the last CPU to come on line.

I tried to allocate the pid, but by doing that it seems that the alloc_pid 
code will assign a number other than 0.  The changes needed to fork.c to 
make this work is quickly going beyond a trivial fix, where I do not want 
to become a pid container developer in order to implement it.

-- Steve

