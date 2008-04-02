Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbYDBVDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbYDBVDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYDBVD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:03:29 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:49817 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYDBVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:03:28 -0400
Date: Wed, 2 Apr 2008 23:03:27 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
 <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Linus Torvalds wrote:

> On Wed, 2 Apr 2008, Mikulas Patocka wrote:
> > +	/*
> > +	 * Make sure that the test for buffer_dirty(bh) is not reordered with
> > +	 * previous modifications to the buffer data.
> > +	 * -- mikulas
> > +	 */
> > +	smp_mb();
> >  	WARN_ON_ONCE(!buffer_uptodate(bh));
> >  	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
> 
> At that point, the better patch is to just *remove* the buffer_dirty() 
> test, and rely on the stronger ordering requirements of 
> test_set_buffer_dirty().
> 
> The whole - and only - point of the buffer_dirty() check was to avoid the 
> more expensive test_set_buffer_dirty() call, but it's only more expensive 
> because of the barrier semantics. So if you add a barrier, the point goes 
> away and you should instead remove the optimization.
> 
> (I also seriously doubt you can actually trigger this in real life, but 
> simplifying the code is probably fine regardless).
> 
> 		Linus

I measured it:
On Core2, mfence is faster (8 ticks) than lock btsl (27 ticks)
On Pentium-4-prescott, mfence is 124 ticks and lock btsl is 86 ticks.
On Pentium-4-pre-prescott, mfence wins again (100) and lock btsl is 120.
On Athlon, mfence is 16 ticks and lock btsl is 19 ticks.

So you're right, the gain of mfence is so little that you can remove it 
and use only test_set_buffer_dirty.

I don't know if there are other architectures where smb_mb() would be 
significantly faster than test_and_set_bit.

Mikulas
