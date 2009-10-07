Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbZJGQcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbZJGQcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934245AbZJGQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:32:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759549AbZJGQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:32:08 -0400
Date: Wed, 7 Oct 2009 09:27:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Linus Torvalds wrote:
> 
> Hmm. Regardless, this very much does look like what I envisioned, apart 
> from details like that. And maybe your per-dentry seqlock is the right 
> choice. On x86, it certainly doesn't have the performance issues it could 
> have in other places.

Actually, if we really want to do the per-dentry thing, then we should 
change it a bit. Maybe rather than using a seqlock data structure (which 
is really just a unsigned counter and a spinlock), we could do just the 
unsigned counter, and use the d_lock as the spinlock for the sequence 
lock.

The hackiest way to do that woudl be to get rid of d_lock entirely, 
replace it with d_seqlock, and then just do

	#define d_lock d_seqlock.lock

instead (but the dentry structure may well have layout issues that makes 
that not work very well - we're mixing pointers and 'int'-sized things 
and need to pack them well etc).

That would cut down the seqlock memory costs from 8 bytes (or more - just 
the spinlock itself is currently 8 bytes on ia64, so on ia64 the seqlock 
is actually 16 bytes, not to mention all the spinlock debugging cases) to 
just four bytes.

However, I still suspect we could do things entirely without the seqlock. 
The outer seqlock will handle the "couldn't find it" case, and I've got 
the strongest feeling that we should be able to just use some basic memory 
ordering on the dentry hash to make the inner seqlock unnecessary (ie 
make sure that either we don't see the old entry at all, or that we can 
guarantee that it won't trigger a successful compare while the rename is 
in process because we set the dentry name length to zero).

			Linus
