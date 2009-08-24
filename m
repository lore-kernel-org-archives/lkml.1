Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZHXUiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZHXUiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZHXUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:38:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56779 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZHXUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:38:51 -0400
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com>
	 <1251128488.22398.7113.camel@nimitz>
	 <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 13:38:40 -0700
Message-Id: <1251146320.22398.8051.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 13:29 -0700, David Rientjes wrote:
> On Mon, 24 Aug 2009, Dave Hansen wrote:
> 
> > My only worry about this is that it's largely a copy-and-paste of
> > flex_array_put().  If we had a function that just returned a pointer to
> > 'dst', we could use that in both cases.  
> > 
> > Couldn't we implement the above with just:
> > 
> > int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> > {
> > 	return flex_array_put(fa, element_nr, &empty_zero_page);
> > }
> > 
> 
> Sure, if you never increase FLEX_ARRAY_PART_SIZE.  Otherwise, doing
> 
> static char zero_part[FLEX_ARRAY_PART_SIZE] = {
> 	[0 ... FLEX_ARRAY_PART_SIZE - 1] = 0
> };
> 
> and using flex_array_put(fa, element_nr, &zero_part) would work although 
> you're trading off cleaner, yet not more efficient, code at the cost of 
> FLEX_ARRAY_PART_SIZE wasted memory and memcpy() being slower than 
> memset().

Yeah, that's true.  How about using the get() function?

int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
{
	void *element = flex_array_get(fa, element_nr);
	memset(element, FLEX_ARRAY_FREE, fa->element_size);
}

It'll keep us from having to keep around a zero'd element. 

But, I guess we could also do:

	struct flex_array_part *zero_part = empty_zero_page;

And use a BUILD_BUG_ON(FLEX_ARRAY_PART_SIZE > PAGE_SIZE).  But the whole
point of this was to have elements that are smaller than PAGE_SIZE.
Having that as a constraint doesn't seem too bad. :)

-- Dave

