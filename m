Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXAWCMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXAWCMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXAWCMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:12:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:40687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbXAWCMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:12:36 -0500
Date: Tue, 23 Jan 2007 03:13:27 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Balbir Singh <balbir@in.ibm.com>
Cc: Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
Message-ID: <20070123021327.GZ13798@opteron.random>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B56575.10807@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 07:01:33AM +0530, Balbir Singh wrote:
> This makes me wonder if it makes sense to split up the LRU into page
> cache LRU and mapped pages LRU. I see two benefits
> 1. Currently based on swappiness, we might walk an entire list
>    searching for page cache pages or mapped pages. With these
>    lists separated, it should get easier and faster to implement
>    this scheme

When I tried that long time ago, I recall I had troubles, but there
wasn't the reclaim_mapped based on static values so it was even
harder. However it would be still a problem today to decide when to
switch from the unmapped to the mapped lru. When reclaim_mapped is
set, you'll still have to shrink some unmapped page, and by splitting
you literally lose age information to save some cpu. Eventually you
risk spending time in trying to free unfreeable pinned pages that sits
in the unmapped list before finally jumping to the mapped list. So
you've to add yet another list to get rid of the pinned stuff in the
unmapped list and I stopped when I had to refile pages from the
"pinned" list to the unmapped list in irq I/O completion context, now
it's all spin_lock_irq so it would be more natural at least...

> 2. There is another parallel thread on implementing page cache
>    limits. If the lists split out, we need not scan the entire
>    list to find page cache pages to evict them.

BTW I'm unsure about the cache limit thread, the overhead of the vm
collection shouldn't be an issue, and those tends to hide vm
inefficiencies.

For example Neil has a patch to reduce the writeback cache to 10M-50M
(much lower than the current 1% minimum) to hide huge unfariness in
the writeback cache. I think they should mount the fs with -o sync
instead of using that patch until the unfariness is fixed or
tunable. The patch itself is fine though but for that problem it only
looks a workaround. So I at least try to be always quite skeptical
when I hear about cache "fixed size limiting" patches that improve
responsiveness or performance ;)

> Of course I might be missing something (some piece of history)

Partly ;) Code was very different back then, today it would be easier
thanks to reclaim_mapped but the partial loss of age information and
potential loss of cpu in a pinned&unmapped walk would probably remain.
