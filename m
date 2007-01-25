Return-Path: <linux-kernel-owner+w=401wt.eu-S965758AbXAYK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965758AbXAYK30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 05:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965761AbXAYK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 05:29:26 -0500
Received: from amsfep16-int.chello.nl ([62.179.120.11]:37526 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758AbXAYK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 05:29:25 -0500
Subject: Re: [RFC] Limit the size of the pagecache
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45B86930.2090709@linux.vnet.ibm.com>
References: <200701250942.47321.a1426z@gawab.com>
	 <45B86930.2090709@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 11:29:05 +0100
Message-Id: <1169720945.6189.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Apart from kswapd, limiting pagecache helps performance of
> applications by not eating away their ANON pages or other parts of its
> resident data set.  When there is enough free memory, then there is no
> performance issue.  However memory is always utilized to the max.
> Hence every pagecache page that is allocated should come from some
> application's RSS, or from cold pagecache page.  If that page was
> stolen from some application, then that application pays the price for
> swapping or reading the page back to memory.  This scenario is what we
>  want to avoid.  All that we are trying to achieve is that pagecache
> eats a (unmapped) pagecache page and not steal memory from other
> important application's resident set.
> 
> Certainly this should be a configurable option and kernel's behavior
> should not be changed in general.

Ah, this would be a clear case of the page reclaim selecting the wrong
working set.

It is perfectly fine for a page cache page to evict a app page (be it
anon or not) if that page cache page is used more frequently than the
app page in question.

Trouble seems to be that the current algorithm gets it quite wrong at
times.

Also stating that free memory somehow is good for you is weird, free
memory is a loss, you under utilise your machine. Keeping clean
pagecache pages in there that are likely to be referenced again is a
clear win; it saves the tediously slow load from disk.

So you're now proposing to limit the page cache were as its clear that
the better solution would be to tune replacement policy (and or provide
hints to said mechanism using madvise/fadvise)

