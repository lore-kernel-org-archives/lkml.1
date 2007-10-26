Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbXJZSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbXJZSBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762692AbXJZSAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:00:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53761 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762619AbXJZSAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:00:44 -0400
Date: Fri, 26 Oct 2007 11:00:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, rientjes@google.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
In-Reply-To: <20071026105431.77d56253.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710261056270.15895@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
 <20071025230409.81f20ed3.pj@sgi.com> <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
 <20071026025634.0f32e1e2.pj@sgi.com> <20071026101805.df3ebfda.pj@sgi.com>
 <1193420627.5032.46.camel@localhost> <20071026105431.77d56253.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> > Will it handle the case of MPOL_INTERLEAVE policy on a shm segment that
> > is mapped by tasks in different, possibly disjoint, cpusets.  Local
> > allocation does, and my patch does.  That was one of the primary
> > goals--to address an issue that Christoph has with shared policies.
> > cpusets really muck these up!
> 
> It probably won't handle that.  I don't get along too well with shmem.

IMHO shmem policy support is pretty much messed up (seems that we 
introduced new races by trying to fix the refcounts). I tend to ignore the 
stuff unless it impacts regular shared or regular memory. Before we do any 
of this fancy stuff lets at least get the refcount handling right?

> Can you to an anti-shmem bigot how MPOL_INTERLEAVE should work with
> shmem segments mapped in diverse ways by different tasks in different
> cpusets?  What would be the key attribute(s) of a proper solution?
> Maybe if we keep it simple enough, I can avoid mucking it up too much
> this time around.

With relative nodemasks we could have a MPOL_INTERLEAVE policy working in 
multiple cpuset contexts. If nodes 0 and 1 are set in a nodemask then the 
first two nodes of the current cpuset are interleaved through. Nodes that 
do not exist are ignored. So if there is no second node then 
MPOL_INTERLEAVE becomes a noop.
