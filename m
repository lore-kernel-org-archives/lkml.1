Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYJ3ItZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYJ3ItZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYJ3ItN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:49:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYJ3ItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:49:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=vG/4yOR/ow75zJcYzGNr6PBN+iORHVqvCQaT/6E0OZ/OoUlR/Y4olzYikbJWT4DO/
	VaHY30dKDrafCth4R0mSw==
Date: Thu, 30 Oct 2008 01:48:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
In-Reply-To: <6599ad830810292359u6a2d0191ud235b866a73a7359@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0810300119560.29094@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com> <6599ad830810292359u6a2d0191ud235b866a73a7359@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Paul Menage wrote:

> Wouldn't this be equally applicable to cgroups using the memory
> controller rather than cpusets? Might it make sense to have a common
> subsystem that could be used by either of them?
> 

This change give us two functional advantages for cpusets that aren't 
possible with the memcontroller.

First, it allows for cpu isolation.  I see this as more of a NUMA issue 
than memory controller issue since we're throttling dirty writeout for 
current's set of allowable nodes in the reclaim path to the set of cpus 
that pdflush can use.  This allows a couple of things:

 - disjoint (and cpu-exclusive) cpusets with latency sensitive tasks are
   unaffected by a flood of synchronous dirty writeback, and

 - we preserve NUMA locality and its optimizations for pages under
   writeback.

Second, it allows for targeted dirty ratios.  The memcontroller doesn't 
allow us to determine if, for instance, the background dirty ratio has 
been exceeded for a set of tasks assigned to a specific cgroup since we 
can't determine its amount of dirtyable memory or NR_FILE_DIRTY pages 
(they're stored as ZVC values in the VM and aren't collected by the memory 
controller).

		David
