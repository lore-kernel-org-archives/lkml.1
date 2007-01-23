Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbXAWBuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbXAWBuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbXAWBuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:50:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548AbXAWBuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:50:17 -0500
Message-ID: <45B56823.7050104@redhat.com>
Date: Mon, 22 Jan 2007 20:42:59 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@in.ibm.com
CC: Andrea Arcangeli <andrea@suse.de>, Niki Hammler <mailinglists@nobaq.net>,
       linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com>
In-Reply-To: <45B56575.10807@in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

> This makes me wonder if it makes sense to split up the LRU into page
> cache LRU and mapped pages LRU. I see two benefits

Unlikely.  I have seen several workloads fall over because they
did not throw out mapped pages soon enough.

If the kernel does not keep the most frequently accessed pages
resident, hit rates will suffer.  Sometimes (well, usually)
those are the mapped pages, but this is not true in all workloads.

Some workloads are very page cache heavy and it pays to keep
the more frequently accessed page cache pages resident while
discarding the less frequently accessed ones.

Since memory size has increased a lot more than disk speed
over the last decade (and this is likely to continue for the
next decades), the quality of page replacement algorithms is
likely to become more and more important over time.

> 1. Currently based on swappiness, we might walk an entire list
>    searching for page cache pages or mapped pages. With these
>    lists separated, it should get easier and faster to implement
>    this scheme

How do you classify a mapped page cache page?

Another issue is that you'll want to make sure that the page
cache pages that are referenced more frequently than the least
referenced mapped (I assume you mean anonymous?) pages in
memory, while swapping out those least used anonymous pages.

One way to do this could be to compare the scan rates, list
sizes and referenced percentage of both lists, to find out
which of the two caches is hotter.

> 2. There is another parallel thread on implementing page cache
>    limits. If the lists split out, we need not scan the entire
>    list to find page cache pages to evict them.

If the lists split out, there is no reason to limit the page
cache size because you can easily reclaim them.  Right?

> Of course I might be missing something (some piece of history)

http://linux-mm.org/AdvancedPageReplacement

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
