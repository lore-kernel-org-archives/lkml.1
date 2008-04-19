Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbYDSX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbYDSX2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYDSX2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:28:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55285 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYDSX2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:28:16 -0400
Date: Sat, 19 Apr 2008 16:28:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
Message-ID: <20080419232812.GF20138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080411161702.460410000@bull.net> <1207931235.7157.0.camel@twins> <4802E93E.4090205@bull.net> <1208157359.7427.25.camel@twins> <480316D3.7070901@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480316D3.7070901@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:33:23AM +0200, Nadia Derbey wrote:
> Peter Zijlstra wrote:
> >On Mon, 2008-04-14 at 07:18 +0200, Nadia Derbey wrote:
> >
> >>Peter Zijlstra wrote:
> >>
> >>>On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
> >>>
> >>>
> >>>>Here is finally the ipc ridr-based implementation I was talking about 
> >>>>last
> >>>>week (see http://lkml.org/lkml/2008/4/4/208).
> >>>>I couldn't avoid much of the code duplication, but at least made things
> >>>>incremental.
> >>>>
> >>>>Does somebody now a test suite that exists for the idr API, that I could
> >>>>run on this new api?
> >>>>
> >>>>Mike, can you try to run it on your victim: I had such a hard time 
> >>>>building
> >>>>this patch, that I couldn't re-run the test on my 8-core with this new
> >>>>version. So the last results I have are for 2.6.25-rc3-mm1.
> >>>>
> >>>>Also, I think a careful review should be done to avoid introducing yet 
> >>>>other
> >>>>problems :-(
> >>>
> >>>
> >>>Why duplicate the whole thing, when we converted the Radix tree to be
> >>>RCU safe we did it in-place. Is there a reason this is not done for idr?
> >>>
> >>>
> >>>
> >>
> >>I did that because I wanted to go fast and try to fix the performance 
> >>problem we have with sysV ipc's. I didn't want to introduce (yet other) 
> >>regressions in the code that uses idr's today and that works well ;-)
> >>May be in the future if this rcu based api appears to be ok, we can 
> >>replace one with the other?
> >
> >
> >>From what I can see the API doesn't change at all,
> 
> Well, 1 interface changes, 1 is added and another one went away:
> 
> 1) for the preload part (it becomes like the radix-tree preload part):
> 
> int idr_pre_get(struct idr *, gfp_t);
> would become
> int idr_pre_get(gfp_t);
> 
> 2) idr_pre_get_end() is added (same as radix_tree_preload_end()).
> 
> 3) The idr_init() disappears.
> 
> You might see that other interfaces are not provided by ridr, but this 
> is only because I've taken those that are useful for the ipc part (so 
> should not be a problem to make the whole thing rcu safe).

Part of this is because you need to allow the caller to choose the
locking for updates.  Mightn't it be better to have both styles of
API, and share the bit-twiddling and tree-walking code?

> >so I don't see why
> >you need to duplicate - either the new code works as expected or its
> >broken.
> 
> That's why I asked for an "IDR test suite": I wanted to test potential 
> regressions.

That would be good -- certainly the #ifdef TEST leads one to believe
that such a test suite existed at some time.  ;-)

							Thanx, Paul

> >If it works its good enough for all IDR users, if its broken we
> >should fix it. Seems simple enough.. am I missing something obvious?
> >
> 
> Regards,
> Nadia
> 
> 
> 
> 
