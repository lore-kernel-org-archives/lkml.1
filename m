Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0BYIBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:01:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0BYIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:01:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GE4M6fpOfVEDIDGC6O97b38OCj/HpdXPT1nrm0vhkSfTkSYxe44cseBC02hM9HjpZ
	ACorW+HSsv1LBaWlaKY1g==
Date: Thu, 25 Feb 2010 00:01:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <4B862623.5090608@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org>
 <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Pekka Enberg wrote:

> > > > > I'm just worried there is still an underlying problem here.
> > > > So am I. What caused the breakage that requires this patchset?
> > > Memory hotadd with a new node being onlined.
> > 
> > That used to work fine.
> 
> OK, can we get this issue resolved? The merge window is open and Christoph
> seems to be unhappy with the whole patch queue. I'd hate this bug fix to miss
> .34...
> 

I don't see how memory hotadd with a new node being onlined could have 
worked fine before since slab lacked any memory hotplug notifier until 
Andi just added it.

That said, I think the first and fourth patch in this series may be 
unnecessary if slab's notifier were to call slab_node_prepare() on 
MEM_GOING_ONLINE instead of MEM_ONLINE.  Otherwise, kswapd is already 
running, the zonelists for the new pgdat have been initialized, and the 
bit has been set in node_states[N_HIGH_MEMORY] without allocated 
cachep->nodelists[node] memory.
