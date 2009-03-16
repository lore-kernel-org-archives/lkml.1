Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbZCPWTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbZCPWTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760023AbZCPWTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:19:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZCPWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:19:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oNE7kGNAK15Idtdx9Bmzjo3ZyjkOkT0u6xm7g1cixJyZs+LKUDPqq4V5M8fR5ed/d
	mJOmmsOwR6H/0P2tX7XzQ==
Date: Mon, 16 Mar 2009 15:17:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903161239450.17730@qirst.com>
Message-ID: <alpine.DEB.2.00.0903161512120.26565@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com> <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121145510.27660@qirst.com>
 <alpine.DEB.2.00.0903121137320.1514@chino.kir.corp.google.com> <alpine.DEB.1.10.0903121510380.21607@qirst.com> <alpine.DEB.2.00.0903121224430.5306@chino.kir.corp.google.com> <alpine.DEB.1.10.0903131630530.1741@qirst.com> <alpine.DEB.2.00.0903131620200.1881@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903161239450.17730@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Christoph Lameter wrote:

> If the nodes are exclusive to a load then the cpus attached to those nodes
> are also exclusive?

No, they are not exclusive.

Here is my example (for the third time) if, for example, mems are grouped 
by the cpus for which they have affinity:

/dev/cpuset
	--> cpuset_A (cpus 0-1, mems 0-3)
	--> cpuset_B (cpus 2-3, mems 4-7)
	--> cpuset_C (cpus 4-5, mems 8-11)
	--> ...

Within that, we isolate mems for specific jobs:

/dev/cpuset
	--> cpuset_A (cpus 0-1, mems 0-3)
		--> job_1 (mem 0)
		--> job_2 (mem 1-2)
		--> job_3 (mem 3)
	--> ...

> If so then there is no problem since the percpu queues
> are only in use for a specific load with a consistent restriction on
> cpusets and a consistent memory policy. Thus there is no need for
> memory_slab_hardwall.
> 

All of those jobs may have different mempolicy requirements.  
Specifically, some cpusets may require slab hardwall behavior while 
others do not for true memory isolation or NUMA optimizations.

In other words, there is _no_ way with slub to isolate slab allocations 
for job_1 from job_2, job_3, etc.  That is what memory_slab_hardwall 
intends to address.
