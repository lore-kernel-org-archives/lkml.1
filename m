Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYLAVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYLAVrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYLAVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:47:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYLAVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:47:16 -0500
Message-ID: <49345B3B.30703@redhat.com>
Date: Mon, 01 Dec 2008 16:46:35 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@saeurebad.de>, torvalds@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] vmscan: protect zone rotation stats by lru lock
References: <E1L6y5T-0003q3-M3@cmpxchg.org> <20081201134112.24c647ff.akpm@linux-foundation.org>
In-Reply-To: <20081201134112.24c647ff.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 01 Dec 2008 03:00:35 +0100
> Johannes Weiner <hannes@saeurebad.de> wrote:
> 
>> The zone's rotation statistics must not be accessed without the
>> corresponding LRU lock held.  Fix an unprotected write in
>> shrink_active_list().
>>
> 
> I don't think it really matters.  It's quite common in that code to do
> unlocked, racy update to statistics such as this.  Because on those
> rare occasions where a race does happen, there's a small glitch in the
> reclaim logic which nobody will notice anyway.
> 
> Of course, this does need to be done with some care, to ensure the
> glitch _will_ be small.

Processing at most SWAP_CLUSTER_MAX pages at once probably
ensures that glitches will be small most of the time.

The only way this could be a big problem is if we end up
racing with the divide-by-two logic in get_scan_ratio,
leaving the rotated pages a factor two higher than they
should be.

Putting all the writes to the stats under the LRU lock
should ensure that never happens.

-- 
All rights reversed.
