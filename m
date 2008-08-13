Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYHMK4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYHMK4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYHMK4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:56:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbYHMK4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:56:41 -0400
Date: Wed, 13 Aug 2008 12:56:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Pepper <tpepper@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       jeremy@goop.org, hugh@veritas.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [RFC][PATCH 1/7] lockdep: Fix combinatorial explosion in lock
	subgraph traversal.
Message-ID: <20080813105612.GB32165@elte.hu>
References: <20080804130317.994042639@chello.nl> <20080804131011.749503624@chello.nl> <20080805.013445.30774221.davem@davemloft.net> <1217925973.3589.108.camel@twins> <eada2a070808122048s151d2ea5hb92fc654f4751c44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eada2a070808122048s151d2ea5hb92fc654f4751c44@mail.gmail.com>
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


* Tim Pepper <tpepper@gmail.com> wrote:

> On Tue, Aug 5, 2008 at 1:46 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2008-08-05 at 01:34 -0700, David Miller wrote:
> >> See:
> >>
> >> http://marc.info/?l=linux-kernel&m=121758260130275&w=2
> >
> > Probably missed that, thanks for reminding me.
> >
> > Andrew, please pick up:
> >
> > ---
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 1 Aug 2008 11:23:50 +0200
> > Subject: [PATCH] lockdep: build fix
> >
> > fix:
> >
> >  kernel/built-in.o: In function `lockdep_stats_show':
> >  lockdep_proc.c:(.text+0x3cb2f): undefined reference to `lockdep_count_forward_deps'
> >  kernel/built-in.o: In function `l_show':
> >  lockdep_proc.c:(.text+0x3d02b): undefined reference to `lockdep_count_forward_deps'
> >  lockdep_proc.c:(.text+0x3d047): undefined reference to `lockdep_count_backward_deps'
> >
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/lockdep_internals.h |   13 +++++++++++++
> >  1 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
> > index 68d44ec..f5c6a14 100644
> > --- a/kernel/lockdep_internals.h
> > +++ b/kernel/lockdep_internals.h
> > @@ -53,8 +53,21 @@ extern unsigned int nr_process_chains;
> >  extern unsigned int max_lockdep_depth;
> >  extern unsigned int max_recursion_depth;
> >
> > +#ifdef CONFIG_PROVE_LOCKING
> >  extern unsigned long lockdep_count_forward_deps(struct lock_class *);
> >  extern unsigned long lockdep_count_backward_deps(struct lock_class *);
> > +#else
> > +static inline unsigned long
> > +lockdep_count_forward_deps(struct lock_class *class)
> > +{
> > +       return 0;
> > +}
> > +static inline unsigned long
> > +lockdep_count_backward_deps(struct lock_class *class)
> > +{
> > +       return 0;
> > +}
> > +#endif
> >
> >  #ifdef CONFIG_DEBUG_LOCKDEP
> >  /*
> >
> >
> 
> 
> Looks like this is needed for 2.6.27-rc3 to build here. [...]

ok, i've put this into tip/core/urgent, i mistakenly applied it to 
tip/master so it didnt go to Linus in time. Below is the commit from 
tip/core/urgent.

	Ingo

----------------->
>From d6672c501852d577097f6757c311d937aca0b04b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 1 Aug 2008 11:23:50 +0200
Subject: [PATCH] lockdep: build fix

fix:

 kernel/built-in.o: In function `lockdep_stats_show':
 lockdep_proc.c:(.text+0x3cb2f): undefined reference to `lockdep_count_forward_deps'
 kernel/built-in.o: In function `l_show':
 lockdep_proc.c:(.text+0x3d02b): undefined reference to `lockdep_count_forward_deps'
 lockdep_proc.c:(.text+0x3d047): undefined reference to `lockdep_count_backward_deps'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep_internals.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 55db193..56b1969 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -50,8 +50,21 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+#ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+#else
+static inline unsigned long
+lockdep_count_forward_deps(struct lock_class *class)
+{
+	return 0;
+}
+static inline unsigned long
+lockdep_count_backward_deps(struct lock_class *class)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
