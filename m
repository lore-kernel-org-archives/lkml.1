Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXJZBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXJZBNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXJZBNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:13:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbXJZBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:13:40 -0400
Date: Thu, 25 Oct 2007 18:13:37 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071025181337.b27cd309.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm probably going to be ok with this ... after a bit.

1) First concern - my primary issue:

    One thing I really want to change, the name of the per-cpuset file
    that controls this option.  You call it "interleave_over_allowed".

    Take a look at the existing per-cpuset file names:

	    $ grep 'name = "' kernel/cpuset.c
	    .name = "cpuset",
	    .name = "cpus",
	    .name = "mems",
	    .name = "cpu_exclusive",
	    .name = "mem_exclusive",
	    .name = "sched_load_balance",
	    .name = "memory_migrate",
	    .name = "memory_pressure_enabled",
	    .name = "memory_pressure",
	    .name = "memory_spread_page",
	    .name = "memory_spread_slab",
	    .name = "cpuset",

    The name of every memory related option starts with "mem" or "memory",
    and the name of every memory interleave related option starts with
    "memory_spread_*".

    Can we call this "memory_spread_user" instead, or something else
    matching "memory_spread_*" ?

    The names of things in the public API's are a big issue of mine.

2) Second concern - lessor code clarity issue:

    The logic surrounding current_cpuset_interleaved_mems() seems a tad
    opaque to me.  It appears on the surface as if the memory policy code,
    in mm/mempolicy.c, is getting a nodemask from the cpuset code by
    calling this routine, as if there were an independent per-cpuset
    nodemask stating over what nodes to interleave for MPOL_INTERLEAVE.

    But all that is returned is either (1) an empty node mask or (2) the
    current tasks allowed cpu mask.  If an empty mask is returned, this
    tells the MPOL_INTERLEAVE code to use the mask the user specified in
    an earlier set_mempolicy MPOL_INTERLEAVE call.  If a non-empty mask
    is returned, then the previous user specified mask is ignored and
    that non-empty mask (just all the current cpusets allowed nodes) is
    used instead.

    Restating this in pseudo code, from your patch, the mempolicy.c
    MPOL_INTERLEAVE code to rebind memory policies after a cpuset
    changes reads:
	tmp = current_cpuset_interleaved_mems();
	if tmp empty:
		rebind over tmp (all the cpusets allowed nodes)
		break;
	rebind over the set_mempolicy MPOL_INTERLEAVE specified mask
	break;

    The above code is assymmetric, and the returning of a nodemask is
    an illusion, suggesting that cpusets might have an interleaved
    nodemask separate from the allowed memory nodemask.

    How about instead of your current_cpuset_interleaved_mems() routine
    that returns a nodemask, rather have a routine that returns a Boolean,
    indicating whether this new flag is set, used as in:
	if (cpuset_is_memory_spread_user())
		tmp = cpuset_current_mems_allowed();
	else
		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
	pol->v.nodes = tmp;

    I'll wager this saves a few bytes of kernel text space as well.

3) Maybe I haven't had enough caffiene yet third issue:

    The existing kernel code for mm/mempolicy.c:mpol_rebind_policy()
    looks buggy to me.  The node_remap() call for the MPOL_INTERLEAVE
    case seems like it should come before, not after, updating mpolmask
    to the newmask.  Fixing that, and consolidating the multiple lines
    doing "*mpolmask = *newmask" for each case, into a single such line
    at the end of the switch(){} statement, results in the following
    patch.  Could you confirm my suspicions and push this one too.
    It should be a part of your patch set, so we don't waste Andrew's
    time resolving the inevitable patch collisions we'll see otherwise.

--- 2.6.23-mm1.orig/mm/mempolicy.c	2007-10-16 18:55:34.745039423 -0700
+++ 2.6.23-mm1/mm/mempolicy.c	2007-10-25 18:06:08.474742762 -0700
@@ -1741,14 +1741,12 @@ static void mpol_rebind_policy(struct me
 	case MPOL_INTERLEAVE:
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
-		*mpolmask = *newmask;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);
 		break;
 	case MPOL_PREFERRED:
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						*mpolmask, *newmask);
-		*mpolmask = *newmask;
 		break;
 	case MPOL_BIND: {
 		nodemask_t nodes;
@@ -1773,13 +1771,14 @@ static void mpol_rebind_policy(struct me
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;
 		}
-		*mpolmask = *newmask;
 		break;
 	}
 	default:
 		BUG();
 		break;
 	}
+
+	*mpolmask = *newmask;
 }
 
 /*


Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
