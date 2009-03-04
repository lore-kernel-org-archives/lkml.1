Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZCDLnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZCDLnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZCDLnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:43:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZCDLnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:43:37 -0500
Date: Wed, 4 Mar 2009 12:43:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
Message-ID: <20090304114319.GA4916@elte.hu>
References: <1236164586.5330.7142.camel@laptop> <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236166375.5330.7209.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-03-04 at 12:23 +0100, Frederic Weisbecker wrote:
> > > ---
> > > Subject: tracing: lockdep tracepoints
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Tue Mar 03 22:03:08 CET 2009
> > > 
> > > Augment the traces with lock names when lockdep is available:
> > > 
> > >  1)               |  down_read_trylock() {
> > >  1)               |    _spin_lock_irqsave() {
> > >  1)               |      /* lock_acquire: name: &sem->wait_lock */
> > >  1)   4.201 us    |    }
> > >  1)               |    _spin_unlock_irqrestore() {
> > >  1)               |      /* lock_release: name: &sem->wait_lock */
> > 
> > Nice idea.
> > I would just suggest to drop the "name:" since the comment is intuitive enough
> > to figure out what we have after lock_{release,acquire}: 
> 
> Makes sense I guess..
> 
> Here goes.. one s/name: //g later
> 
> ---
> Subject: tracing: lockdep tracepoints
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Mar 03 22:03:08 CET 2009
> 
> Augment the traces with lock names when lockdep is available:
> 
>  1)               |  down_read_trylock() {
>  1)               |    _spin_lock_irqsave() {
>  1)               |      /* lock_acquire: &sem->wait_lock */
>  1)   4.201 us    |    }
>  1)               |    _spin_unlock_irqrestore() {
>  1)               |      /* lock_release: &sem->wait_lock */
>  1)   3.523 us    |    }
>  1)               |  /* lock_acquire: try read &mm->mmap_sem */
>  1) + 13.386 us   |  }

very nice! :-)

>  1)   1.460 us    |      page_add_file_rmap();
>  1)               |      _spin_unlock() {
>  1)               |        /* lock_release: __pte_lockptr(page) */
>  1)   3.115 us    |      }
>  1)               |      unlock_page() {
>  1)   1.421 us    |        page_waitqueue();
>  1)   1.220 us    |        __wake_up_bit();
>  1)   6.519 us    |      }

btw., we might want to add tracepoints for 
pagelock-acquire/release events too?

> +TRACE_FORMAT(lock_contended,
> +	TPPROTO(struct lockdep_map *lock, unsigned long ip),
> +	TPARGS(lock, ip),
> +	TPFMT("%s", lock->name)
> +	);

Would it be possible to use the C syntax tracepoints perhaps? 
They are bigger:

     TRACE_EVENT_FORMAT(sched_switch,
        TPPROTO(struct rq *rq, struct task_struct *prev,
                struct task_struct *next),
        TPARGS(rq, prev, next),
        TPFMT("task %s:%d ==> %s:%d",
              prev->comm, prev->pid, next->comm, next->pid),
        TRACE_STRUCT(
                TRACE_FIELD(pid_t, prev_pid, prev->pid)
                TRACE_FIELD(int, prev_prio, prev->prio)
                TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
                                    next_comm,
                                    TPCMD(memcpy(TRACE_ENTRY->next_comm,
                                                 next->comm,
                                                 TASK_COMM_LEN)))
                TRACE_FIELD(pid_t, next_pid, next->pid)
                TRACE_FIELD(int, next_prio, next->prio)
        ),
        TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
        );

but a lot faster.

	Ingo
