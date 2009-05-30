Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZE3Kbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZE3Kbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZE3Kbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:31:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:35990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbZE3Kbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:31:38 -0400
Subject: Re: [PATCH tip 1/1] perf_counter tools: Add locking to perf top
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090529203322.GS4747@ghostprotocols.net>
References: <20090529200307.GR4747@ghostprotocols.net>
	 <1243628537.6645.106.camel@laptop>
	 <20090529203322.GS4747@ghostprotocols.net>
Content-Type: text/plain
Date: Sat, 30 May 2009 12:31:26 +0200
Message-Id: <1243679486.6645.125.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 17:33 -0300, Arnaldo Carvalho de Melo wrote:
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

If you want to do that, you need to use the rcu list primitives,
otherwise insertion vs iteration isn't safe. Memory barriers and
ordering still matter in userspace.

And whichever way you turn that list_entry() under mutex, that's utter
rubbish, it doesn't protect anything.

As it stands, this code is more broken than it was before for the simple
reason that it might fool people into believing its ok.

