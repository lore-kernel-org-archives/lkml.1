Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZCLTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZCLTfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZCLTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:35:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZCLTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:35:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=E75UbuD34vq2sfjddNrQlrBWKxLZ9DZD9AslUooH/Ecmdt11w5EH8R6Ja8SIbPXWK
	xrxLX/nn85mvTvRHN4Fjg==
Date: Thu, 12 Mar 2009 12:32:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903121510380.21607@qirst.com>
Message-ID: <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Christoph Lameter wrote:

> > Yes, jobs are running in the leaf with my above example.  And it's quite
> > possible that the higher level has segmented the machine for NUMA locality
> > and then further divided that memory for individual jobs.  When a job
> > completes or is killed, the slab cache that it has allocated can be freed
> > in its entirety with no partial slab fragmentation (i.e. there are no
> > objects allocated from its slabs for disjoint, still running jobs).  That
> > cpuset may then serve another job.
> 
> Looks like we are talking about a differing project here. Partial slabs
> are shared between all processors with SLUB. Slab shares the partial slabs
> for the processors on the same node.
> 

If `memory_slab_hardwall' is set for a cpuset, its tasks will only pull a 
slab off the partial list that was allocated on an allowed node.  So in my 
earlier example which segments the machine via cpusets for NUMA locality 
and then divides those cpusets further for exclusive memory to provide to 
individual jobs, slab allocations will be constrained within the cpuset of 
the task that allocated them.  When a job dies, all slab allocations are 
freed so that no objects remain on the memory allowed to that job and, 
thus, no partial slabs remain (i.e. there were no object allocations on 
the job's slabs from disjoint cpusets because of the exclusivity).
