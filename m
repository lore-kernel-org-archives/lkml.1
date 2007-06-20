Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXFTEDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXFTEDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXFTEDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:03:09 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45380 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXFTEDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:03:08 -0400
Date: Wed, 20 Jun 2007 13:01:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, wli@holomorphy.com, lee.schermerhorn@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: Some thoughts on memory policies
Message-ID: <20070620040131.GA29240@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
	wli@holomorphy.com, lee.schermerhorn@hp.com,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706181257010.13154@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181257010.13154@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:22:08PM -0700, Christoph Lameter wrote:
> 1. Memory policies must be attachable to a variety of objects
> 
> - System policies. The system policy is currently not
>   modifiable. It may be useful to be able to set this.
>   Small NUMA systems may want to run with interleave by default 
> 
For small systems there are a number of things that could be done for
this. With the interleave map for system init dynamically created, we can
make a reasonable guess about whether we want to use interleave as a
default policy or not if the node map is considerably different from
the online map (or the node_memory_map in -mm).

If the system policy only makes sense as interleave or default, it might
make sense simply to have a sysctl for this (the sysctl handler could
rebalance the interleave map when switching to handle offline nodes
coming online later, for example).

> - Memory policies need to be attachable to types of pages.
>   F.e. executable pages of a threaded application are best
>   spread (or replicated) whereas the stack and the data may
>   best be allocated in a node local way.

That would be nice, but one would also have to be able to restrict
the range of nodes to replicate across when applications know their
worst-case locality. Perhaps some of the cpuset work could be generalized
for this?

> 2. Memory policies need to support additional constraints
> 
> - Restriction to a set of nodes. That is what we have today.
> 
> - Restriction to a container or cpuset. Maybe restriction
>   to a set of containers?
> 
Having memory policies per container or cpuset would be nice to have,
but this seems like it would get pretty messy with nested cpusets that
contain overlapping memory nodes?

The other question is whether tasks residing under a cpuset with an
established memory policy are allowed to mbind() outside of the cpuset
policy constraints. Spreading of page and slab cache pages seem to
already side-step constraints.

> 7. Allocators must change
> 
> Right now the policy is set by the process context which is bad because
> one cannot specify a memory policy for an allocation. It must be possible
> to pass a memory policy to the allocators and then get the memory 
> requested.
> 
Some policy hints can already be determined from the gfpflags, perhaps
it's worth expanding on this? If these sorts of things have to be handled
by devices, one has to assume that the device may not always be running
in the same configuration or system, so an explicit policy would simply
cause more trouble.

> I wish we could come up with some universal scheme that encompasses all
> of the functionality we want and that makes memory more manageable....
> 
There's quite a bit of room for improving and extending the existing
code, and those options should likely be exhausted first.
