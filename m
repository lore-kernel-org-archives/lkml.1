Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZCJV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZCJV0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZCJV0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:26:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZCJV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:26:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Fyf7Vt+4k6FRn4+ZH+v33rSZ+NIp72QayH92AgS/+A3JmYKgwQD3H6vnCPYy2EKwy
	4uTHnb6G5Jc+FVekv0q2w==
Date: Tue, 10 Mar 2009 14:24:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903101651480.20363@qirst.com>
Message-ID: <alpine.DEB.2.00.0903101416160.4495@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com> <alpine.DEB.1.10.0903101651480.20363@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Christoph Lameter wrote:

> We already have PF_SPREAD_PAGE PF_SPREAD_SLAB and PF_MEMPOLICY.
> PF_MEMPOLICY in slab can have the same role as PF_SLAB_HARDWALL. It
> attempts what you describe. One the one hand you duplicate functionality
> that is already there and on the other you want to put code in the hot
> paths that we have intentionally avoided for ages.
> 

For slab, PF_MEMPOLICY is a viable alternative for the functionality that 
is being added with this patch.  The difference is that it only is 
enforced when the allocating task is a member of that cpuset and does not 
require the overhead of scanning the MPOL_BIND zonelist for every 
allocation to determine whwther a node is acceptable.

For slub, there is no current alternative to memory_slab_hardwall.

> The description is not accurate. This feature is only useful if someone
> comes up with a crummy cpuset definition in which a processor is a member
> of multiple cpusets and thus the per cpu queues of multiple subsystems get
> objects depending on which cpuset is active.
> 

Cpusets are hierarchical, so it is quite possible that a parent cpuset 
will include a group of cpus that has affinity to a specific group of 
mems.  This isolates that cpuset and all of its children for NUMA 
optimiziations.  Within that, there can be several descendant cpusets that 
include disjoint subsets of mems to isolate the memory that can be used 
for specific jobs.
