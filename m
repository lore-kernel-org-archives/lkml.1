Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXJZA2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXJZA2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXJZA2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:28:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60940 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbXJZA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:28:04 -0400
Date: Thu, 25 Oct 2007 17:28:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, David Rientjes wrote:

> The problem occurs when you add cpusets into the mix and permit the 
> allowed nodes to change without knowledge to the application.  Right now, 
> a simple remap is done so if the cardinality of the set of nodes 
> decreases, you're interleaving over a smaller number of nodes.  If the 
> cardinality increases, your interleaved nodemask isn't expanded.  That's 
> the problem that we're facing.  The remap itself is troublesome because it 
> doesn't take into account the user's desire for a custom nodemask to be 
> used anyway; it could remap an interleaved policy over several nodes that 
> will already be contended with one another.

Right. So I think we are fine if the application cannot setup boundaries 
for interleave.


> Normally, MPOL_INTERLEAVE is used to reduce bus contention to improve the 
> throughput of the application.  If you remap the number of nodes to 
> interleave over, which is currently how it's done when mems_allowed 
> changes, you could actually be increasing latency because you're 
> interleaving over the same bus.

Well you may hit some nodes more than others so a slight performance 
degradataion.

> This isn't a memory policy problem because all it does is effect a 
> specific policy over a set of nodes.  With my change, cpusets are required 
> to update the interleaved nodemask if the user specified that they desire 
> the feature with interleave_over_allowed.  Cpusets are, after all, the 
> ones that changed the mems_allowed in the first place and invalidated our 
> custom interleave policy.  We simply can't make inferences about what we 
> should do, so we allow the creator of the cpuset to specify it for us.  So 
> the proper place to modify an interleaved policy is in cpusets and not 
> mempolicy itself.

With that MPOL_INTERLEAVE would be context dependent and no longer 
needs translation. Lee had similar ideas. Lee: Could we make 
MPOL_INTERLEAVE generally cpuset context dependent?

