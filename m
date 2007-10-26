Return-Path: <linux-kernel-owner+w=401wt.eu-S1763309AbXJZCLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763309AbXJZCLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXJZCLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:11:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXJZCLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:11:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=kiyoVvLxVsysNIV9vsHw9ymIXZ98OMUTNLcMHE5rHQEf9AnVWh9XQTy2Fs4/2x1AV
	7r0aKHxvpI0yg8V91gEUg==
Date: Thu, 25 Oct 2007 19:11:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       ak@suse.de, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071025185506.8c373aa8.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Paul Jackson wrote:

> David - could you describe the real world situation in which you
> are finding that this new 'interleave_over_allowed' option, aka
> 'memory_spread_user', is useful?  I'm not always opposed to special
> case solutions; but they do usually require special case needs to
> justify them ;).
> 

Yes, when a task with MPOL_INTERLEAVE has its cpuset mems_allowed expanded 
to include more memory.  The task itself can't access all that memory with 
the memory policy of its choice.

Since the cpuset has changed the mems_allowed of the task without its 
knowledge, it would require a constant get_mempolicy() and set_mempolicy() 
loop in the application to catch these changes.  That's obviously not in 
the best interest of anyone.

So my change allows those tasks that have already expressed the desire to 
interleave their memory with MPOL_INTERLEAVE to always use the full range 
of memory available that is dynamically changing beneath them as a result 
of cpusets.  Keep in mind that it is still possible to request an 
interleave only over a subset of allowed mems: but you must do it when you 
create the interleaved mempolicy after it has been attached to the cpuset.
set_mempolicy() changes are always honored.

The only other way to support such a feature is through a modification to 
mempolicies themselves, which Lee has already proposed.  The problem with 
that is it requires mempolicy support for cpuset cases and modification to 
the set_mempolicy() API.  My solution presents a cpuset fix for a cpuset 
problem.

> I suspect that the general case solution would require having the user
> pass in two nodemasks, call them ALL and SUBSET, requesting that
> relative to the ALL nodes, interleave be done on the SUBSET nodes.
> That way, even if say the task happened to be running in a cpuset with
> a -single- allowed memory node at the moment, it could express its user
> memory interleave memory needs for the general case of any number of
> nodes.  Then for whatever nodes were currently allowed by the cpuset
> to that task at any point, the nodes_remap() logic could be done to
> derive from the ALL and SUBSET masks, and the current allowed mask,
> what nodes to interleave that tasks user allocations over.
> 

I find it hard to believe that a single cpuset with a single 
memory_spread_user boolean is going to include multiple tasks that request 
interleaved mempolicies over differing nodes within the cpuset's 
mems_allowed.  That, to me, is the special case.

		David
