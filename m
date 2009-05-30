Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZE3JdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZE3JdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZE3JdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:33:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbZE3JdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:33:14 -0400
Date: Sat, 30 May 2009 11:33:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf_counter tools: Add locking to perf top
Message-ID: <20090530093302.GA16913@elte.hu>
References: <20090529200307.GR4747@ghostprotocols.net> <1243628537.6645.106.camel@laptop> <20090529203322.GS4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529203322.GS4747@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, May 29, 2009 at 10:22:17PM +0200, Peter Zijlstra escreveu:
> > On Fri, 2009-05-29 at 17:03 -0300, Arnaldo Carvalho de Melo wrote:
> > >         /* Sort the active symbols */
> > > -       list_for_each_entry_safe(syme, n, &active_symbols, node) {
> > > -               if (syme->count[0] != 0) {
> > > +       pthread_mutex_lock(&active_symbols_lock);
> > > +       syme = list_entry(active_symbols.next, struct sym_entry, node);
> > > +       pthread_mutex_unlock(&active_symbols_lock);
> > > +
> > > +       list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
> > > +               syme->snap_count = syme->count[0];
> > > +               if (syme->snap_count != 0) {
> > > +                       syme->weight = sym_weight(syme);
> > 
> > That looks wrong, you basically do a fancy cast while holding the lock,
> > then you overwrite the variable doing a list iteration without holding
> > the lock.
> > 
> > If list_add and list_del are under a lock, the iteration should be too.
> 
> Look closer :)
> 
> 1) List insertion is only done at the head and by the other thread, thus
> the lock above. The other thread will only mess with the above
> syme->node.prev when inserting a new head, never with .next.
> 
> 2) List deletion is only done after taking the lock, and on the above
> thread.
> 
> Only problem probably is to access syme->count[0], that on some
> architectures may not be atomic.

as long as it's machine word aligned, the result of a read is atomic 
on all SMP capable systems.

(It might still get reordered in an unpleasant way by either the 
compiler or the CPU, so putting appropriate barriers there might be 
handy.)

	Ingo
