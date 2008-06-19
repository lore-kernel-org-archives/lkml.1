Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYFSAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYFSAVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYFSAVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947AbYFSAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:21:07 -0400
Date: Wed, 18 Jun 2008 17:20:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Mueller <robm@fastmail.fm>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Ken Murchison <murch@andrew.cmu.edu>
Subject: Re: Cyrus mmap vs lseek/write usage - (WAS: BUG: mmapfile/writev
 spurious zero bytes (x86_64/not i386, bisected, reproducable))
In-Reply-To: <1213832759.32537.1259210597@webmail.messagingengine.com>
Message-ID: <alpine.LFD.1.10.0806181704310.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
 <20080618031406.GA4326@brong.net> <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org> <20080618051119.GA10754@brong.net> <alpine.LFD.1.10.0806180858250.2907@woody.linux-foundation.org> <1213832759.32537.1259210597@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2008, Robert Mueller wrote:
> 
> As noted above, one thing cyrus does which does seem to be plain "wrong"
> is that it mmaps a region greater the file size (rounds to an 8k
> boundary, but 8k-16k past the current end of the file) and then assumes
> that when it writes to the end of the file (but less than the end of the
> mmap region) that there's no need to remmap and that data is immediately
> available within the previous mmaped region.

Pretty much any OS that tries to be make mmap() coherent with regular 
read/write accesses will automatically also have to be coherent wrt file 
size updates.

IOW, I don't think that cyrus is real any more "wrong" in this than in 
assuming that you can mix read/write and mmap() accesses. In fact, I 
suspect that Cyrus is probably _more_ conservative than most, in that it 
would not be totally unheard of to just do a much bigger mmap(), and not 
even bother to re-do it until the file grows past that size (ie no 8k/16k 
granularity, but make it arbitrarily non-granular).

> Apparently that works on most OS's (but is what this bug actually
> exposed), but according to the mmap docs:
> 
> ---
> If the size of the mapped file changes after the call to mmap() as a
> result of some other operation on the mapped file, the effect of
> references to portions of the mapped region that correspond to added or
> removed portions of the file is unspecified.

Note that if you really want to be portable, you simply must not mix 
mmap() with *any* other operations without sprinking in a healthy amount 
of "msync()" or unmapping/remapping entirely.

So _in_practice_ - because everybody tries to do a good job - you can 
actually expect to have mmap() be coherent, even though there are no real 
guarantees. 

> Amazingly (apart from HP/UX) no OS actually seems to have a problem with 
> this since there would be massive cyrus bug reports otherwise.

Yeah. Over the years, the pain from having a non-coherent mmap() generally 
has pushed everybody into just making mmap() easy to use. Which means that 
mixing things generally works fine, even if it is not at all _guaranteed_. 

So I'd expect mmap+write to work and be coherent almost always. But it's 
still a fairly unusual combination, and I would personally think that 
using MAP_SHARED and writing through the mmap() would be the less 
surprising model.

		Linus
