Return-Path: <linux-kernel-owner+w=401wt.eu-S1750824AbXAYLYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750824AbXAYLYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXAYLYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:24:11 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:57258 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXAYLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:24:10 -0500
Message-ID: <45B8934F.50205@linux.vnet.ibm.com>
Date: Thu, 25 Jan 2007 16:53:59 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <200701250942.47321.a1426z@gawab.com> <45B86930.2090709@linux.vnet.ibm.com> <1169720945.6189.52.camel@twins>
In-Reply-To: <1169720945.6189.52.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
>> Apart from kswapd, limiting pagecache helps performance of
>> applications by not eating away their ANON pages or other parts of its
>> resident data set.  When there is enough free memory, then there is no
>> performance issue.  However memory is always utilized to the max.
>> Hence every pagecache page that is allocated should come from some
>> application's RSS, or from cold pagecache page.  If that page was
>> stolen from some application, then that application pays the price for
>> swapping or reading the page back to memory.  This scenario is what we
>>  want to avoid.  All that we are trying to achieve is that pagecache
>> eats a (unmapped) pagecache page and not steal memory from other
>> important application's resident set.
>>
>> Certainly this should be a configurable option and kernel's behavior
>> should not be changed in general.
> 
> Ah, this would be a clear case of the page reclaim selecting the wrong
> working set.
> 
> It is perfectly fine for a page cache page to evict a app page (be it
> anon or not) if that page cache page is used more frequently than the
> app page in question.

Well, this is true only as long as all applications running in the
system are graded equally and it is kernel's job to provide the best
of the system resources to all applications.

> Trouble seems to be that the current algorithm gets it quite wrong at
> times.

The current reclaim code does a good job based on the assumption that
pages belonging to different applications have equal priority.  The
aging of the page is independent of application's priority or class.
This is good for best overall system performance.

The new use case that is challenging this assumption is the fact that
application groups fall into different class on the same system and
there is a need to make certain class perform better at the cost of
certain other class of applications.  In this scenario system
performance is not judged by overall average throughput, but by
performance of certain class of applications only.

A backup job running in the database server can take any amount of
performance hit to marginally improve database performance since that
is what the users care about.  We would run into similar situations
when running various virtualization and consolidation solutions.

> Also stating that free memory somehow is good for you is weird, free
> memory is a loss, you under utilise your machine. Keeping clean
> pagecache pages in there that are likely to be referenced again is a
> clear win; it saves the tediously slow load from disk.

Agreed

> 
> So you're now proposing to limit the page cache were as its clear that
> the better solution would be to tune replacement policy (and or provide
> hints to said mechanism using madvise/fadvise)

Well, we may need to use both the approach.  Hints with
madvise/fadvise is definitely a good approach and the kernel should
take these hints aggressively. Yet even with these hints we may want
to have limits in the interest of other applications that do not use
pagecache.

System wide limit to pagecache may not sound very interesting, but if
we think about 'containers' and group of process having such limits it
will have more practical use cases.  An aggregation of process having
 limit on pagecache would give relative importance to certain class of
pages during page replacement.  Controlling limits among group of
applications will help achieve peak application performance with the
applications that we care about.

--Vaidy

