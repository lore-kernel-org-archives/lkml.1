Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZJGO6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZJGO6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbZJGO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:58:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759424AbZJGO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:58:02 -0400
Date: Wed, 7 Oct 2009 07:56:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <20091007085849.GN30316@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Nick Piggin wrote:
> 
> OK, I have a really basic patch that does store-free path walking
> (except on the final element).

Yay!

> dbench is pretty nasty still because it seems to do a lot of stupid 
> things like reading from /proc/mounts all the time.

You should largely forget about dbench, it can certainly be a useful 
benchmark, but at the same time it's certainly not a _meaningful_ one.
There are better things to try.

> The seqlock in the dentry is for getting consistent name,len pointer,
> and also not giving a false positive if a rename has partially
> overwritten the name string (false negatives are always fine in the
> lock free lookup path but false positives are not). Possibly we
> could make do with a per-sb seqlock for this (or just rename_lock).

My plan was always to just use rename_lock, and only do it at the outer 
level (and do it for both lookup failures _and_ for the success case). 
Your approach is _way_ more conservative than I would have done, and also 
potentially much slower due to the seqlock-per-path-component thing. 

Remember: seqlocks are almost free on x86, but they can be reasonably 
expensive in other places.

Hmm. Regardless, this very much does look like what I envisioned, apart 
from details like that. And maybe your per-dentry seqlock is the right 
choice. On x86, it certainly doesn't have the performance issues it could 
have in other places.

I'd like Al to take a look, if he's around.

			Linus
