Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbZEKXhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbZEKXhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZEKXhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:37:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZEKXhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:37:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TCpZbPG6QHufAee6vcdE5+iqKwDnjefq0QrQnSwHZLgAdp0rOPpYHYtZTua8Ijqdl
	aWeZclIBdIFCfGQmpn8cg==
Date: Mon, 11 May 2009 16:37:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511161446.4d2a32a5.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905111628370.8638@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com> <20090511142936.dd68005b.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
 <20090511151130.9a949cb7.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111529090.2234@chino.kir.corp.google.com> <20090511154603.0fb0acbf.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111557360.5979@chino.kir.corp.google.com>
 <20090511161446.4d2a32a5.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> That assumes that the oom-killer is triggered - in the typical
> kernel developer testing, that won't happen.
> 
> I think what we should do here is to prevent people even attempting to
> use __GFP_NOFAIL with higher-order allocations.
> 

You could just add WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL) in the check for 
order != 0 in __alloc_pages_internal() to keep it out of the fastpath and 
make it appear when we have to reclaim.  That still probably has less 
coverage than you want, but these allocations have a high probability of 
triggering reclaim anyway so it should be pretty obvious.

> Are you aware of any callsite which is presently using __GFP_NOFAIL on
> order>0 allocations?
> 

Nope.

> I expect slub might cause this to happen due to its habit of using
> larger-than-needed orders for small objects.  For example, cxgb3 is
> passing __GFP_NOFAIL into alloc_skb().
> 

slub_max_order is set to PAGE_ALLOC_COSTLY_ORDER by default, so this would 
have to be overridden by the user on the command line unless a single 
object can't fit into such a slab.
