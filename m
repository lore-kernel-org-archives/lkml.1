Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZCDPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZCDPdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZCDPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:33:07 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60252 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753473AbZCDPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:33:06 -0500
Date: Wed, 4 Mar 2009 10:23:16 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Paul Menage <menage@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.2.00.0903031713200.4767@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903041011520.3850@qirst.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031136380.26454@qirst.com>  <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903031345150.9466@qirst.com>  <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031509380.25612@qirst.com>  <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com> 
 <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>  <alpine.DEB.2.00.0903031401260.29042@chino.kir.corp.google.com> <6599ad830903031653t231eb921md60a1aa21effa87b@mail.gmail.com> <alpine.DEB.2.00.0903031713200.4767@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, David Rientjes wrote:

> > Presumably in most cases all cpusets would have slab_hardwall set to
> > the same value.
>
> Christoph, would a `slab_hardwall' cpuset setting address your concerns?

That would make the per object memory policies in SLUB configurable? If
you can do that without regression and its clean then it would be
acceptable.

Again if you want per object memory policies in SLUB then it needs to be
added consistently. You would also f.e. have to check for an MPOL_BIND
condition where you check for cpuset nodes and make sure that __slab_alloc
goes round robin on MPOL_INTERLEAVE etc etc. You end up with a similar
nightmare implementation of that stuff as in SLAB. And as far as I know
this still has its issues since f.e. the MPOL_INTERLEAVE for objects is
fuzzing with the MPOL_INTERLEAVE node for pages which may result in
strange sequences of placement of pages on nodes because there were
intermediate allocations from slabs etc etc.

Memory policies and cpusets were initially designed to deal with page
allocations not with allocations of small objects. If you read the numactl
manpage then it becomes quite clear that we are dealing with page chunks
(look at the --touch or --strict options etc).

The intend is to spread memory in page chunks over NUMA nodes. That is
satisfied if the page allocations of the slab allocator are controllable
by memory policies and cpuset. And yes the page allocations may only
roughly correlate to the tasks that are consuming objects from shared
pools.
