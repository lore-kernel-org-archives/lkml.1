Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0ATUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0ATUsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379Ab0ATUsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:48:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0ATUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:48:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BFPcdLiXcwa5dPkGwiuQqectu27qk+8X9Y9OaUit1qTL8dGTDo3sxmr6gXmaKIrQ+
	AlJ5RwA9zj5oAYrTDBOUw==
Date: Wed, 20 Jan 2010 12:48:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
In-Reply-To: <20100120094813.GC5154@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1001201241540.6440@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com> <20100120094813.GC5154@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Mel Gorman wrote:

> > With Lee's work on mempolicy-constrained hugepage allocations, there is a 
> > use-case for this explicit trigger to be exported via sysfs in the 
> > longterm:
> 
> True, although the per-node structures are only available on NUMA making
> it necessary to have two interfaces. The per-node one is handy enough
> because it would be just
> 
> /sys/devices/system/node/nodeX/compact_node
> 	When written to, this node is compacted by the writing process
> 
> But there does not appear to be a "good" way of having a non-NUMA
> interface. /sys/devices/system/node does not exist .... Does anyone
> remember why !NUMA does not have a /sys/devices/system/node/node0? Is
> there a good reason or was there just no point?
> 

There doesn't seem to be a usecase for a fake node0 sysfs entry since it 
would be a duplication of procfs.

I think it would be best to create a global /proc/sys/vm/compact trigger 
that would walk all "compactable" zones system-wide and then a per-node 
/sys/devices/system/node/nodeX/compact trigger for that particular node, 
both with permissions 0200.

It would be helpful to be able to determine what is "compactable" at the 
same time by adding both global and per-node "compact_order" tunables that 
would default to HUGETLB_PAGE_ORDER.  Then, the corresponding "compact" 
trigger would only do work if fill_contig_page_info() shows 
!free_blocks_suitable for either all zones (global trigger) or each zone 
in the node's zonelist (per-node trigger).
