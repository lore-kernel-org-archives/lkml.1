Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbXJZSpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbXJZSpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXJZSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:45:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXJZSpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:45:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=m7pH0Xt8626mZ4n5FwhH2eKf4us/3S12UYy4XHGtmTNwR/GoXYdllRImTRRGnYXyv
	3SOO4UdO5HLgeRExWmDtg==
Date: Fri, 26 Oct 2007 11:45:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193411888.5032.9.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>  <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>  <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
  <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <1193411888.5032.9.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Lee Schermerhorn wrote:

> That's what my "cpuset-independent interleave" patch does.  David
> doesn't like the "null node mask" interface because it doesn't work with
> libnuma.  I plan to fix that, but I'm chasing other issues.  I should
> get back to the mempol work after today.
> 

Hacking and requiring an updated version of libnuma to allow empty 
nodemasks to be passed is a poor solution; if mempolicy's are supposed to 
be independent from cpusets, then what semantics does an empty nodemask 
actually imply when using MPOL_INTERLEAVE?  To me, it means the entire 
set_mempolicy() should be a no-op, and that's exactly how mainline 
currently treats it _as_well_ as libnuma.  So justifying this change in 
the man page is respectible, but passing an empty nodemask just doesn't 
make sense.

> What I like about the cpuset independent interleave is that the "policy
> remap" when cpusets are changed is a NO-OP--no need to change the
> policy.  Just as "preferred local" policy chooses the node where the
> allocation occurs, my cpuset independent interleave patch interleaves
> across the set of nodes available at the time of the allocation.  The
> application has to specifically ask for this behavior by the null/empty
> nodemask or the TBD libnuma API.  IMO, this is the only reasonable
> interleave policy for apps running in dynamic cpusets.
> 

Passing empty nodemasks with MPOL_INTERLEAVE to set_mempolicy() is the 
only reasonable way of specifying you want, at all times, to interleave 
over all available nodes?  I doubt it.

I personally prefer an approach where cpusets take the responsibility for 
determining how policies change (they use set_mempolicy() anyway to effect 
their mems boundaries) because it's cpusets that has changed the available 
nodemask out from beneath the application.  So instead of trying to create 
a solution where cpusets impact mempolicies and mempolicies impact 
cpusets, it should only be in a single direction.  Cpusets change the 
set of available nodes and should update the attached tasks' mempolicies 
at the same time.  That's the same as saying that cpusets should be built 
on top of mempolicies, which they are, and shouldn't have any reverse 
dependency.

> An aside:  if David et al [at google] are using cpusets on fake numa for
> resource management [I don't know this is the case, but saw some
> discussions way back that indicate it might be?], then maybe this
> becomes less of an issue when control groups [a.k.a. containers] and
> memory resource controls come to fruition?
> 

Completely irrelevant; I care about the interaction between cpusets and 
mempolicies in mainline Linux.

		David
