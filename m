Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZLICI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZLICI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZLICI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:08:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56730 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbZLICI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:08:27 -0500
Date: Tue, 8 Dec 2009 18:08:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: kordex - <kordex@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/rcutree.c:1228
Message-ID: <20091209020834.GK6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <8b8dd87a0912071058p1ab9ba20y931baa576d370f43@mail.gmail.com> <20091208000819.GA18291@linux.vnet.ibm.com> <8b8dd87a0912080352j36fa24bbvf301a4101d80e434@mail.gmail.com> <8b8dd87a0912080354k69c9f508v8186f0009cf1bf8f@mail.gmail.com> <20091208153557.GD6799@linux.vnet.ibm.com> <8b8dd87a0912080924q3890ea8o23f6d1cfab37e306@mail.gmail.com> <20091208192207.GC6779@linux.vnet.ibm.com> <20091208200657.GA12990@linux.vnet.ibm.com> <8b8dd87a0912081741q24177e1bt3f624eded1590ca6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b8dd87a0912081741q24177e1bt3f624eded1590ca6@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 03:41:00AM +0200, kordex - wrote:
> Hey,
> 
> I put the debug function under init/main.c after rcu_init(); but there
> is no output on dmesg which means that it receives zero value.
> 
> Full dmesg: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.rcu-init.txt

Could you please send the patch you applied to, as you said, put the
debug function under init/main.c after rcu_init()?

							Thanx, Paul

> --Mikko Kortelainen
> 
> 2009/12/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Tue, Dec 08, 2009 at 11:22:07AM -0800, Paul E. McKenney wrote:
> >> At this point, I must defer to those more skilled than I at diagnosing
> >> early-boot problems.
> >
> > Well, that is silly on my part -- the problem seems to appear late in
> > boot, and you had no problem capturing that portion of the boot log.
> >
> > So please see below for a patch providing a rcu_check_beenonline()
> > function that, when called after rcu_init(), returns non-zero if the
> > beenonline fields have become corrupted.  So put calls of the form:
> >
> >        WARN_ON_ONCE(rcu_check_beenonline());
> >
> > in the initialization code path preceding the problem.  Either #include
> > rcupdate.h or explicitly declare the function as appropriate.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >
> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> > index 9642c6b..190a687 100644
> > --- a/include/linux/rcutree.h
> > +++ b/include/linux/rcutree.h
> > @@ -39,6 +39,8 @@ extern int rcu_cpu_notify(struct notifier_block *self,
> >  extern int rcu_needs_cpu(int cpu);
> >  extern int rcu_expedited_torture_stats(char *page);
> >
> > +extern int rcu_check_beenonline(void);
> > +
> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> >
> >  extern void __rcu_read_lock(void);
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 207125b..27d3722 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -77,6 +77,17 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
> >  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> >
> > +/*
> > + * Ad-hoc diagnostic function, for use only after rcu_init() has
> > + * returned.  Assumes that the boot CPU is CPU 0.  Assumes that
> > + * the kernel has been built with CONFIG_TREE_RCU.  Not for inclusion.
> > + * Usage: "WARN_ON_ONCE(rcu_check_beenonline());"
> > + */
> > +int rcu_check_beenonline(void)
> > +{
> > +       return !per_cpu(rcu_sched_data, 0).beenonline ||
> > +              !per_cpu(rcu_bh_data, 0).beenonline;
> > +}
> >
> >  /*
> >  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
> >
