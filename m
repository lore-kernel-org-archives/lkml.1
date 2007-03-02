Return-Path: <linux-kernel-owner+w=401wt.eu-S2992529AbXCBPqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992529AbXCBPqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992531AbXCBPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:46:06 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1083 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992529AbXCBPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:46:05 -0500
Message-ID: <45E846AF.1050703@shadowen.org>
Date: Fri, 02 Mar 2007 15:45:51 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@engr.sgi.com>
CC: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] Lumpy Reclaim V3
References: <exportbomb.1172604830@kernel> <96f80944962593738d72a803797dbddc@kernel> <Pine.LNX.4.64.0702281008330.21257@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702281008330.21257@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 27 Feb 2007, Andy Whitcroft wrote:
> 
>> +static int __isolate_lru_page(struct page *page, int active)
>> +{
>> +	int ret = -EINVAL;
>> +
>> +	if (PageLRU(page) && (PageActive(page) == active)) {
>> +		ret = -EBUSY;
>> +		if (likely(get_page_unless_zero(page))) {
>> +			/*
>> +			 * Be careful not to clear PageLRU until after we're
>> +			 * sure the page is not being freed elsewhere -- the
>> +			 * page release code relies on it.
>> +			 */
>> +			ClearPageLRU(page);
>> +			ret = 0;
> 
> Is that really necessary? PageLRU is clear when a page is freed right? 
> And clearing PageLRU requires the zone->lru_lock since we have to move it 
> off the LRU.

Although the PageLRU is stable as we have the zone->lru_lock we cannot
take the page off the LRU unless we can take a reference to it
preventing it from being released.  The page release code relies on the
the caller who takes the reference count to zero having exclusive access
to the page to release it.  To prevent a race with
put_page/__page_cache_release we cannot touch the page once its count
drops to zero, which occurs before the PageLRU is cleared.  PageLRU
being sampled outside the zone->lru_lock in that path to avoid taking
the lock if not required.

> 
>> -			ClearPageLRU(page);
>> -			target = dst;
>> +		active = PageActive(page);
> 
> Why are we saving the active state? Page cannot be moved between LRUs 
> while we hold the lru lock anyways.

This is used later in the function for comparison against all of the
other pages in the 'order' sized area rooted about the target page.  Its
mearly an optimisation.

-apw

