Return-Path: <linux-kernel-owner+w=401wt.eu-S1763593AbZE2Ud7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763593AbZE2Ud7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZE2Udv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:33:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56305 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbZE2Udu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:33:50 -0400
Date: Fri, 29 May 2009 17:33:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf_counter tools: Add locking to perf top
Message-ID: <20090529203322.GS4747@ghostprotocols.net>
References: <20090529200307.GR4747@ghostprotocols.net> <1243628537.6645.106.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243628537.6645.106.camel@laptop>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 29, 2009 at 10:22:17PM +0200, Peter Zijlstra escreveu:
> On Fri, 2009-05-29 at 17:03 -0300, Arnaldo Carvalho de Melo wrote:
> >         /* Sort the active symbols */
> > -       list_for_each_entry_safe(syme, n, &active_symbols, node) {
> > -               if (syme->count[0] != 0) {
> > +       pthread_mutex_lock(&active_symbols_lock);
> > +       syme = list_entry(active_symbols.next, struct sym_entry, node);
> > +       pthread_mutex_unlock(&active_symbols_lock);
> > +
> > +       list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
> > +               syme->snap_count = syme->count[0];
> > +               if (syme->snap_count != 0) {
> > +                       syme->weight = sym_weight(syme);
> 
> That looks wrong, you basically do a fancy cast while holding the lock,
> then you overwrite the variable doing a list iteration without holding
> the lock.
> 
> If list_add and list_del are under a lock, the iteration should be too.

Look closer :)

1) List insertion is only done at the head and by the other thread, thus
the lock above. The other thread will only mess with the above
syme->node.prev when inserting a new head, never with .next.

2) List deletion is only done after taking the lock, and on the above
thread.

Only problem probably is to access syme->count[0], that on some
architectures may not be atomic.

- Arnaldo
