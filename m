Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZHXWkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZHXWkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHXWke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:40:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZHXWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:40:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=eaZAucng5vnNaUPjsRggPqQrqX5b5lKfeM0saXRMXgIRBwdiap7TIKgz++aZGUgeo
	fLBTWMrii4bVmISjnpNAw==
Date: Mon, 24 Aug 2009 15:40:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
In-Reply-To: <1251148618.22398.8188.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241535000.12448@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
 <1251148618.22398.8188.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> On Mon, 2009-08-24 at 13:41 -0700, David Rientjes wrote:
> > LEX_ARRAY_FREE (or an additional poison value to 
> > distinguish between use-uninitialized vs. use-after-free) must be used in 
> > flex_array_clear() otherwise the cgroup patchset, the only proposed user 
> > of this library code, could never shrink this array when pid's are free 
> > like the kmalloc vs. vmalloc patchset could do.
> 
> Are you saying that you expected it to never reallocate the array, but
> have a permanent flex_array and that it just calls flex_array_clear() on
> the elements that it doesn't want any more, and the array ends up
> sparsely populated?  I can see why we'd need a poison value in that
> case.
> 

Yeah, similar to using flex_array_free_parts() with a statically allocated 
struct flex_array storing the array's metadata (which is also broken, 
by the way, since it does no sanity check on either parameter in 
FLEX_ARRAY_INIT()).

> Or, are we just talking about a situation where we need to truncate the
> pidlist?
> 

The patchset Andrew referred to where he proposed using flex array instead 
would re-kmalloc (or re-vmalloc, I guess) a smaller amount of memory and 
then transfer elements into it to free the larger set of pages.  If they 
were to convert to using flex array, this would be achieved with 
flex_array_shrink() so they lose no functionality with the switch.

I don't think they can use flex array for another reason, however, because 
they want to sort the pidlist as its returned to userspace.  That would 
require dynamically allocating almost the same amount of memory as the 
flex array would, sorting it, and then storing it in the array.  This 
doesn't seem to be the best example use of flex array since the mapping of 
array indices to pid isn't really relevant and there's a longer iteration 
through the array if it is sparsely populated, which is why I suggested an 
alternative implementation of flex list.
