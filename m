Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012Ab0AMQYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0AMQYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0AMQYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:24:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0AMQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:24:07 -0500
Subject: Re: [RFC 12/12][PATCH] SCHED_DEADLINE: modified sched_*_ex API
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1263378452.3853.61.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708086.6228.469.camel@Palantir>  <1262012958.7135.124.camel@laptop>
	 <1263378452.3853.61.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:23:44 +0100
Message-ID: <1263399824.4244.234.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 11:27 +0100, Raistlin wrote:
> On Mon, 2009-12-28 at 16:09 +0100, Peter Zijlstra wrote:
> > On Fri, 2009-10-16 at 17:48 +0200, Raistlin wrote:
> > > @@ -6807,9 +6811,10 @@ out_unlock:
> > >  /**
> > >   * sys_sched_getparam - get the DEADLINE task parameters of a thread
> > >   * @pid: the pid in question.
> > > + * @len: size of data pointed by param_ex.
> > >   * @param_ex: structure containing the new parameters (deadline, runtime, etc.).
> > >   */
> > > -SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> > > +SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
> > >                 struct sched_param_ex __user *, param_ex)
> > >  {
> > >         struct sched_param_ex lp;
> > > @@ -6818,6 +6823,8 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> > >  
> > >         if (!param_ex || pid < 0)
> > >                 return -EINVAL;
> > > +       if (len < sizeof(struct sched_param_ex))
> > > +               return -EINVAL;
> > >  
> > >         read_lock(&tasklist_lock);
> > >         p = find_process_by_pid(pid);
> > 
> > This allows len > sizeof().
> > 
> Yes...
> 
> > > @@ -6837,7 +6844,7 @@ SYSCALL_DEFINE2(sched_getparam_ex, pid_t, pid,
> > >         /*
> > >          * This one might sleep, we cannot do it with a spinlock held ....
> > >          */
> > > -       retval = copy_to_user(param_ex, &lp, sizeof(*param_ex)) ? -EFAULT : 0;
> > > +       retval = copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
> > >  
> > >         return retval; 
> > 
> > Which would copy more than lp, resulting in a stack leak, right?
> > 
> .... And yes again! :-)
> 
> This has been done bearing in mind that the _kernel_side_ sched_param_ex
> --once stabilized-- will never lower its size. I.e., it should always
> grow and, if/when it does, it should retain the position of existing
> fields, for the sake of backward compatibility.
> 
> In that case, I think, the only possible case we have to face is the one
> where the "old" userspace program/library uses a version of
> sched_param_ex which is smaller than the one in the kernel, and what we
> want is the kernel to fill only the fields existing in the userspace
> code.
> 
> Does all this make sense?

> If yes, I guess I just have to flip the inequality in the if() turning
> it into "if (len > sizeof())" (, then apologize for the glaring
> bug! :-P) and then I'm done, am I?

Right, I think so..

