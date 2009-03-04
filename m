Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbZCDMNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbZCDMNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZCDMNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:13:09 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:47414 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCDMNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o8rbIWT1jX+1S6lJO3GIHqbq/5/km9WhMWVLD9BQt5Pmb9MLc2oaw/qzI9BvS5upSZ
         L0fUZdT1mkxEDf4stA4mweo3SsokY72/+fGI2/uM7y+FVCxyoOigXrtHZM2TTbsiiYpq
         MvDlwPwHYLranD41l7Aqel1QpoTy1QSSdBJp8=
Date: Wed, 4 Mar 2009 13:12:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
Message-ID: <20090304121258.GD6032@nowhere>
References: <1236164586.5330.7142.camel@laptop> <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop> <20090304114319.GA4916@elte.hu> <1236167883.5330.7264.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236167883.5330.7264.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 12:58:03PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-03-04 at 12:43 +0100, Ingo Molnar wrote:
> > 
> > > +TRACE_FORMAT(lock_contended,
> > > +     TPPROTO(struct lockdep_map *lock, unsigned long ip),
> > > +     TPARGS(lock, ip),
> > > +     TPFMT("%s", lock->name)
> > > +     );
> > 
> > Would it be possible to use the C syntax tracepoints perhaps? 
> > They are bigger:
> > 
> >      TRACE_EVENT_FORMAT(sched_switch,
> >         TPPROTO(struct rq *rq, struct task_struct *prev,
> >                 struct task_struct *next),
> >         TPARGS(rq, prev, next),
> >         TPFMT("task %s:%d ==> %s:%d",
> >               prev->comm, prev->pid, next->comm, next->pid),
> >         TRACE_STRUCT(
> >                 TRACE_FIELD(pid_t, prev_pid, prev->pid)
> >                 TRACE_FIELD(int, prev_prio, prev->prio)
> >                 TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
> >                                     next_comm,
> >                                     TPCMD(memcpy(TRACE_ENTRY->next_comm,
> >                                                  next->comm,
> >                                                  TASK_COMM_LEN)))
> >                 TRACE_FIELD(pid_t, next_pid, next->pid)
> >                 TRACE_FIELD(int, next_prio, next->prio)
> >         ),
> >         TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
> >         );
> 
> I'm not quite sure how to do strings with those. The IRQ tracepoints
> cheat and omit the string, and the sched tracepoints cheat and use this
> static sized comm array.
> 


The TRACE_FIELD_SPECIAL is only used in case of complex assignment,
those that can't be done in a simple "=" expression.

All you need is simply:

TRACE_FORMAT(lock_contended,
     TPPROTO(struct lockdep_map *lock, unsigned long ip),
     TPARGS(lock, ip),
     TPFMT("%s", lock->name)
     TRACE_STRUCT(
	TRACE_FIELD(char *, name, lock->name)
     )
     TPRAWFMT("%s");
);

