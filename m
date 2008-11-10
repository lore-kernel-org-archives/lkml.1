Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYKJQAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYKJQAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYKJQAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:00:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYKJQAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:00:31 -0500
Date: Mon, 10 Nov 2008 08:00:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
In-Reply-To: <20081110120959.GC26778@kernel.dk>
Message-ID: <alpine.LFD.2.00.0811100754210.3468@nehalem.linux-foundation.org>
References: <4917C449.2080504@kernel.org> <20081110120533.GB26778@kernel.dk> <20081110120959.GC26778@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2008, Jens Axboe wrote:
> > 
> > Or we could just change the blk-tag.c logic to stop of
> > find_first_zero_bit() returns >= some_value instead of starting at an
> > offset? You don't need any extra locking for that.
> 
> Something like the below.

No, there were two reasons for doing it the way I did it, and this shows 
both. One trivial, one subtle.

> +	if (!rq_is_sync(rq))
> +		max_depth = 3 * max_depth / 4;

The trivial one here is that you round down. Imagine what happens if 
"max_depth" was 1.

The subtler one was that the 'use starting offset' means that async and 
sync can _share_ the tagspace, and while you limit async ones to a maximum 
outstanding number, you really cut down on them only when sync ones really 
have filled everything up.

In contrast, limiting like the above means that it's much easier to be in 
the situation where you still have tags to use, but you've used them all 
for reads, and you refuse to start a single write.

Anyway, I'll do the revert, since -rc4 is too late to discuss these 
issues. I think we can easily re-do things when everybody is ok with the 
code.

			Linus

