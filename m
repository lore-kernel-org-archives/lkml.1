Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZHVV2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZHVV2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZHVV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:28:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZHVV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:28:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TdNHw5xlZzew93bKyw64YS5UXIufjRW/9bGHWjXOiQYLiXjd2mS2K0RyrK0M4kM+s
	cf40nTynbOwSIzekK1YOg==
Date: Sat, 22 Aug 2009 14:28:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 4/4 -mm] flex_array: add flex_array_shrink function
In-Reply-To: <20090821164935.173689a0.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0908221357421.27738@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211621160.28611@chino.kir.corp.google.com> <20090821164935.173689a0.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Andrew Morton wrote:

> > +/**
> > + * flex_array_shrink - free unused second-level pages
> > + *
> > + * Frees all second-level pages that consist solely of unused
> > + * elements.  Returns the number of pages freed.
> > + *
> > + * Locking must be provided by the caller.
> > + */
> > +int flex_array_shrink(struct flex_array *fa)
> 
> It's logical but afaik unconventional that none of the flex_array
> kerneldoc actually documents the `struct flex_array *fa' argument.
> 

In the interest of completeness (vs. more doc clutter), we'd need to add 
seven or eight instances of "@fa: the flex array to manipulate," although 
that should be fairly obvious.

More of a priority might be to document flex_array_free() which lacks any 
commentary or add kerneldoc lines for the gfp_t formal of the three 
functions that use them.

> We're all waiting with bated breath to see who will be the first to use
> flex_array in live code.
> 

Now that flex_array_shrink() is in -mm, the cgroup code to manipulate 
arrays of pids could probably now use them without losing any 
functionality.

Beyond that, I don't know of any other users with enough incentive to 
immediately convert.  Its scope is unfortunately limited because it's an 
array and not a list, the latter of which you can efficiently iterate, 
sort, eliminate upper bounds, etc.

An alternative implementation, like a flex list, would probably find more 
users and could also be used by the cgroup code to manage pids.  Flex 
lists would be unbounded and can dynamically expand with linkage through 
page->lru when additional elements are pushed.
