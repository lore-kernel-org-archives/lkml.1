Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYHTQaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYHTQaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYHTQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:29:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46946 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYHTQ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:29:48 -0400
Subject: Re: [discuss] memrlimit - potential applications that can use
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <48ABD545.8010209@linux.vnet.ibm.com>
References: <48AA73B5.7010302@linux.vnet.ibm.com>
	 <1219161525.23641.125.camel@nimitz>  <48AAF8C0.1010806@linux.vnet.ibm.com>
	 <1219167669.23641.156.camel@nimitz>  <48ABD545.8010209@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Aug 2008 09:29:17 -0700
Message-Id: <1219249757.8960.22.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 13:56 +0530, Balbir Singh wrote:
> Dave Hansen wrote:
> > On Tue, 2008-08-19 at 22:15 +0530, Balbir Singh wrote:
> >> Dave Hansen wrote:
> >>> On Tue, 2008-08-19 at 12:48 +0530, Balbir Singh wrote:
> >>>> 1. To provide a soft landing mechanism for applications that exceed their memory
> >>>> limit. Currently in the memory resource controller, we swap and on failure OOM.
> >>>> 2. To provide a mechanism similar to memory overcommit for control groups.
> >>>> Overcommit has finer accounting, we just account for virtual address space usage.
> >>>> 3. Vserver will directly be able to port over on top of memrlimit (their address
> >>>> space limitation feature)
> >>> Balbir,
> >>>
> >>> This all seems like a little bit too much hand waving to me.  I don't
> >> Dave, there is no hand waving, just an honest discussion. Although, you may not
> >> see it in the background, we still need overcommit protection and we have it
> >> enabled by default for the system. There are applications that can deal with the
> >> constraints setup by the administrator and constraints of the environment,
> >> please see http://en.wikipedia.org/wiki/Autonomic_computing.
> > 
> > OK, let's get back to describing the basic problem here.  What is the
> > basic problem being solved?  Applications basically want to get a
> > failure back from malloc() when the machine is (nearly?) out of memory
> > so they can stop consuming?
> > 
> > Is this the only way to do autonomic computing with memory?  Or, are
> > there other or better approaches?
> > 
> Yes, an application does know it's memory footprint, but does it know how it is
> supposed to consume resources in the system. Consider a linear algebra package
> trying to do a multiplication of 1 million x 1 million rows. Depending on how
> much resources it is allowed to consume, it could do so in one shot or if there
> was a restriction, it could multiply smaller matrices and then collate results.
> The application wants to stretch itself (memory footprint) for performance, but
> at the same time does not want to get killed because
> 
> 1. Other applications came in and caused an OOM
> 2. It stretched itself too much beyond what the system can support

So, in (2) it deserves to be oom'd.

If other applications came in and caused the oom, then we do
have /proc/$pid/oom_adj to help out.  That's a much better tunable than
overcommit.

> >>> really see a single concrete user in the "potential applications" here.
> >>> I really don't understand why you're pushing this so hard if you don't
> >>> have anyone to actually use it.
> >>>
> >>> I just don't see anyone that *needs* it.  There's a lot of "it would be
> >>> nice", but no "needs".
> >> If you see the original email, I've sent - I've mentioned that we need
> >> overcommit support (either via memrlimit or by porting over the overcommit
> >> feature) and the exploiters you are looking for is the same as the ones who need
> >> overcommit and RLIMIT_AS support.
> >>
> >> On the memory overcommit front, please see PostgreSQL Server Administrator's
> >> Guide at
> >> http://www.network-theory.co.uk/docs/postgresql/vol3/LinuxMemoryOvercommit.html
> >>
> >> The guide discusses turning off memory overcommit so that the database is never
> >> OOM killed, how do we provide these guarantees for a particular control group?
> >> We can do it system wide, but ideally we want the control point to be per
> >> control group.
> > 
> > Heh.  That suggestion is, at best, working around a kernel bug.  The DB
> > guys are just saying to do that because they're the biggest memory users
> > and always seem to get OOM killed first.
> > 
> > The base problem here is the OOM killer, not an application that truly
> > uses memory overcommit restriction in an interesting way.
> > 
> 
> No it is not a kernel BUG, agreed that the database is using a lot of memory,
> but how can it predict what else will run on the system. Why is it bad for a
> database for the sake of data integrity to ensure that it does not get OOM
> killed and thus make sure memory is never overcommitted. Yes, you need
> performance, so the application expands it's footprint, but at the same time,
> the stretching should not cause it to be killed. How would you propose to solve
> the problem without overcommit control?

I think that we're tying OOM'ing and overcommit a little too close
together here.  It's not like you can't have OOMs when strict overcommit
is being observed.

There are lots of other ways to lock memory down, and any one of those
can also cause an oom.

Yes, userspace mapped memory is usually the largest single consumer, but
the problem space is well beyond overcommit control.  Agreed?  Just look
at why beancounters were implemented and track things far beyond
userspace memory use.  

> > So, before we expand the use of those features to control groups by
> > adding a bunch of new code, let's make sure that there will be users
> for
> > it and that those users have no better way of doing it.
> 
> I am all ears to better ways of doing it. Are you suggesting that overcommit was
> added even though we don't actually need it?

It serves a purpose, certainly.  We have have better ways of doing it
now, though.  "﻿So, before we expand the use of those features to
control groups by adding a bunch of new code, let's make sure that there
will be users for it and that those users have no better way of doing
it."

The one concrete user that's been offered so far is postgres.  I've
suggested something that I hope will be more effective than enforcing
overcommit.  

-- Dave

