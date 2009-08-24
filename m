Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZHXV2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZHXV2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZHXV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:28:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46512 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZHXV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:28:39 -0400
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908241343080.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com>
	 <1251128488.22398.7113.camel@nimitz>
	 <alpine.DEB.2.00.0908241323360.5574@chino.kir.corp.google.com>
	 <1251146320.22398.8051.camel@nimitz>
	 <alpine.DEB.2.00.0908241343080.5574@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 14:28:34 -0700
Message-Id: <1251149314.22398.8232.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 13:50 -0700, David Rientjes wrote:
> On Mon, 24 Aug 2009, Dave Hansen wrote:
> > int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> > {
> > 	void *element = flex_array_get(fa, element_nr);
> > 	memset(element, FLEX_ARRAY_FREE, fa->element_size);
> > }
> > 
> 
> The idea was to eventually be able to distinguish between 
> use-uninitialized and use-after-free and flex_array_clear() was a 
> convenient way of providing an interface to identify the later.  So when 
> an array is fully initialized (or fully cleared after a previous use where 
> all elements we're used), you couldn't do flex_array_clear() on an element 
> before flex_array_put() if its part isn't allocated yet with this 
> implementation.

OK, just to make sure I'm understanding what you are saying.  If we
haven't allocated the 'part' of a given element, then this code is
bogus.  flex_array_get() will return NULL, and we have nothing to
memset().  We effectively need flex_array_get()'s behavior, but we also
need to ensure that there is space for the element allocated if it
wasn't before flex_array_clear() is called.  Right?

I'm not literally saying that we have to use flex_array_get() forever.
But, it does seem that flex_array_clear() could certainly share some
code with the existing functions.  So, instead of just copying those
functions, let's make sure that we refactor them in a way so that we can
reuse the code.

-- Dave

