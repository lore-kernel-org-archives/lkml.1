Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXJCJ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXJCJ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXJCJ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:58:46 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35293 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753614AbXJCJ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:58:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ltV8RwN61nu9GIkaDPIDiX5FEeUUNQldlXhq32FcuqsYGVzArJEnpVifMKiFFeiUcz7fUC5sNH+LoihDVq94LkziERKMYofsHtpe/pJCkYDFr2qaiTDr6+hecEH94YioDEII6ak9XSxUk9rUaNu1G2NNbNaARkI0uU05r9ZR6Tw=  ;
X-YMail-OSG: o2oQuG0VM1mdHpjkkFgGlZ8VdRrVO196C7z1eHzwbAUUvmYlNbboK0IbORxOhiftVrau9Nwr3g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Date: Wed, 3 Oct 2007 03:23:42 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710030146.30162.nickpiggin@yahoo.com.au> <20071003022108.5a8e310e.pj@sgi.com>
In-Reply-To: <20071003022108.5a8e310e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030323.42454.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 19:21, Paul Jackson wrote:
> Nick wrote:
> > Sorry for the confusion: I only meant the sched.c part of that
> > patch, not the full thing.
>
> Ah - ok.  We're getting closer then.  Good.
>
> Let me be sure I've got this right then.
>
> You prefer the interface from your proposed patch, by which the
> cpuset code passes sched domain requests to the scheduler code a single
> cpumask that will define a sched domain:
>
>     int partition_sched_domains(cpumask_t *partition)
>
> and I am suggesting instead a new and different interface:

Yep.

>
>     void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
>
> In the first API, one cpumask is passed in, and a single sched
> domain is formed, taking those CPUs from any sched domain they
> might have already been a member of, into this new sched domain.
>
> In the second API, the entire flat partitioning is passed in,
> giving an array of masks, one mask for each desired sched domain.
> The passed in masks do not overlap, but might not cover all CPUs.
>
> Question -- how does one turn off load balancing on some CPUs
> using the first API?
>
>     Does one do this by forming singleton sched domains of one
>     CPU each?  Is there any downside to doing this?

Yes, and no (it does the same thing as your version internally, so
no downside).


>     The simplest cpuset code to work with this would end up exposing
>     this method of disabling load balancing to user space, forcing
>     users to create cpusets with one CPU each to be able do disable
>     load balancing.
>
>     However a little bit of additional kernel cpuset code could hide
>     this detail from user space, by recognizing when the user had
>     asked to turn off load balancing on some larger cpuset, and by
>     then calling partition_sched_domains() multiple times, once for
>     each CPU in that cpuset.

Yeah: do all that in cpusets. It's already information you would have
to derive in order to make it work properly anyway. If you are not
passing in the singleton domains ATM, then they will not get properly
detached and isolated.


> There might be an even simpler way.  If the kernel/sched.c routines
> detach_destroy_domains() and build_sched_domains() were exposed as
> external routines, then the cpuset code could call them directly,
> removing the partition_sched_domains() routine from sched.c entirely.
> Would this be worth persuing?

detach_destroy and build are things that may get reimplemented to
suit different capabilities (eg. we might want to have multiple trees of
domains for each CPU). So I think it is important to expose the simple
partition API which should be unambiguous and stable.

It's not a huge deal, but I'd like to keep partition_sched_domains. After
my patch, it's really simple.

