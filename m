Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0BFJxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:53:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab0BFJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:53:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IvCykz+uEuVG1upNiYPc/nGJ6eR2wGVOW4I1JecLM6IHlcaDjyxzjslLxRvBM3Bmw
	YJ0dPNwThDlqRI7UPTVPg==
Date: Sat, 6 Feb 2010 01:53:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in
 fallback_alloc()
In-Reply-To: <20100206072508.GN29555@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002060148300.17897@chino.kir.corp.google.com>
References: <201002031039.710275915@firstfloor.org> <20100203213912.D3081B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051251390.2376@chino.kir.corp.google.com> <20100206072508.GN29555@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010, Andi Kleen wrote:

> > That other node must be allowed by current's cpuset, otherwise 
> > kmem_getpages() will fail when get_page_from_freelist() iterates only over 
> > unallowed nodes.
> 
> All theses cases are really only interesting in the memory hotplug path
> itself (afterwards the slab is working anyways and memory is there)
> and if someone sets funny cpusets for those he gets what he deserves ...
> 

If a hot-added node has not been initialized for the cache, your code is 
picking an existing one in zonelist order which may be excluded by 
current's cpuset.  Thus, your code has a very real chance of having 
kmem_getpages() return NULL because get_page_from_freelist() will reject 
non-atomic ALLOC_CPUSET allocations for prohibited nodes.  That isn't a 
scenario that requires a "funny cpuset," it just has to not allow whatever 
initialized node comes first in the zonelist.

My suggested alternative does not pick a single initialized node, rather 
it tries all nodes that actually have a chance of having kmem_getpages() 
succeed which increases the probability that your patch actually has an 
effect for cpuset users.
