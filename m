Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbXI3UGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbXI3UGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXI3UG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:06:27 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27555 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751821AbXI3UGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:06:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3kij3C2ManmWn9KSgacS10tjJg12mFTwpyqRpeH5RUDWFez3hbqi2g0uGMx7vV+O0bmXxNNKnU5BiYxfTDfI9XSgzSSb6gfJwhXt3jM5ZRs5eXPzQIOXZL55r2b2KOzaVVqG/uGfQoVRuMr60kmMJ8/ClUa22uOzWmgN0wM6nQY=  ;
X-YMail-OSG: e_Wp6qsVM1mSpAvG8Rix1BgeANN20s0bCAq2PbEKeOKgRLptxCAEL6e6qAEwNd1c262MhpmuGw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Sun, 30 Sep 2007 13:34:59 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200709300521.03356.nickpiggin@yahoo.com.au> <20070930110753.19b03388.pj@sgi.com>
In-Reply-To: <20070930110753.19b03388.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301335.00441.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 04:07, Paul Jackson wrote:
> Nick wrote:
> > The user should just be able to specify exactly the partitioning of
> > tasks required, and cpusets should ask the scheduler to do the best
> > job of load balancing possible.
>
> If the cpusets which have 'sched_load_balance' enabled are disjoint
> (their 'cpus' cpus_allowed masks don't overlap) then you get exactly
> what you're asking for.  In that case there is exactly one sched domain
> for the 'cpus' allowed by each cpuset that has sched_load_balanced
> enabled.

But you could do that just by having the current cpuset scheme able
to properly partition the system. You can't (easily) do this now because
you have so many tasks in the root cpuset that it is impossible to know
whether or not you actually want to load balance them.

You would do this by creating partitioning cpusets which carve up the
root cpuset (basically -- have multiple roots).


> But there is another case in which one does not want what you ask for.
>
> That case involves the situation where one is running a third part
> batch scheduler on part of ones big system, and doing other stuff
> (perhaps Ingo's realtime stuff) on another part of the system.

In this case the admin would simply not partition the system (they
would retain a single root cpuset).

Neither approach is really fundamentally more or less powerful than
the other, but what I object to in yours is adding these flags which
don't allow the admin to specify what they want, but to specify how they
want it done.

Moreover, sched_load_balance doesn't really sound like a good name
for asking for a partition. It's more like you're just asking to have better
load balancing over that set, which you could equally achieve by adding
a second set of sched domains (and the global domains could keep
globally balancing).

Basically: the admin doesn't know best when it comes to how the
scheduler should work; the admin knows best about how they intend
the system to be used.


> In that case, the system admin will be advised to turn off
> sched_load_balance on the top cpuset.  But in that case the system
> admin will -not- know from moment to moment what jobs the batch
> scheduler is running on the cpus assigned to its control.  Only the
> batch scheduler knows that.
>
> The batch scheduler is code that was written by someone else, in
> some other company, some other time.  That code does not get to
> control the overall sched domain partitioning of the entire system.
> The batch scheduler gets to say, in affect:
>
>   Here's where I need load balancing to occur, in the normal fashion,
>   and here's where I don't need it.

Rather than require the admin to know the intricate details about
how and why the scheduler load balancing gets broken, and when they
might or might not need to use this flag, they can just specify what they
want to be done, and the kernel can choose the optimal strategy.


> In short, you insisting that only a single administrative point of
> control determine the systems sched domains.  Sometimes that fits
> the way the system is managed, and my patch lets you do that.  But
> sometimes this is a shared responsibility, between a piece of third
> party software and the system admin, and my patch allows for that
> case as well.
>
> This is a typical sort of situation that arises from having hierarchical
> cpuset definitions, and highlights the reason (and the use case,
> involving third party batch schedulers) that I went with a hierarchical
> cpuset architecture in the first place.

No, I'm insisting that *no* single administrative point of control
determines the sched domains. Not directly. The kernel should.
cpusets API should be rich enough that the kernel can derive tihs
information from what the admin has intended.
