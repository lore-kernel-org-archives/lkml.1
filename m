Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYDBVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYDBVcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbYDBVb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:31:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760188AbYDBVb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:31:57 -0400
Date: Wed, 2 Apr 2008 14:31:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.1.00.0804021422570.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz> <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0804022238460.25023@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Mikulas Patocka wrote:
> 
> So you're right, the gain of mfence is so little that you can remove it 
> and use only test_set_buffer_dirty.

Well, I suspect that part of the issue is that quite often you end up 
with *both* because the buffer wasn't already dirty from before.

Re-dirtying a dirty buffer is pretty common for things like bitmap blocks 
etc, so it's probably a worthy optimization if it has no cost, and on 
Core2 I suspect your version is worth it, but it's not like it's going to 
be necessarily a 99% kind of case. I suspect quite a lot of the 
mark_buffer_dirty() calls are actually on clean buffers.

(Of course, a valid argument is that if it was already dirty, we'll skip 
the other expensive parts, so only the "already dirty" case is worth 
optimizing for. Maybe true. There might also be cases where it means one 
less dirty cacheline in memory.)

> I don't know if there are other architectures where smb_mb() would be 
> significantly faster than test_and_set_bit.

Probably none, since it test_and_set_bit() implies a smp_mb(), and 
generally the bigger cost is in the barrier than in the bit setting 
itself.

Core 2 is the outlier in having a noticeably faster "mfence" than atomic 
instructions (and judging by noises Intel makes, Nehalem will undo that 
outlier).

				Linus
