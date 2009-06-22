Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZFVNuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZFVNuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbZFVNuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:50:02 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39655 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZFVNuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:50:00 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Andi Kleen <andi@firstfloor.org>,
       Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>
In-Reply-To: <4A3C8EAE.3030007@inria.fr>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <1245119132.6724.32.camel@lts-notebook>  <4A3C8EAE.3030007@inria.fr>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 22 Jun 2009 09:49:58 -0400
Message-Id: <1245678598.7799.29.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 09:24 +0200, Brice Goglin wrote:
> Lee Schermerhorn wrote:
> > My patches don't have per process enablement.  Rather, I chose to use
> > per cpuset enablement.  I view cpusets as sort of "numa control groups"
> > and thought this was an appropriate level at which to control this sort
> > of behavior--analogous to memory_spread_{page|slab}.  That probably
> > needs to be discussed more widely, tho'.
> >   
> 
> Could you explain why you actually want to enable/disable
> migrate-on-fault on a cpuset (or process) basis? Why would an
> administrator want to disable it? Aren't the existing cpuset memory
> restriction abilities enough?
> 
> Brice
> 

Hello, Brice:

There are a couple of aspects to this question, I think?

1) why enable/disable at all?  why not always enabled?  

When I try out some new behavior such as migrate of fault, I start with
the assumption [right or wrong] that not all users will want this
behavior.  For migrate-on-fault, one probably won't run into it all that
often unless the MPOL_MF_LAZY flag is used to forcibly unmap regions.
However, with swap read-ahead, one could end up with anon pages in the
swap cache with no pte references, and could experience unexpected
migrations.  I've learned that some folks really don't like
surprises :).  Now, when you consider the "automigration" feature
["auto" here means "self" more than "automatic"], I think it's more
important to be able to enable/disable it.  I've not seen any
performance degradation when using it, but I feared that for some
workloads, thrashing could cause such degradation.  Page migration isn't
free.

Also, because Linux runs on such a wide range of platforms, I don't want
to burden smaller, embedded systems with the additional code, so I also
try to make the feature source configurable.  I know we worry about the
proliferation of config options, but it's easier to remove one after the
fact, I think, than to retrofit it.

2) Why a per cpuset control?

I consider cpusets to be "numa control groups".  They constrain
resources on a numa node [and related cpus] granularity, and control
numa related behavior, such as migration when changing cpusets,
spreading page cache and slab pages over nodes in the cpuset, ...  In
fact, I think it would have been appropriate to call the cpuset control
group the "numa control group" when cgroups were introduced, but it's
too late for that now.

Finally, and not a reason to include the controls in the mainline, it's
REALLY useful during development.  One can boot a test kernel, and only
enable the feature in a test cpuset, limiting the damage of, e.g., a
reference counting bug or such.  It's also useful for measuring the
overhead of the patches absent any actual page migrations.  However, if
this feature ever makes it to mainline, the community will have its say
on whether these controls should be included and how.

Hope this helps,
Lee



