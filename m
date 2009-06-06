Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZFFBAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZFFBAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 21:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZFFA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:59:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:19517 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZFFA7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:59:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,313,1241420400"; 
   d="scan'208";a="151277899"
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
 interrupt-remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Gary Hade <garyhade@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "travis@sgi.com" <travis@sgi.com>, "steiner@sgi.com" <steiner@sgi.com>,
       "lcm@us.ibm.com" <lcm@us.ibm.com>
In-Reply-To: <20090605222004.GE7514@us.ibm.com>
References: <1244141989.27006.10369.camel@localhost.localdomain>
	 <m1iqjbd243.fsf@fess.ebiederm.org>
	 <1244164694.27006.10374.camel@localhost.localdomain>
	 <20090605222004.GE7514@us.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 05 Jun 2009 17:57:29 -0700
Message-Id: <1244249849.27006.10515.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 15:20 -0700, Gary Hade wrote:
> On Thu, Jun 04, 2009 at 06:18:14PM -0700, Suresh Siddha wrote:
> > On Thu, 2009-06-04 at 16:13 -0700, Eric W. Biederman wrote:
> > > Suresh Siddha <suresh.b.siddha@intel.com> writes:
> > > 
> > > > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > > > Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
> > > >
> > > > In the presence of interrupt-remapping, irqs will be migrated in the
> > > > process context and we don't do (and there is no need to) irq_chip mask/unmask
> > > > while migrating the interrupt.
> > > >
> > > > Similarly fix the fixup_irqs() that get called during cpu offline and avoid
> > > > calling irq_chip mask/unmask for irqs that are ok to be migrated in the
> > > > process context.
> > > >
> > > > While we didn't observe any race condition with the existing code,
> > > > this change takes complete advantage of interrupt-remapping in
> > > > the newer generation platforms and avoids any potential HW lockup's
> > > > (that often worry Eric :)
> > > 
> > > You now apparently fail to migrate the irq threads in tandem with
> > > the rest of the irqs.
> > 
> > Eric, Are you referring to Gary's issues? As far as I understand, they
> > don't happen in the presence of interrupt-remapping.
> 
> Suresh,
> We do not currently have the h/w on which to test this assertion
> but it seems like there is a good chance that at least the race that
>   http://lkml.org/lkml/2009/6/2/377
> fixes could reproduce there.

No. In the presence of interrupt-remapping, migration of the irq will be
done atomically from the process context. So we don't depend for the
next interrupt to arrive for the migration.

In the particular case that you mentioned above, we are calling the
send_cleanup_vector() from the set_affinity() itself in case of
interrupt-remapping. And this will reset the cfg->move_in_progress.

But I agree that this bug is pretty nasty for non interrupt-remapping
cases and we are very lucky so far for not hitting it with all the
irqbalance changes and with suspend/resume code path.

While I agree with your online fix, I have to catch up with Eric's
concerns.

> 
> The other problem that is repaired by
>   http://lkml.org/lkml/2009/6/2/378

oh! This one is the famous Eric's rant about broken fixup_irqs() in the
presence of non interrupt-remapping.

Long time back I have proposed a solution to Eric to resolve this for
non interrupt-remapping cases but don't think I never addressed that.
Again let me catch up with Eric's comments and see if we can comeup with
a solution that is acceptable to everyone. 

> depends on the i/o redirection table write with remote IRR bit
> set lockup anomaly that the interrupt-remapping code may avoid
> or perhaps is not even present with that h/w.  My proposed fix
> for the problem is based on previous interrupt-remapping code
> that you recently removed with
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0280f7c416c652a2fd95d166f52b199ae61122c0

I cleaned up my code for a reason (that I never liked it and is
complex). So I would def recommend not to go down that path.

This second issue also doesn't happen with interrupt-remapping, as we avoid
touching the io-apic RTE's and use a virtual vector in the RTE
(which is same irrespective of the destination).

Will work with you next week in coming up with clean fixes.

thanks,
suresh

