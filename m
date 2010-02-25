Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127Ab0BYVpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:45:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7721 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999Ab0BYVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:45:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=R/ixFIbuThNW9IN3act1kwURbj9+HGslrPT16X0+RTkWiwDGPSBDz4+bn8egwLHKM
	eW0OvFK14dO1Ck9Bh84fw==
Date: Thu, 25 Feb 2010 13:45:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <alpine.DEB.2.00.1002251228140.18861@router.home>
Message-ID: <alpine.DEB.2.00.1002251315010.3501@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org>
 <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002251228140.18861@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Christoph Lameter wrote:

> > I don't see how memory hotadd with a new node being onlined could have
> > worked fine before since slab lacked any memory hotplug notifier until
> > Andi just added it.
> 
> AFAICR The cpu notifier took on that role in the past.
> 

The cpu notifier isn't involved if the firmware notifies the kernel that a 
new ACPI memory device has been added or you write a start address to 
/sys/devices/system/memory/probe.  Hot-added memory devices can include 
ACPI_SRAT_MEM_HOT_PLUGGABLE entries in the SRAT for x86 that assign them 
non-online node ids (although all such entries get their bits set in 
node_possible_map at boot), so a new pgdat may be allocated for the node's 
registered range.

Slab isn't concerned about that until the memory is onlined by doing 
echo online > /sys/devices/system/memory/memoryX/state for the new memory 
section.  This is where all the new pages are onlined, kswapd is started 
on the new node, and the zonelists are built.  It's also where the new 
node gets set in N_HIGH_MEMORY and, thus, it's possible to call 
kmalloc_node() in generic kernel code.  All that is done under 
MEM_GOING_ONLINE and not MEM_ONLINE, which is why I suggest the first and 
fourth patch in this series may not be necessary if we prevent setting the 
bit in the nodemask or building the zonelists until the slab nodelists are 
ready.
