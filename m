Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXJCFhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXJCFhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXJCFg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:36:58 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:46624 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751259AbXJCFg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:36:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LzZwyYWgedqRkLW+tTOYvT2spYN0dozUAqPAEPT5Nnv/qo6ibPnHJV3jcpEDxsdR3M4MIoUNTM6hIdEXLb4DKQ1eOF7wWARFMyiEOqZAfqd3KF0cYN6Mi6DTFUd09jjg7SojLrgZQujNPjEZclMR71ZDqtZ0/Md0ptt6SuCf0Eg=  ;
X-YMail-OSG: EUsZrJ4VM1nAX.lAFoF3KYBW.4Mew0oulLRHMtqfypqBzahFfbzKAczQuxJFlK90f2esVhhncg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Tue, 2 Oct 2007 23:05:23 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200709301335.00441.nickpiggin@yahoo.com.au> <20070930204252.45e20bb4.pj@sgi.com>
In-Reply-To: <20070930204252.45e20bb4.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022305.23713.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 13:42, Paul Jackson wrote:
> Nick wrote:
> > Moreover, sched_load_balance doesn't really sound like a good name
> > for asking for a partition.
>
> Yup - it's not a good name for asking for a partition.
>
> That's because it isn't asking for a partition.
>
> It's asking for load balancing over the CPUs in the cpuset so marked.

Yeah yeah OK, you turn it off in the parent cpuset of the child cpusets
which you want the partitioning to occur in, and ensure there are no
other overlapping cpusets with that flag turned on in order to create a
hard partition. I don't think this makes the API anynicer.


> > It's more like you're just asking to have better
> > load balancing over that set,
>
> Yup - it's asking for load balancing over that set.  That is why it is
> called that.  There's no idea here of better or worse load balancing,
> that's an internal kernel scheduler subtlety -- it's just a request that
> load balancing be done.

OK, if it prohibits balancing when sched_load_balance is 0, then it is
slightly more useful.


> That is what is visible to user space: whether or not tasks get moved
> from overloaded CPUs to underloaded, though still allowed, CPUs.
>
> This is visible to user space in two ways:
>   1) as task movemement, which may or may not be what is desired, and
>   2) as kernel CPU cycles spent, because load balancing costs CPU cycles
>      that increase more than linearly with the number of CPUs being
>      balanced.
>
> The user doesn't give a hoot what a 'sched domain' is.  They care to
> manage (1) whether their tasks might move under a load imbalance, and
> (2) how many CPU cycles the kernel spends providing this service.

Yeah, but the interface is not very nice. As an interface for hard
partitioning, it doesn't work nicely because it is hierarchical.


> > You would do this by creating partitioning cpusets which carve up the
> > root cpuset (basically -- have multiple roots).
>
> You would do this with the current, single rooted cpuset (and now
> cgroup) mechanism by having multiple immediate child cpusets of the
> root cpuset, which partition the system CPUs.  There is no need to
> invent some bastardized multiple root structure.

What do you mean by bastardized? What's wrong with having a real
(and sane) representation of the requested hard-partitions in the system?


> > You can't (easily) do this now because you have so many tasks in the
> > root cpuset that it is impossible to know whether or not you
> > actually want to load balance them.
>
> I don't know what proposal you are reacting to here.  Clearly not this
> patch that I have proposed, as it is trivially easy to indicate whether
> you want to load balance the root cpuset - by setting or clearing the
> 'sched_load_balance' flag in the root cpuset.

Not your proposal, just the idea to have enough information to be able
to work out a more optimal set of sched-domains automatically. Actually
we can do most of it already automatically, but not hard partitioning.

[snip]

As I said, neither is really semantically more powerful than the other. So
yeah those things are possible to do with your API, but I don't like the API.
