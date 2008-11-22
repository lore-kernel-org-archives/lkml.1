Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYKVQ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYKVQ63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 11:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbYKVQ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 11:58:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbYKVQ6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 11:58:19 -0500
Message-ID: <49283A05.1060009@redhat.com>
Date: Sat, 22 Nov 2008 11:57:41 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max
 pages
References: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115235410.2d2c76de.akpm@linux-foundation.org> <20081122191258.26B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081122191258.26B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> Rik, sorry, I nak current your patch. 
> because it don't fix old akpm issue.

You are right.  We do need to keep pressure between zones
equivalent to the size of the zones (or more precisely, to
the number of pages the zones have on their LRU lists).

However, having dozens of direct reclaim tasks all getting
to the lower priority levels can be disastrous, causing
extraordinarily large amounts of memory to be swapped out
and minutes-long stalls to applications.

I think we can come up with a middle ground here:
- always let kswapd continue its rounds
- have direct reclaim tasks continue when priority == DEF_PRIORITY
- break out of the loop for direct reclaim tasks, when
   priority < DEF_PRIORITY and enough pages have been freed

Does that sound like it would mostly preserve memory pressure
between zones, while avoiding the worst of the worst when it
comes to excessive page eviction?

-- 
All rights reversed.
