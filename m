Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXJ2H0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXJ2H0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXJ2H0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:26:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60436 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918AbXJ2H0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:26:06 -0400
Date: Mon, 29 Oct 2007 00:26:02 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029002602.34866d8c.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
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
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
	<20071028224533.df924291.pj@sgi.com>
	<alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Let's add a Choice C:
> 
>     Any nodemask that is passed to set_mempolicy() is saved as
>     the intent of the application in struct mempolicy.

Yes

>     All policies are effected on a contextualized per-allocation
>     basis.

"contextualized" - I guess that means converted to cpuset
relative numbering - yes.

"per-allocation" - Most of the calculation of nodemasks and
zonelists is done when memory policies change.

>     Policies such as MPOL_INTERLEAVE always get AND'd with
>     pol->cpuset_mems_allowed.

Not AND'd - Folded, as in bitmap_remap().

>     If that yields numa_no_nodes, MPOL_DEFAULT is used instead.

Not an issue with Folding.

>     Policies such as MPOL_PREFERRED are respected if the node
>     is set in pol->cpuset_mems_allowed, otherwise MPOL_DEFAULT
>     is used.

Not an issue with Folding.

>     If an application attempts to setup a memory policy for
>     an MPOL_PREFERRED node that it doesn't have access to or
>     an MPOL_INTERLEAVE nodemask that is empty when AND'd with
>     pol->cpuset_mems_allowed, -EINVAL is returned and no new
>     policy is effected.

Not issues with Folding.

>     If an application gains nodes in pol->cpuset_mems_allowed that
>     now include the nodes from MPOL_INTERLEAVE or MPOL_PREFERRED,
>     that policy is then effected once again.  Otherwise,
>     MPOL_DEFAULT is still used.

Not issues with Folding.

With folding, an application that layed out an elaborate memory
policy configuration covering say 16 nodes can run in a 4 node
cpuset, where whatever would have been on node N gets folded down
to node N % 4.

With AND'ing, such an application would find 3/4's of its fancy
memory policy configuration replaced with MPOL_DEFAULT and -EINVAL
fallbacks.


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
