Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0CBVDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:03:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0CBVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:03:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ouWVDsia/a9t+0lGWCh/DrW69KiqKwwXGoIh3XsLLxcOA48OZPphLSb6JRLJkaIut
	+Q8tVeXSwShSCVyydnUJg==
Date: Tue, 2 Mar 2010 13:03:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <alpine.DEB.2.00.1003021419020.30059@router.home>
Message-ID: <alpine.DEB.2.00.1003021253520.18137@chino.kir.corp.google.com>
References: <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi>
 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
 <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <4B8CA7F5.1030802@cs.helsinki.fi>
 <alpine.DEB.2.00.1003021419020.30059@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Christoph Lameter wrote:

> 
> Not sure how this would sync with slab use during node bootstrap and
> shutdown. Kame-san?
> 

All the nodelist allocation and initialization is done during 
MEM_GOING_ONLINE, so there should be no use of them until that 
notification cycle is done and it has graduated to MEM_ONLINE: if there 
are, there're even bigger problems because zonelist haven't even been 
built for that pgdat yet.  I can only speculate, but since Andi's 
patchset did all this during MEM_ONLINE, where the bit is already set in 
node_states[N_HIGH_MEMORY] and is passable to kmalloc_node(), this is 
probably why additional hacks had to be added elsewhere.

Other than that, concurrent kmem_cache_create() is protected by 
cache_chain_mutex.
