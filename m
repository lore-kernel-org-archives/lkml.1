Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYDBXwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYDBXwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbYDBXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:52:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235AbYDBXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:52:28 -0400
Date: Wed, 2 Apr 2008 16:52:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <20080402150158.f366370f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804021645560.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <20080402150158.f366370f.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Andrew Morton wrote:
> 
> But then the test-and-set of an already-set flag would newly cause the
> cacheline to be dirtied, requiring additional bus usage to write it back?

Looking around a bit, I don't see any realistic case where this could 
possibly be the case and that is performance-sensitive.

The VFS-level uses of mark_buffer_dirty() seem to all be coupled with 
other uses that clear or set other bits in the buffer status word, so the 
cacheline will always apparently be dirty. 

The low-level filesystems sometimes do it for things like block bitmap 
changes, and I could imagine that there it actually (a) is no longer in 
the cache and (b) the buffer really was dirty to start with, but in ext3 
for example, you'd end up in journal_dirty_metadata which spinlocks on the 
BH_State bit first etc etc.

So the cacheline *will* be dirty, and this function doesn't seem like it 
could possibly ever show up in a real profile for any real load anyway, so 
it seems odd to try to optimize it this way.

			Linus
