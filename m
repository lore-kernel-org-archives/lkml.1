Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbYHOSZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbYHOSZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbYHOSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:25:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244AbYHOSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:25:44 -0400
Message-ID: <48A5C9D8.2030507@linux-foundation.org>
Date: Fri, 15 Aug 2008 13:24:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48986AC6.5030406@linux-foundation.org>	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48A2DD2C.3090602@linux-foundation.org>	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>	 <48A2F030.9080301@linux-foundation.org>	 <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>	 <48A48B00.1090703@linux-foundation.org> <2f11576a0808150944g678f1b8di1c4d50de7358b306@mail.gmail.com>
In-Reply-To: <2f11576a0808150944g678f1b8di1c4d50de7358b306@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>> Then we have another mechanism that will avoid
>> off node memory references by allocating new slabs. Can you set the
>> node_defrag parameter to 0? (Noted by Adrian).
> 
> Please let me know that operations ?

The control over the preferences of node local vs. remote defrag is occurring
via /sys/kernel/slab/<slabcache>/remote_node_defrag ratio. Default is 10%.
Comments in get_any_partial explain the operations.

The default setting means that in 9 out of 10 cases slub will prefer creating
a new slab over taking one from the remote node (meaning the memory is node
local, probably not important in your 2 node case). It will therefore waste
memory because local memory may be more efficient to use.

Setting remote_node_defrag_ratio to 100 will make slub always take the remote
slab instead of allocating a new one.


    /*
         * The defrag ratio allows a configuration of the tradeoffs between
         * inter node defragmentation and node local allocations. A lower
         * defrag_ratio increases the tendency to do local allocations
         * instead of attempting to obtain partial slabs from other nodes.
         *
         * If the defrag_ratio is set to 0 then kmalloc() always
         * returns node local objects. If the ratio is higher then kmalloc()
         * may return off node objects because partial slabs are obtained
         * from other nodes and filled up.
         *
         * If /sys/kernel/slab/xx/defrag_ratio is set to 100 (which makes
         * defrag_ratio = 1000) then every (well almost) allocation will
         * first attempt to defrag slab caches on other nodes. This means
         * scanning over all nodes to look for partial slabs which may be
         * expensive if we do it every time we are trying to find a slab
         * with available objects.
         */
        if (!s->remote_node_defrag_ratio ||
                        get_cycles() % 1024 > s->remote_node_defrag_ratio)
                return NULL;




