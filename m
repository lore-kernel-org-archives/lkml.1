Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998Ab0CAK1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:27:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0CAK1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:27:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oTv/5nlYfBI0+zEEJ42y6qDNdGIM6YVLv+smrekQe2Ljnmgj2zoYC77E5mL+jJ+AA
	E4X9U09EqYi3+8RYafCHA==
Date: Mon, 1 Mar 2010 02:27:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <20100301105932.5db60c93.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003010224530.26824@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box> <alpine.DEB.2.00.1002261123520.7719@router.home> <20100226173115.GG16335@basil.fritz.box>
 <20100301105932.5db60c93.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, KAMEZAWA Hiroyuki wrote:

> > > Well Kamesan indicated that this worked if a cpu became online.
> > 
> > I mean in the general case. There were tons of problems all over.
> > 
> Then, it's cpu hotplug matter, not memory hotplug.
> cpu hotplug callback should prepaare 
> 
> 
> 	l3 = searchp->nodelists[node];
> 	BUG_ON(!l3);
> 
> before onlined. Rather than taking care of races.
> 

I can only speak for x86 and not the abundance of memory hotplug support 
that exists for powerpc, but cpu hotplug doesn't do _anything_ when a 
memory region that has a corresponding ACPI_SRAT_MEM_HOT_PLUGGABLE entry 
in the SRAT is hotadded and requires a new nodeid.  That can be triggered 
via the acpi layer with plug and play or explicitly from the command line 
via CONFIG_ARCH_MEMORY_PROBE.

Relying on cpu hotplug to set up nodelists in such a circumstance simply 
won't work.  You need memory hotplug support such as in my patch.
