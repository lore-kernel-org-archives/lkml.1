Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697Ab0AFKgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0AFKgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631Ab0AFKgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:36:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:40845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0AFKgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:36:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lGDqHQ2QvZVdLVs5pEi3lyeNq3vUIgeyIEFq+nFaSx4//xCHsaltytkhVtXp7HakV
	MpyDGYzSsPGY8IY6Hdtcg==
Date: Wed, 6 Jan 2010 02:35:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       bfields@fieldses.org
Subject: RE: [PATCH] nodemask.h: change any_online_node() to a static
 inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090208932F@mi8nycmail19.Mi8.com>
Message-ID: <alpine.DEB.2.00.1001060232360.11860@chino.kir.corp.google.com>
References: <201001051117.39423.hartleys@visionengravers.com> <alpine.DEB.2.00.1001051052100.26131@chino.kir.corp.google.com> <BD79186B4FD85F4B8E60E381CAEE19090208932F@mi8nycmail19.Mi8.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, H Hartley Sweeten wrote:

> > Could you simply remove any_online_node() and replace its callers with 
> > first_node(node_online_map) instead?
> 
> No idea ;-)
> 
> My main intention with this patch was to quite some sparse noise in
> net/sunrpc/svc.c.  This seemed the cleanest way to do it.
> 

It certainly silents the warning, which is good, but it also leaves behind 
a macro that can simply be removed and reimplemented with 
first_node(node_online_map) given the current use cases.

> It looks like any_online_node is, currently, only called by:
> 
> arch/powerpc/mm/numa.c
>   3 places, twice setting a local int variable called 'nid' and once just
>   returning the 'node' from the macro.  All three call the marco as:
> 
> 	... any_online_node(NODE_MASK_ALL);
> 

NODE_MASK_ALL is a nodemask_t with all bits set, so this will simply 
return the first nid where node_online(nid) is true.  That's equivalent to 
first_node(node_online_map).

> net/sunrpc/svc.c
>   1 place, setting a local unsigned int variable called 'node'.  Calls the
>   macro as:
> 
> 	... any_online_node(node_online_map);
> 

Same thing, except this doesn't require any iteration since node_online() 
for the first bit in node_online_map will always be true.

> I really don't know if the macro could be replaced by first_node(node_online_map).
> 

It can, so I think an even better step would be to remove 
any_online_node() completely and convert the callers you've identified to 
use the new implementation.

Thanks!
