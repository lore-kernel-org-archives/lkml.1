Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYF3JRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYF3JRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYF3JRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:17:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYF3JRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:17:35 -0400
Date: Mon, 30 Jun 2008 11:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080630091711.GA26637@elte.hu>
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com> <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Sun, Jun 29, 2008 at 12:16:56AM +0200, Dmitry Adamushko wrote:
> > Hello,
> > 
> > 
> > it seems to be related to migrate_dead_tasks().
> > 
> > Firstly I added traces to see all tasks being migrated with
> > migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem
> > pops up (the one with "se == NULL" in the loop of
> > pick_next_task_fair()) shortly after the traces indicate that some has
> > been migrated with migrate_dead_tasks()). btw., I can reproduce it
> > much faster now with just a plain cpu down/up loop.
> > 
> > [disclaimer] Well, unless I'm really missing something important in
> > this late hour [/desclaimer] pick_next_task() is not something
> > appropriate for migrate_dead_tasks() :-)
> > 
> > the following change seems to eliminate the problem on my setup
> > (although, I kept it running only for a few minutes to get a few
> > messages indicating migrate_dead_tasks() does move tasks and the
> > system is still ok)
> > 
> > [ quick hack ]
> > 
> > @@ -5887,6 +5907,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
> >                 next = pick_next_task(rq, rq->curr);
> >                 if (!next)
> >                         break;
> > +               next->sched_class->put_prev_task(rq, next);
> >                 migrate_dead(dead_cpu, next);
> > 
> >         }
> 
> Thanks Dmitry! With your patch I cannot reproduce the bug anymore.

thanks - it passed my testing too. It's lined up for v2.6.26 merge, in 
tip/sched/urgent.

Avi, does this patch fix your CPU hotplug problems too?

	Ingo
