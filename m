Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYCJWEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYCJWEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCJWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:04:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbYCJWEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:04:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] keep rd->online and cpu_online_map in sync
Date: Mon, 10 Mar 2008 23:03:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Gregory Haskins <ghaskins@novell.com>, ego@in.ibm.com,
       akpm@linux-foundation.org, dmitry.adamushko@gmail.com, mingo@elte.hu,
       oleg@sign.ru, yi.y.yang@intel.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <20080310081425.GA11031@in.ibm.com> <20080310133755.4689.83217.stgit@novell1.haskins.net> <20080310181244.GA27329@linux-os.sc.intel.com>
In-Reply-To: <20080310181244.GA27329@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102303.28660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of March 2008, Suresh Siddha wrote:
> On Mon, Mar 10, 2008 at 09:39:34AM -0400, Gregory Haskins wrote:
> > keep rd->online and cpu_online_map in sync
> > 
> > It is possible to allow the root-domain cache of online cpus to
> > become out of sync with the global cpu_online_map.  This is because we
> > currently trigger removal of cpus too early in the notifier chain.
> > Other DOWN_PREPARE handlers may in fact run and reconfigure the
> > root-domain topology, thereby stomping on our own offline handling.
> > 
> > The end result is that rd->online may become out of sync with
> > cpu_online_map, which results in potential task misrouting.
> > 
> > So change the offline handling to be more tightly coupled with the
> > global offline process by triggering on CPU_DYING intead of
> > CPU_DOWN_PREPARE.
> > 
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> > ---
> > 
> >  kernel/sched.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 52b9867..a616fa1 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5881,7 +5881,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		spin_unlock_irq(&rq->lock);
> >  		break;
> >  
> > -	case CPU_DOWN_PREPARE:
> > +	case CPU_DYING:
> 
> Don't we need to take care of CPU_DYING_FROZEN aswell?

Well, I'd say we do.

> >  		/* Update our root-domain */
> >  		rq = cpu_rq(cpu);
> >  		spin_lock_irqsave(&rq->lock, flags);
> > 
