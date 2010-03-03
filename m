Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CCCjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:39:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0CCCjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:39:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LWTEmiSd0Z3fPT6LNpb9CDby1fOSwWkXgZrZb8uVLJ1NMDqQDgXneUoen7hzGFONV
	ttrKoPZCIn07X1S7pFC5A==
Date: Tue, 2 Mar 2010 18:39:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <20100303102844.fe740203.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003021836040.2205@chino.kir.corp.google.com>
References: <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi>
 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
 <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <4B8CA7F5.1030802@cs.helsinki.fi> <alpine.DEB.2.00.1003021419020.30059@router.home>
 <20100303102844.fe740203.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, KAMEZAWA Hiroyuki wrote:

> At node hot-add
> 
>  * pgdat is allocated from other node (because we have no memory for "nid")
>  * memmap for the first section (and possiby others) will be allocated from
>    other nodes.
>  * Once a section for the node is onlined, any memory can be allocated localy.
> 

Correct, and the struct kmem_list3 is also alloacted from other nodes with 
my patch.

>    (Allocating memory from local node requires some new implementation as
>     bootmem allocater, we didn't that.)
> 
>  Before this patch, slab's control layer is allocated by cpuhotplug.
>  So, at least keeping this order,
>     memory online -> cpu online
>  slab's control layer is allocated from local node.
> 
>  When node-hotadd is done in this order
>     cpu online -> memory online
>  kmalloc_node() will allocate memory from other node via fallback.
> 
>  After this patch, slab's control layer is allocated by memory hotplug.
>  Then, in any order, slab's control will be allocated via fallback routine.
> 

Again, this addresses memory hotplug that requires a new node to be 
onlined that do not have corresponding cpus that are being onlined.  On 
x86, these represent ACPI_SRAT_MEM_HOT_PLUGGABLE regions that are onlined 
either by the acpi hotplug or done manually with CONFIG_ARCH_MEMORY_PROBE.  
On other architectures such as powerpc, this is done in different ways.

All of this is spelled out in the changelog for the patch.
