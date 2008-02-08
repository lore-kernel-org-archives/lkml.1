Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbYBHPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbYBHPNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbYBHPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:13:13 -0500
Received: from mga10.intel.com ([192.55.52.92]:65022 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbYBHPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:13:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,322,1199692800"; 
   d="scan'208";a="515372986"
Message-ID: <47AC7093.1070003@linux.intel.com>
Date: Fri, 08 Feb 2008 07:09:07 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, mingo@elte.hu, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, dgc@sgi.com,
       npiggin@suse.de, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       penberg@gmail.com
Subject: Re: [patch] block layer: kmemcheck fixes
References: <20080207103136.GG15220@kernel.dk>	<20080207104901.GF16735@elte.hu>	<alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org> <20080207.172246.31415231.davem@davemloft.net>
In-Reply-To: <20080207.172246.31415231.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 7 Feb 2008 09:42:56 -0800 (PST)
> 
>> Can we please just stop doing these one-by-one assignments, and just do 
>> something like
>>
>> 	memset(rq, 0, sizeof(*rq));
>> 	rq->q = q;
>> 	rq->ref_count = 1;
>> 	INIT_HLIST_NODE(&rq->hash);
>> 	RB_CLEAR_NODE(&rq->rb_node);
>>
>> instead?
>>
>> The memset() is likely faster and smaller than one-by-one assignments 
>> anyway, even if the one-by-ones can avoid initializing some field or there 
>> ends up being a double initialization..
> 
> The problem is store buffer compression.  At least a few years
> ago this made a huge difference in sk_buff initialization in the
> networking.
> 
> Maybe cpus these days have so much store bandwith that doing
> things like the above is OK, but I doubt it :-)

on modern x86 cpus the memset may even be faster if the memory isn't in cache;
the "explicit" method ends up doing Write Allocate on the cache lines
(so read them from memory) even though they then end up being written entirely.
With memset the CPU is told that the entire range is set to a new value, and
the WA can be avoided for the whole-cachelines in the range.

