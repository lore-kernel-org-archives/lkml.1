Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbZCCWaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbZCCWaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZCCWaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:30:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZCCWaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:30:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IOjyUoD4sSII0v4b7J41JeSih3DRtQbHeHAuIy4dET232pk6Uk0tQry++/2VoYIvJ
	9IZC9Sfx4xAicLWUV+Mng==
Date: Tue, 3 Mar 2009 14:29:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903031401260.29042@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031136380.26454@qirst.com>  <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903031345150.9466@qirst.com>  <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031509380.25612@qirst.com>  <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com>
 <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Paul Menage wrote:

> > Unfortunately, we can't add a slab hardwall flag to the cpuset to
> > configure this behavior since that would require locking to dereference
> > in the fastpath.
> >
> 
> I don't think that it would - cgroups and subsystems should be RCU safe.
> 

That would help for cpusets that are looking for NUMA optimizations (i.e. 
probably long-lived objects with local affinity) but would not ensure 
memory isolation from tasks in other exclusive cpusets from allocating on 
my slab.

So to address both NUMA and memory isolation, it seems like we'd need to 
add a `slab_hardwall' flag that would have to be disabled for both cpusets 
(the one hosting the cpu slab and the one allocating an object) to ignore 
the hardwall requirement.

That isn't a very clean solution, but is certainly plausible if 
Christoph's objection is that in the vast majority of multiple cpuset 
systems it is far better to allocate on cpu slabs than for true memory 
isolation or the ability to allocate an object on a specific node (for 
which we currently have no solution) for affinity.
