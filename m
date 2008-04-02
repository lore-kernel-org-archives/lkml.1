Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYDBWfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYDBWfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYDBWfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:35:41 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:54399 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYDBWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:35:40 -0400
Date: Thu, 3 Apr 2008 00:35:39 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804030022400.15850@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Linus Torvalds wrote:

> On Wed, 2 Apr 2008, Mikulas Patocka wrote:
> > 
> > So you're right, the gain of mfence is so little that you can remove it 
> > and use only test_set_buffer_dirty.
> 
> Well, I suspect that part of the issue is that quite often you end up 
> with *both* because the buffer wasn't already dirty from before.
> 
> Re-dirtying a dirty buffer is pretty common for things like bitmap blocks 
> etc, so it's probably a worthy optimization if it has no cost, and on 
> Core2 I suspect your version is worth it, but it's not like it's going to 
> be necessarily a 99% kind of case. I suspect quite a lot of the 
> mark_buffer_dirty() calls are actually on clean buffers.

The cost of doing the buffer lookup and update is much more than the 20 
clocks, so the 20 clocks mfence/lock difference can be forgotten.

> (Of course, a valid argument is that if it was already dirty, we'll skip 
> the other expensive parts, so only the "already dirty" case is worth 
> optimizing for. Maybe true. There might also be cases where it means one 
> less dirty cacheline in memory.)

That is another good example: when two CPUs are simultaneously updating 
the same buffer (i.e. two inodes in one block or simultaneous writes to a 
bitmap), then test_set_buffer_dirty will do cache ping-pong (that is much 
more expensive than that 20-100 cycles for an interlocked instruction), 
and smp_mb()+test_buffer_dirty will keep cache intact.

So maybe there's still a reason for smb_mb().

Mikulas

