Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXE3NPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXE3NPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXE3NPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:15:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:57723 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752485AbXE3NO7 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:14:59 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19j/ckX71JjCbu1GC8cScjtmev3CqD+2yIR/XWgU+
	PIDfnNdsKkjBY4
Date: Wed, 30 May 2007 15:14:58 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070530131458.GA5432@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
References: <1180474738.22497.25.camel@pi.pomac.com> <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com> <1180478288.20546.39.camel@chaos> <20070530113825.GA5203@atjola.homenet> <20070530144449.36811a4d.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070530144449.36811a4d.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.30 14:44:49 +0200, Eric Dumazet wrote:
> On Wed, 30 May 2007 13:38:25 +0200
> Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> 
> > On 2007.05.30 00:38:08 +0200, Thomas Gleixner wrote:
> > > On Wed, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> > > > On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > > > > Hi,
> > > > >
> > > > > As the daystar sets, i try to play some with my new would be
> > > > > firewall/server, but since this will be running for quite some time i
> > > > > have been experimenting with powertop to find out what i can do to limit
> > > > > it's power usage.
> > > > >
> > > > > But, if i run powertop for too long or a few times to many... this
> > > > > happens:
> > > > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > > 
> > > This was reported before. It's incredibly hard to reproduce.
> > 
> > OK, second try, this time with a patch. In timer_stats_update_stats,
> > input is allocated on the stack, so it is uninitialized, in particular
> > the "next" field is random. Now in tstat_lookup, the new entry "curr" is
> > initialized with the values from "input" (passed as "entry") and "next"
> > is set to NULL _after_ it is added to the list, so if a second CPU is
> > running the fastpath lookup while we're inserting the new element, it
> > might get the garbage value in "next". The patch below fixes that.
> > 
> > Björn
> > 
> > 
> > 
> > Initialize the "next" field of a timer stats entry before it is inserted
> > into the list to avoid a race with the fastpath lookup.
> > 
> > Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> > ---
> > diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> > index 868f1bc..5bc8f91 100644
> > --- a/kernel/time/timer_stats.c
> > +++ b/kernel/time/timer_stats.c
> > @@ -202,12 +202,12 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
> >  	if (curr) {
> >  		*curr = *entry;
> >  		curr->count = 0;
> > +		curr->next = NULL;
> >  		memcpy(curr->comm, comm, TASK_COMM_LEN);
> >  		if (prev)
> >  			prev->next = curr;
> >  		else
> >  			*head = curr;
> > -		curr->next = NULL;
> >  	}
> >   out_unlock:
> >  	spin_unlock(&table_lock);
> > 
> 
> Your analysis might be right, not the fix.
> 
> You *cannot* assume curr->next = NULL will be done before insert.
> 
> You probably also need a memory barrier.

Ehrm, right. I somehow thought of the spinlock being enough to satisfy
that constraint, but if that was the case, the whole problem wouldn't
exist in the first place. D'oh!

Thanks,
Björn


Initialize the "next" field of a timer stats entry before it is inserted
into the list to avoid a race with the fastpath lookup.

Thanks to Eric Dumazet for reminding me of the memory barrier.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 868f1bc..ab0ba6c 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -202,12 +202,15 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 	if (curr) {
 		*curr = *entry;
 		curr->count = 0;
+		curr->next = NULL;
 		memcpy(curr->comm, comm, TASK_COMM_LEN);
+
+		smp_mb(); /* Ensure that curr is initialized before insert */
+
 		if (prev)
 			prev->next = curr;
 		else
 			*head = curr;
-		curr->next = NULL;
 	}
  out_unlock:
 	spin_unlock(&table_lock);
