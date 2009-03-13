Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZCMXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZCMXa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZCMXaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:30:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZCMXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:30:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k3TDogPo4J/+GObeZ8kLeOfrbnA2wN9aXAuZj002CTrnlwRgC5zDKRkDsFrQzPefc
	o5AQhuMjkpb0FsJaZqlPg==
Date: Fri, 13 Mar 2009 16:28:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903131630530.1741@qirst.com>
Message-ID: <alpine.DEB.2.00.0903131620200.1881@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com> <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com> <alpine.DEB.1.10.0903131630530.1741@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009, Christoph Lameter wrote:

> > If `memory_slab_hardwall' is set for a cpuset, its tasks will only pull a
> > slab off the partial list that was allocated on an allowed node.  So in my
> > earlier example which segments the machine via cpusets for NUMA locality
> > and then divides those cpusets further for exclusive memory to provide to
> > individual jobs, slab allocations will be constrained within the cpuset of
> > the task that allocated them.  When a job dies, all slab allocations are
> > freed so that no objects remain on the memory allowed to that job and,
> > thus, no partial slabs remain (i.e. there were no object allocations on
> > the job's slabs from disjoint cpusets because of the exclusivity).
> 
> In order to do that you would need to duplicate the partial lists for
> each job and then guarantee that only the job uses objects from these
> partial pages.
> 

Each job is running it its own cpuset with exclusive memory attached to it 
in my example.  With memory_slab_hardwall, we simply don't refill the cpu 
slab with partial slabs that are on s->node[] for nodes that are not 
allowed.  When that job dies, all of its partial slabs will be freed if 
all cpusets within that parent cpuset are memory_slab_hardwall.

This isn't that uncommon of a use case.  The machine is being partitioned, 
depending on their affinity to one another, by its cpus and mems via 
cpusets.  Within those cpusets, which already supply memory locality to 
the cpus that the attached tasks are executing on, we can create 
descendant cpusets to provide memory exclusivity.

I think this is fairly straight forward in my implementation.
