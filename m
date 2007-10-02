Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbXJCIuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbXJCIuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXJCIuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:50:15 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:21277 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751123AbXJCIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:50:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vKmmZQENZ7LKMx0krQCcvQ0+8TyDjipBF8c50V7LARqhVCICj1AF8GGHqWrsqYae4ZtldYc7IhLmiRGJpA7LMLpjQCyZczX8R2pT76O6Pps6aweBoc6rwwLgO5aTHtRcKmrp26DdIIWxkoH3DZ8dwd6eeaCReiCjArxY0ULYOzA=  ;
X-YMail-OSG: K3zUXVUVM1lc7dc4PhYgHIgyzjFedN1InK.KU1LGwsO40xBQZGWDIhWdkyd7rk7UJdSuE9alEQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 02:09:56 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710022305.23713.nickpiggin@yahoo.com.au> <20071002235849.56dbe9fb.pj@sgi.com>
In-Reply-To: <20071002235849.56dbe9fb.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030209.56879.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 16:58, Paul Jackson wrote:
> > > Yup - it's asking for load balancing over that set.  That is why it is
> > > called that.  There's no idea here of better or worse load balancing,
> > > that's an internal kernel scheduler subtlety -- it's just a request
> > > that load balancing be done.
> >
> > OK, if it prohibits balancing when sched_load_balance is 0, then it is
> > slightly more useful.
>
> It doesn't prohibit load balancing just because sched_load_balance is 0.
> Only if there are no overlapping cpusets still needing balancing does it
> prohibit balancing when 0.

Yeah, that's what I mean. Important point: prohibits, rather than
better/worse.


> > Yeah, but the interface is not very nice. As an interface for hard
> > partitioning, it doesn't work nicely because it is hierarchical.
>
> Yeah -- cpusets are hierarchical.  And some of the use cases for
> which cpusets are designed are hierarchical.

But partitioning isn't.


> > > > You would do this by creating partitioning cpusets which carve up the
> > > > root cpuset (basically -- have multiple roots).
> > >
> > > You would do this with the current, single rooted cpuset (and now
> > > cgroup) mechanism by having multiple immediate child cpusets of the
> > > root cpuset, which partition the system CPUs.  There is no need to
> > > invent some bastardized multiple root structure.
> >
> > What do you mean by bastardized?
>
> Changing cpusets from single root to multiple roots would be
> bastardizing it.

Well OK, if that's your definition. Not very helpful though.

Can I win this argument by defining sched_load_balance
to crapify it? :)


> My proposed sched_load_balance API is already quite capable of
> representing what you see the need for - hard partitioning.  It is also
> quite capable of representing some other situations, such as I've
> described in other replies, that you don't seem to see the need for.
>
> To repeat myself, in some cases, such as batch schedulers running in a
> subset of the CPUs on a large system, the code that knows some of the
> needs for load balancing does not have system wide control to mandate
> hard partitioning.  The batch scheduler can state where it is depending
> on load balancing being present, and the system administrator can choose
> or not to turn off load balancing in the top cpuset, thereby granting or
> not control over load balancing on the CPUs controlled by the batch
> scheduler to the batch scheduler.

Why isn't that possible with my approach?


> Hard partitioning is not the only use case here.
>
> If you don't appreciate the other cases, then fine ... but I don't think
> that gives you grounds to reject a patch just because it is not precisely
> the ideal, narrowly focused, API for the case you do appreciate.

What happens when you partition the system with your approach, and
you get kernel threads being spawned into the root cpuset and getting
unbalanced?

With my approach, these can get naturally balanced.


> >  What's wrong with having a real
> > (and sane) representation of the requested hard-partitions in the system?
>
> What's wrong with it is that 1) it doesn't cover all the use cases,

OK, you haven't explained why not.


> 2) it would require a new and different mechanism other than cpusets
> which are not multiple rooted, and do robustly support overlapping
> sets and hence are not a hard partitioning, and

Obviously any approach cannot retain the existing kernel API, true.


> 3) we'd still need 
> the cpuset based API to cover the remaining use cases.

I just still don't understand how those cases work... if you can spell it
out for me.


> Good grief -- I must be misunderstanding you here, Nick.  I can't
> imagine that you want to turn cpusets into a multiple rooted hard
> partition mechanism.  If you are, then "bastardized" is the right word.
>
> > Not your proposal, just the idea to have enough information to be able
> > to work out a more optimal set of sched-domains automatically.
>
> I can't figure out what the sentence is saying ... sorry.

You said:
> I don't know what proposal you are reacting to here.  Clearly not this
> patch that I have proposed, as it is trivially easy to indicate whether
> you want to load balance the root cpuset - by setting or clearing the
> 'sched_load_balance' flag in the root cpuset.

The above sentence was explaining which proposal I was talking
about.
