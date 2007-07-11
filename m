Return-Path: <linux-kernel-owner+w=401wt.eu-S1764337AbXGKNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764337AbXGKNEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbXGKNEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:04:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37794 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbXGKNEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:04:44 -0400
Date: Wed, 11 Jul 2007 18:44:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       menage@google.com, mingo@elte.hu
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711131405.GB31130@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org> <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com> <20070711100323.GA23473@linux.vnet.ibm.com> <20070711041007.10ad759c.pj@sgi.com> <1184153087.20032.8.camel@twins> <1184153440.20032.14.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184153440.20032.14.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 01:30:40PM +0200, Peter Zijlstra wrote:
> > One thing to think on though, we cannot have per process,uid,gid,pgrp
> > scheduling for one release only. So we'd have to manage interaction with
> > process containers. It might be that a simple weight multiplication
> > scheme is good enough:
> > 
> >   weight = uid_weight * pgrp_weight * container_weight

We would need something like this to flatten hierarchy, so that for
example it is possible to do fair-container scheduling +
fair-user/process scheduling inside a container using a hierarchy depth of 
just 1 (containers) that core scheduler understands. We discussed this a bit at
http://marc.info/?l=linux-kernel&m=118054481416140&w=2 and is very much
on my todo list to experiment with.

> > Of course, if we'd only have a single level group scheduler (as was
> > proposed IIRC) it'd have to create intersection sets (as there might be
> > non trivial overlaps) based on these various weights and schedule these
> > resulting sets instead of the initial groupings.
> 
> Lets illustrate with some ASCII art:
> 
> so we have this dual level weight grouping (uid, container)
> 
> uid:          a a a a a b b b b b c c c c c
> container:    A A A A A A A B B B B B B B B
> 
> set:          1 1 1 1 1 2 2 3 3 3 4 4 4 4 4 
> 
> resulting in schedule sets 1,2,3,4

Wouldn't it be simpler if admin created these sets as containers
directly? i.e:


uid:          a a a a a b b b b b c c c c c
container:    1 1 1 1 1 2 2 3 3 3 4 4 4 4 4

That way scheduler will not have to "guess" such intersecting schedulable
sets/groups. It seems much simpler to me this way.

Surely there is some policy which is driving some tasks of userid 
'b' to be in container A and some to be in B. It should be trivial
enough to hook onto that policy making script and create separate
containers like above.

> so that (for instance) weight_2 = weight_b * weight_A



-- 
Regards,
vatsa
