Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXJZBz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXJZBz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXJZBzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:55:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32936 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166AbXJZBzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:55:10 -0400
Date: Thu, 25 Oct 2007 18:55:06 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071025185506.8c373aa8.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> With that MPOL_INTERLEAVE would be context dependent and no longer 
> needs translation. Lee had similar ideas. Lee: Could we make 
> MPOL_INTERLEAVE generally cpuset context dependent?

Well ... MPOL_INTERLEAVE already is essentially cpuset relative.

So long as the cpuset size (number of allowed memory nodes) doesn't
change, whatever MPOL_INTERLEAVE you set is remapped whenever the
cpusets 'mems' changes, preserving the cpuset relative interleaving.

The problem, as David explains, comes when cpusets change sizes.
When the cpuset gets smaller, one can still do a pretty good job,
scrunching down the interleave nodes in proportion.  But when the
cpuset gets larger, it's not clear how to convert a subset of a
smaller set, to an equivalent subset of a larger set.

The existing code handled this last case by saying screw it -- don't
expand the set of interleave nodes when the cpuset 'mems' grows.

David's new code handles this last case by adding a new per-cpuset
Boolean that adds a new alternative, forcing all the tasks using
MPOL_INTERLEAVE in that cpuset, anytime thereafter that the cpusets
'mems' changes, to get interleaved over the entire cpuset.

Now that I spell it out that way, I am having second thoughts about
this one.  It's another special case palliative, given that we can't
give the user what they really want.

David - could you describe the real world situation in which you
are finding that this new 'interleave_over_allowed' option, aka
'memory_spread_user', is useful?  I'm not always opposed to special
case solutions; but they do usually require special case needs to
justify them ;).

I suspect that the general case solution would require having the user
pass in two nodemasks, call them ALL and SUBSET, requesting that
relative to the ALL nodes, interleave be done on the SUBSET nodes.
That way, even if say the task happened to be running in a cpuset with
a -single- allowed memory node at the moment, it could express its user
memory interleave memory needs for the general case of any number of
nodes.  Then for whatever nodes were currently allowed by the cpuset
to that task at any point, the nodes_remap() logic could be done to
derive from the ALL and SUBSET masks, and the current allowed mask,
what nodes to interleave that tasks user allocations over.

This would require a new set_mempolicy API, and might not be worth it.

If David has a compelling use case, it is simple enough that it
might well be worth doing, even though it's not the general case
solution.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
