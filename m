Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbXJYX4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbXJYX4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXJYX4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:56:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXJYX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:56:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=J7wWM80ekJWRAJoXBoEX2GCY5ON76t8RqlFA3XZv8Etaum/0du63UqU1Ts6nMlrN4
	1Vg8P/8oH2vJE8osiDbzQ==
Date: Thu, 25 Oct 2007 16:56:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Christoph Lameter wrote:

> More interactions between cpusets and memory policies. We have to be 
> careful here to keep clean semantics.
> 

I agree.

> Isnt it a bit surprising for an application that has set up a custom 
> MPOL_INTERLEAVE policy if the nodes suddenly change because of a cpuset or 
> mems_allowed change?
> 

Every MPOL_INTERLEAVE policy is a custom policy that the application has 
setup.  If you don't use cpusets at all, the nodemask you pass to 
set_mempolicy() with MPOL_INTERLEAVE is static and won't change without 
the application's knowledge.  It has full control over the nodemask that 
it desires to interleave over.

The problem occurs when you add cpusets into the mix and permit the 
allowed nodes to change without knowledge to the application.  Right now, 
a simple remap is done so if the cardinality of the set of nodes 
decreases, you're interleaving over a smaller number of nodes.  If the 
cardinality increases, your interleaved nodemask isn't expanded.  That's 
the problem that we're facing.  The remap itself is troublesome because it 
doesn't take into account the user's desire for a custom nodemask to be 
used anyway; it could remap an interleaved policy over several nodes that 
will already be contended with one another.

Normally, MPOL_INTERLEAVE is used to reduce bus contention to improve the 
throughput of the application.  If you remap the number of nodes to 
interleave over, which is currently how it's done when mems_allowed 
changes, you could actually be increasing latency because you're 
interleaving over the same bus.

This isn't a memory policy problem because all it does is effect a 
specific policy over a set of nodes.  With my change, cpusets are required 
to update the interleaved nodemask if the user specified that they desire 
the feature with interleave_over_allowed.  Cpusets are, after all, the 
ones that changed the mems_allowed in the first place and invalidated our 
custom interleave policy.  We simply can't make inferences about what we 
should do, so we allow the creator of the cpuset to specify it for us.  So 
the proper place to modify an interleaved policy is in cpusets and not 
mempolicy itself.

		David
