Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYGON7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYGON7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYGON7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:59:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYGON7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:59:12 -0400
Subject: Re: [patch 01/15] Kernel Tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <20080715132543.GB20037@Krystal>
References: <20080709145929.352201601@polymtl.ca>
	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>
	 <20080715132543.GB20037@Krystal>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:59:16 +0200
Message-Id: <1216130356.12595.184.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 09:25 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2008-07-09 at 10:59 -0400, Mathieu Desnoyers wrote:

> > > +#define __DO_TRACE(tp, proto, args)					\
> > > +	do {								\
> > > +		int i;							\
> > > +		void **funcs;						\
> > > +		preempt_disable();					\
> > > +		funcs = (tp)->funcs;					\
> > > +		smp_read_barrier_depends();				\
> > > +		if (funcs) {						\
> > > +			for (i = 0; funcs[i]; i++) {			\
> > 
> > can't you get rid of 'i' and write:
> > 
> >   void **func;
> > 
> >   preempt_disable();
> >   func = (tp)->funcs;
> >   smp_read_barrier_depends();
> >   for (; func; func++)
> >     ((void (*)(proto))func)(args);
> >   preempt_enable();
> > 
> 
> Yes, I though there would be an optimization to do here, I'll use your
> proposal. This code snippet is especially important since it will
> generate instructions near every tracepoint side. Saving a few bytes
> becomes important.
> 
> Given that (tp)->funcs references an array of function pointers and that
> it can be NULL, the if (funcs) test must still be there and we must use
> 
> #define __DO_TRACE(tp, proto, args)					\
> 	do {								\
> 		void *func;						\
> 									\
> 		preempt_disable();					\
> 		if ((tp)->funcs) {					\
> 			func = rcu_dereference((tp)->funcs);		\
> 			for (; func; func++) {				\
> 				((void(*)(proto))(func))(args);		\
> 			}						\
> 		}							\
> 		preempt_enable();					\
> 	} while (0)
> 
> 
> The resulting assembly is a bit more dense than my previous
> implementation, which is good :

My version also has that if ((tp)->funcs), but its hidden in the 
for (; func; func++) loop. The only thing your version does is an extra
test of tp->funcs but without read depends barrier - not sure if that is
ok.



