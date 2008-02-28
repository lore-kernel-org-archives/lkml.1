Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYB1Twm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYB1Twm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762102AbYB1Tna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:43:30 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48491 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060AbYB1Tn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:43:29 -0500
Date: Thu, 28 Feb 2008 11:43:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, fzu@wemgehoertderstaat.de, mingo@elte.hu,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: Re: [PATCH] Fix hibernate/resume in presence of PREEMPT_RCU and hotplug
Message-ID: <20080228194323.GI15409@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080228002110.GA20091@linux.vnet.ibm.com> <20080228050507.GA31289@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228050507.GA31289@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 10:35:08AM +0530, Gautham R Shenoy wrote:
> On Wed, Feb 27, 2008 at 04:21:10PM -0800, Paul E. McKenney wrote:
> > Hello!
> > 
> > This fixes a oops encountered when doing hibernate/resume in presence
> > of PREEMPT_RCU.  The problem was that the code failed to disable preemption
> > when accessing a per-CPU variable.  This is OK when called from code
> > that already has preemption disabled, but such is not the case from
> > the suspend/resume code path.
> 
> Well, rcu_offline_cpu() is called from the cpu-offline callback path, and
> AFAICS, it doesn't disable preemption.
> 
> I wonder how we're seeing this only now! Indeed a good catch!

I wonder as well.  In fact there is (at least) one other such bug,
submitting patch separately.  :-/

							Thanx, Paul

> Reviewed-by: Gautham R Shenoy <ego@in.ibm.com>
> 
> > 
> > Reported-by: Dave Young <hidave.darkstar@gmail.com>
> > Tested-by: Dave Young <hidave.darkstar@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  rcupreempt.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff -urpNa -X dontdiff linux-2.6.25-rc3/kernel/rcupreempt.c linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c
> > --- linux-2.6.25-rc3/kernel/rcupreempt.c	2008-02-26 16:58:43.000000000 -0800
> > +++ linux-2.6.25-rc3-rcuoffline/kernel/rcupreempt.c	2008-02-26 17:04:17.000000000 -0800
> > @@ -702,8 +702,9 @@ void rcu_offline_cpu(int cpu)
> >  	 * fix.
> >  	 */
> > 
> > +	local_irq_save(flags);
> >  	rdp = RCU_DATA_ME();
> > -	spin_lock_irqsave(&rdp->lock, flags);
> > +	spin_lock(&rdp->lock);
> >  	*rdp->nexttail = list;
> >  	if (list)
> >  		rdp->nexttail = tail;
> 
> -- 
> Thanks and Regards
> gautham
