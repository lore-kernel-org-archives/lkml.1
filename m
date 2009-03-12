Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZCLOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZCLOta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZCLOtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:49:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZCLOtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:49:19 -0400
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt
 tasks too
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com, hpa@zytor.com,
       dvhltc@us.ibm.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain>
References: <20090312075559.9856.28822.stgit@Aeon>
	 <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>
	 <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>
	 <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Mar 2009 15:48:34 +0100
Message-Id: <1236869314.22914.3697.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > ---
> > 
> > Subject: sched: adjust timer_slack_ns on scheduler policy change
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Thu Mar 12 15:01:02 CET 2009
> > 
> > Ensure RT tasks have 0 timer slack.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -5511,10 +5511,12 @@ __setscheduler(struct rq *rq, struct tas
> >  	case SCHED_NORMAL:
> >  	case SCHED_BATCH:
> >  	case SCHED_IDLE:
> > +		p->timer_slack_ns = p->default_timer_slack_ns;
> >  		p->sched_class = &fair_sched_class;
> >  		break;
> >  	case SCHED_FIFO:
> >  	case SCHED_RR:
> > +		p->timer_slack_ns = 0;
> >  		p->sched_class = &rt_sched_class;
> >  		break;
> >  	}
> > 

Looking at the default_timer_slack_ns stuff, do we want something like
the below?

---
diff --git a/kernel/sys.c b/kernel/sys.c
index 7306f94..6d8a84d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1811,11 +1811,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned
long, arg2, unsigned long, arg3,
 			error = current->timer_slack_ns;
 			break;
 		case PR_SET_TIMERSLACK:
-			if (arg2 <= 0)
+			if (arg2 <= 0) {
 				current->timer_slack_ns =
 					current->default_timer_slack_ns;
-			else
-				current->timer_slack_ns = arg2;
+			} else {
+				current->default_timer_slack_ns =
+					current->timer_slack_ns = arg2;
+			}
 			error = 0;
 			break;
 		default:

