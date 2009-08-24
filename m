Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZHXUue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZHXUue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZHXUud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:50:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3616 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbZHXUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:50:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IJhNqZuqveBnWpzBx+DqIl0kdyPM4AZFizQXhi+ip/tT/tBOxIGLxihgPj55kjoli
	JEdJmn8vkvAsGIBR3JsQQ==
Date: Mon, 24 Aug 2009 13:50:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
In-Reply-To: <1251146320.22398.8051.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241343080.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com> <1251128488.22398.7113.camel@nimitz> <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
 <1251146320.22398.8051.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> > Sure, if you never increase FLEX_ARRAY_PART_SIZE.  Otherwise, doing
> > 
> > static char zero_part[FLEX_ARRAY_PART_SIZE] = {
> > 	[0 ... FLEX_ARRAY_PART_SIZE - 1] = 0
> > };
> > 
> > and using flex_array_put(fa, element_nr, &zero_part) would work although 
> > you're trading off cleaner, yet not more efficient, code at the cost of 
> > FLEX_ARRAY_PART_SIZE wasted memory and memcpy() being slower than 
> > memset().
> 
> Yeah, that's true.  How about using the get() function?
> 
> int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> {
> 	void *element = flex_array_get(fa, element_nr);
> 	memset(element, FLEX_ARRAY_FREE, fa->element_size);
> }
> 

The idea was to eventually be able to distinguish between 
use-uninitialized and use-after-free and flex_array_clear() was a 
convenient way of providing an interface to identify the later.  So when 
an array is fully initialized (or fully cleared after a previous use where 
all elements we're used), you couldn't do flex_array_clear() on an element 
before flex_array_put() if its part isn't allocated yet with this 
implementation.

> It'll keep us from having to keep around a zero'd element. 
> 
> But, I guess we could also do:
> 
> 	struct flex_array_part *zero_part = empty_zero_page;
> 
> And use a BUILD_BUG_ON(FLEX_ARRAY_PART_SIZE > PAGE_SIZE).  But the whole
> point of this was to have elements that are smaller than PAGE_SIZE.
> Having that as a constraint doesn't seem too bad. :)
> 

Hmm, I think being able to increase FLEX_ARRAY_PART_SIZE is eventually 
going to become an integral part of the entire library so that it supports 
larger number of entries (and order-1 allocations aren't as difficult with 
anti-fragmentation), especially for those with larger element sizes.  
Otherwise, there's no need for FLEX_ARRAY_PART_SIZE in the first place.
