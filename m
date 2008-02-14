Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYBNK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYBNK04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYBNK0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:26:48 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33031 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbYBNK0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:26:47 -0500
Date: Thu, 14 Feb 2008 04:26:43 -0600
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       clameter@sgi.com, ak@suse.de, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080214042643.dff40c72.pj@sgi.com>
In-Reply-To: <20080213142956.5ba52101.pj@sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<20080213110426.15179378.pj@sgi.com>
	<alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
	<20080213142956.5ba52101.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, responding (incorrectly) to David:
> > So, for example, if the task is bound by mems 1-3, and it asks for 
> > MPOL_INTERLEAVE over 2-4, then initially the mempolicy is only effected 
> > over node 3 and if it's later expanded to mems 1-8, then the mempolicy is 
> > effected over nodes 3-5, right?
> > 
> > And if the mems change to 3-8, the mempolicy is remapped to 5-7 even 
> > though 3-5 (which it already was interleaving over) is still accessible?
> 
> Yes and yes, for this cpuset relative numbering mode.

Paul, correcting himself ...

No and yes.  The manner in which too many nodes (as requested in a
RELATIVE mask) are folded into too small a cpuset is not actually
that critical, so long as it doesn't come up empty.  However, what
I'll be recommending, in a follow-up patch, will be folding the
larger set into the smaller one modulo the size of the smaller one.

In your example above, the requested policy asked for nodes 2-4,
so that means it is trying to lay out a memory policy with at least
five (0-4) nodes in consideration.  But the cpuset is only allowing
three (1-3) nodes at the moment.  So for each requested node, we take
its number modulo three to see which of the available nodes to include
in the interleave.

  Given
	N: how many nodes are allowed by the tasks cpuset (3, here)

	   n		m := (n % N)	r := m-th set node in allowed
	requested	  mod 3		result (in set 1, 2, 3 allowed)
	   2		    2	  		3
	   3		    0			1
	   4		    1			2

Hence your first example would result in an interleave over physical
nodes 1, 2, and 3 (the last column above.) ... not just over 3.

I intend to post patches you can use to lib/bitmap.c and the related
cpumask and nodemask apparatus that compute the above for you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
