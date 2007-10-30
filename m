Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbXJ3XNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbXJ3XNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXJ3XNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:13:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbXJ3XNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:13:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ZMl9n8wJrG6c5WfWScRxfcRq1RwmHwwKFSSFT7O+7ONPZd5oLenTURFCTuiXKwEw/
	wnukKtdZ/wAR1oJ1iAqkw==
Date: Tue, 30 Oct 2007 16:12:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071029001554.c12b6b6c.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710301607430.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
 <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com> <20071026194144.6042316a.pj@sgi.com>
 <alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com> <20071027161955.e9d4d2db.pj@sgi.com> <alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com> <20071028164637.8d1b45b0.pj@sgi.com> <alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
 <20071028212745.57a7db67.pj@sgi.com> <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com> <20071029001554.c12b6b6c.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Paul Jackson wrote:

> Blind siding users with a unilateral change like this will leave
> orphaned bits gasping in agony on the computer room floor.  It can
> sometimes takes months of elapsed time and hundreds of hours of various
> peoples time across a dozen departments in three to five corporations
> to track down the root cause of such a problem, from the point of the
> initial failure, back to the desk of someone like you or me.  And then
> it can take tens or hundreds more hours of human effort to deliver a
> fix.  I refuse to knowingly go down that road.
> 

If your argument is that most applications are written to implement 
mempolicies without necessarily thinking too much about its cpuset 
placement or interactions with cpusets, then the requirement of remapping 
nodes when a cpuset changes for effected mempolicies isn't actually that 
important.  In other words, my Choice C with AND'd behavior as opposed to 
remapping behavior could be introduced as a replacement for Choice A.

Those applications that currently rely on the remapping are going to be 
broken anyway because they are unknowingly receiving different nodes than 
they intended, this is the objection to remapping that Lee agreed with.  
The remap doesn't take into account any notion of locality or affinity to 
physical controllers and seems to be merely a convenience of not 
invalidating the entire mempolicy in light of an ever-changing cpuset 
policy.

> Not "AND".  Fold - the n-th bit is set in a tasks mems_allowed iff
> there exists m such that (m % w) == n, and such that the m-th bit is
> set in the tasks mempolicy's remembered nodemask, where w is the weight
> (number of '1' bits) in the tasks current cpusets mems_allowed. See
> lib/bitmap.c:bitmap_remap(), and its wrapper nodes_remap() for the
> implementation.
> 

Yes, I know, and my Choice C does _not_ want that folding behavior; it 
wants the AND'd behavior because it fully respects the intent of the 
application with regard to the actual nodes that it specified in its 
memory policies.  A node should only have one definition and policies that 
are effected on a set of nodes, or one node in the preferred case, should 
not change from beneath the application because it was not the intent of 
the implementation.  Doing so is dangerous, regardless of whether or not 
it is currently the mempolicy behavior in HEAD.

		David
