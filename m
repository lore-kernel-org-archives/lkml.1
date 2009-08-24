Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZHXWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZHXWcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZHXWcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:32:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZHXWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:32:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=F/r0//iGgPciCShSF+SNPzsK8VGq3BaYFnzxe20hSd3XknhxmYcY6oM/2N2SBs8uV
	kgDEmob3NHtCCcXiuWXSg==
Date: Mon, 24 Aug 2009 15:32:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
In-Reply-To: <1251149314.22398.8232.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0908241525140.12448@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com> <1251128488.22398.7113.camel@nimitz> <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
 <1251146320.22398.8051.camel@nimitz> <alpine.DEB.2.00.0908241343080.5574@chino.kir.corp.google.com> <1251149314.22398.8232.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009, Dave Hansen wrote:

> OK, just to make sure I'm understanding what you are saying.  If we
> haven't allocated the 'part' of a given element, then this code is
> bogus.  flex_array_get() will return NULL, and we have nothing to
> memset().  We effectively need flex_array_get()'s behavior, but we also
> need to ensure that there is space for the element allocated if it
> wasn't before flex_array_clear() is called.  Right?
> 

Yes, that would be the only way to eventually be able to distinguish 
between use-uninitialized and use-after-free; I don't know whether that 
information is helpful to the person developing code that is using flex 
array or not, but it costs nothing to do other than adding another poison 
value.  Since flex_array_get() will never allocate parts, we can't use it 
as-is since it returns NULL for both getting beyond the array upper bound 
and for an unallocated part.  If it returned an ERR_PTR() that would 
distinguish between the two, we could do a variation of what you suggested 
and then check the return value, yet we still have the same restriction of 
never increasing FLEX_ARRAY_PART_SIZE beyond PAGE_SIZE if we're to avoid 
wasted memory space (static char zero_part[FLEX_ARRAY_PART_SIZE]) to 
simply refactor the code with no other improvement.
