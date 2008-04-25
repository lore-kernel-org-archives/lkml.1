Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbYDYMG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbYDYMG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYDYMGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:06:48 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:58555 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbYDYMGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:06:47 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 25 Apr 2008 22:06:23 +1000
Message-ID: <4811C93F.70001@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com> <20080425083809.GG12774@kernel.dk> <4811BDBB.8010604@hp.com> <20080425112543.GQ12774@kernel.dk>
In-Reply-To: <20080425112543.GQ12774@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> I have the results from leaving in just the one-hit cache merge
>> attempts, and started a run leaving in both that and the back-merge
>> rq_hash checks. (The patch below basically undoes patch 3/3 - putting
>> back in the addition of rqs onto the hash list, and moves the nomerges
>> check below the back merge attempts.)
>>
>> We /could/ change the tunable to a dial (or a mask) - enabling/disabling
>> specific merge attempts, but that seems a bit confusing/complex.
>>
>> Jens: What do you think?
> 
> I think we should keep it simple. I don't particularly like having a
> switch to toggle merges, no one will ever use it. So I'm more inclined
> to just disable front merges unconditionally if the theory of where
> the cycles are spent holds up. We'll still do front merges on the
> one-hit cache, just not spend time looking up an io context and request
> in the rbtree for basically no gain.

Front merging is probably a waste of time, but it could also be a hash table
lookup if you think the rbtree traversal is sinking too many cycles.

I wonder if there's any merit in junking the merge hash (and front-merging in
the ioscheds proper) and just having per-process one-hit caches.  That's going
to catch the majority of merge cases.  For requests that happen to be adjacent
by chance, they are just as likely to be back or front merges.


 -- Aaron
