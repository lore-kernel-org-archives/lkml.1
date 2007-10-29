Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXJ2T6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXJ2T6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXJ2T56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:57:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57221 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbXJ2T54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:57:56 -0400
Date: Mon, 29 Oct 2007 12:57:54 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029125754.7d7cf172.pj@sgi.com>
In-Reply-To: <1193676854.5035.121.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<1193676854.5035.121.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> > 	Indeed, if there was much such usage, I suspect they'd
> > 	be complaining that the current kernel API was borked, and
> > 	they'd be filing a request for enhancement -asking- for just
> > 	this subtle change in the kernel API's here.  In other words,
> > 	this subtle API change is a feature, not a bug ;)
> 
> Agreed. 

Hmmm ... put your thinking hat for my next comment ...

I could do one of two things in mm/mempolicy.c:
 B1) continue accepting nodemasks across the set_mempolicy and mbind
     system call APIs that are just like now (only nodes in the current
     tasks cpuset matter), but then remember what was passed in, so that
     if the tasks cpuset subsequently shrank down and then expanded
     again back to its original size, they would end up with the same
     memory policy placement they first had, or
 B2) accept nodemasks as if relative to the entire system, regardless
     of what cpuset they were in at the moment (all nodes in the system
     matter and can be specified.)

If I did B1, then that's just a subtle change in the API, and what
you agreed to above holds.

If I did B2, then that's a serious change in the way that nodes
are numbered in the nodemasks passed into mbind and set_mempolicy,
from being only nodes that happen to be in the tasks current cpuset,
to being nodes relative to all possible nodes on the system.

We need B2, I think.  Otherwise, if a job happens to be running in
a shrunken cpuset, it can't request what memory policy placement
it wants should it end up in a larger cpuset later on.  With B1, we
would continue to have the timing dependencies between when a task
is moved between different size cpusets, and when it happens to issue
mbind/set_mempolicy calls.

But B2 is an across the board change in how we number the nodes
passed into mbind and set_mempolicy.  That is in no way an upward
compatible change.

I am strongly inclined toward B2, but it must be a non-default optional
mode, at least for a while, perhaps a long while.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
