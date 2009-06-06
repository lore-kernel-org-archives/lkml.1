Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZFFXiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZFFXiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZFFXiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:38:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44381 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZFFXiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:38:02 -0400
Date: Sat, 6 Jun 2009 16:37:59 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "travis@sgi.com" <travis@sgi.com>, "steiner@sgi.com" <steiner@sgi.com>,
       "lcm@us.ibm.com" <lcm@us.ibm.com>
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
	interrupt-remapping
Message-ID: <20090606233758.GA9565@us.ibm.com>
References: <1244141989.27006.10369.camel@localhost.localdomain> <m1iqjbd243.fsf@fess.ebiederm.org> <1244164694.27006.10374.camel@localhost.localdomain> <20090605222004.GE7514@us.ibm.com> <1244249849.27006.10515.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244249849.27006.10515.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:57:29PM -0700, Suresh Siddha wrote:
> On Fri, 2009-06-05 at 15:20 -0700, Gary Hade wrote:
> > On Thu, Jun 04, 2009 at 06:18:14PM -0700, Suresh Siddha wrote:
> > > On Thu, 2009-06-04 at 16:13 -0700, Eric W. Biederman wrote:
> > > > Suresh Siddha <suresh.b.siddha@intel.com> writes:
> > > > 
> > > > > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > > > > Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
> > > > >
> > > > > In the presence of interrupt-remapping, irqs will be migrated in the
> > > > > process context and we don't do (and there is no need to) irq_chip mask/unmask
> > > > > while migrating the interrupt.
> > > > >
> > > > > Similarly fix the fixup_irqs() that get called during cpu offline and avoid
> > > > > calling irq_chip mask/unmask for irqs that are ok to be migrated in the
> > > > > process context.
> > > > >
> > > > > While we didn't observe any race condition with the existing code,
> > > > > this change takes complete advantage of interrupt-remapping in
> > > > > the newer generation platforms and avoids any potential HW lockup's
> > > > > (that often worry Eric :)
> > > > 
> > > > You now apparently fail to migrate the irq threads in tandem with
> > > > the rest of the irqs.
> > > 
> > > Eric, Are you referring to Gary's issues? As far as I understand, they
> > > don't happen in the presence of interrupt-remapping.
> > 
> > Suresh,
> > We do not currently have the h/w on which to test this assertion
> > but it seems like there is a good chance that at least the race that
> >   http://lkml.org/lkml/2009/6/2/377
> > fixes could reproduce there.
> 
> No. In the presence of interrupt-remapping, migration of the irq will be
> done atomically from the process context. So we don't depend for the
> next interrupt to arrive for the migration.

Thats good.

> 
> In the particular case that you mentioned above, we are calling the
> send_cleanup_vector() from the set_affinity() itself in case of
> interrupt-remapping. And this will reset the cfg->move_in_progress.

Now that you mention this, I do remember seeing those send_cleanup()
calls in ir_set_msi_irq_affinity() and migrate_ioapic_irq_desc().
Much better than having to depend on the IRQ move destination CPU,
especially when correct behavior depends on it's timely receipt
of an interrupt.

> 
> But I agree that this bug is pretty nasty for non interrupt-remapping
> cases and we are very lucky so far for not hitting it with all the
> irqbalance changes and with suspend/resume code path.

Yes, _very_ nasty.  It was extremely easy for me to initially
reproduce the problem so I have also been wondering why others
have been so lucky.  The first time I saw the problem was after
the first run of a simple script similar to the below script
that I had just written to do a quick-and-dirty CPU hotplug
sanity check.  I then started seeing file i/o plus sas and aic94xx
device driver errors and found myself with a very trashed system.
Not good!

::::::::::::::
cpus_offline_all.sh
::::::::::::::
#!/bin/sh

##
#  Offline all offlineable CPUs
##

SYS_CPU_DIR=/sys/devices/system/cpu

for d in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
    cpu="`basename $d`"
    state=`cat $d/online`
    if [ "$state" = 1 ]; then
        echo $cpu: offlining
        echo 0 > $d/online
    else
        echo $cpu: already offline
    fi
done

> 
> While I agree with your online fix,

Thats encouraging. :)

> I have to catch up with Eric's concerns.
> 
> > 
> > The other problem that is repaired by
> >   http://lkml.org/lkml/2009/6/2/378
> 
> oh! This one is the famous Eric's rant about broken fixup_irqs() in the
> presence of non interrupt-remapping.
> 
> Long time back I have proposed a solution to Eric to resolve this for
> non interrupt-remapping cases but don't think I never addressed that.
> Again let me catch up with Eric's comments and see if we can comeup with
> a solution that is acceptable to everyone. 
> 
> > depends on the i/o redirection table write with remote IRR bit
> > set lockup anomaly that the interrupt-remapping code may avoid
> > or perhaps is not even present with that h/w.  My proposed fix
> > for the problem is based on previous interrupt-remapping code
> > that you recently removed with
> >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0280f7c416c652a2fd95d166f52b199ae61122c0
> 
> I cleaned up my code for a reason (that I never liked it and is
> complex).

That delay code may look a little complex but it sure seems
to do a nice job.  Based on my testing it certainly feels
solid from a functional standpoint.

> So I would def recommend not to go down that path.

Since it has been working so great for us, I am sorry
to hear you say this.  However, I am open to any ideas you
have that would maintain the current user interface and would
simple and non-intrusive enough for our distribution partners
to feel comfortable adding via an update an existing release.
It would be nice to get this kind of fix into mainline as
quickly as possible to prevent further propagation of the bug
before a better but more disruptive overall solution, such as
the one that Eric has been pushing for, is available.

BTW, this one has been much harder to reproduce than the
other issue so I am not nearly as surprised that others have
not reported it.  I tripped on it after fixing the other issue
and deciding that it might be a good idea to crank up the
interrupt rate while testing the fix.

I am actually at work today because I had some ideas on how
to revise this patch to address Eric's most recent concerns
about the IMHO minor, yet still very worrysome to Eric, changes
it makes to the interrupt context migration path.  Since it
sounds like you have concerns beyond it not touching the
interrupt context migration path, I guess I will hold off on
this work until you have a chance to look at the issue next week.

> 
> This second issue also doesn't happen with interrupt-remapping, as we avoid
> touching the io-apic RTE's and use a virtual vector in the RTE
> (which is same irrespective of the destination).
> 
> Will work with you next week in coming up with clean fixes.

Thanks.  I really appreciate this.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

