Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYHTAoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYHTAoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYHTAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:43:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYHTAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:43:57 -0400
Date: Tue, 19 Aug 2008 17:43:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Trojanowski <bart@jukie.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
In-Reply-To: <20080820001845.GC28029@jukie.net>
Message-ID: <alpine.LFD.1.10.0808191729330.3324@nehalem.linux-foundation.org>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org> <20080820001845.GC28029@jukie.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Bart Trojanowski wrote:
> 
> So, maybe it would be a good idea to have a 'delaysync=60' to force a
> sync after 60 seconds of inactivity.  Unless, there is something else
> that would do that for me already.

Oh, it could be even shorter.

The problem with using 'sync' is that it easily ends up overwriting things 
like the sector that contains a particular inode thousands of times for 
even trivial operations. Or things like the file allocation table etc.

For example, something as trivial as copying a single big file, if the 
copy program just copies it a few kB at a time, then a file that is a few 
megabytes in size will actually end up rewriting the inode block (just 
because the size grows) thousands of time. 

With any kind of half-way decent wear leveling, this isn't a problem at 
all, and most flash drives have that. But if they don't, then that means 
that the file allocation table sectors and the inode sectors get rewritten 
over and over and over again thousands of times.

Just making it do the sync once per _second_ or something like that would 
already make the "thousands of times" go away. The sectors would probably 
be rewritten a few times per big file, and just once per couple of tens of 
files for small files being written.

So we don't even need anything like 60 seconds, we literally would just 
need some trivial delays.

But no, we don't have that kind of "half-sync" behavior. Right now, it's 
pretty much all or nothing.  Either we're fully synchronous (and that 
really is bad for crappy flash), or we end up depending on bdflush writing 
things back in the background.

Of course, pdflush already syncs within 60s (in fact, 30s by default, 
iirc), but then things like "laptop_mode" will actually make that 
potentially much less frequent (I think the default value for that is 5 
minutes).

I do think this is something we could do better, no question about it.

But I don't know exactly what the timeout should be, though (although I 
suspect that it should involve _ignoring_ non-data writes like the atime 
updates, and trigger a timeout on data writes so that when you actually 
write a file, you'll know that the sync will happen within five seconds of 
you having finished the write or whatever).

And no, no such mount option currently exists. And the pdflush things are 
all global, not per-device, iirc.

		Linus
