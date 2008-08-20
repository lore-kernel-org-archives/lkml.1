Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYHTA4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYHTA4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYHTA4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:56:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbYHTA4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:56:43 -0400
Date: Tue, 19 Aug 2008 17:56:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Trojanowski <bart@jukie.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
In-Reply-To: <alpine.LFD.1.10.0808191729330.3324@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808191748040.3324@nehalem.linux-foundation.org>
References: <20080819220311.GA28029@jukie.net> <alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org> <20080820001845.GC28029@jukie.net> <alpine.LFD.1.10.0808191729330.3324@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Linus Torvalds wrote:
> 
> But I don't know exactly what the timeout should be, though (although I 
> suspect that it should involve _ignoring_ non-data writes like the atime 
> updates, and trigger a timeout on data writes so that when you actually 
> write a file, you'll know that the sync will happen within five seconds of 
> you having finished the write or whatever).

.. and by "finished the write" I mean "closed the file", not "end of 
write() system call". Ie it's one of those things where it really doesn't 
mostly make much sense to try to give any kinds of flush guarantees until 
the user has basically shown that he's all done with writing.

If you have something like removable media, and you actually remove it 
while you have a "cp -R" in progress, it damn well won't matter whether we 
were synchronous or not. But if you remove it after the "cp" has actually 
finished, it's a lot more understandable if somebody expects it to be on 
disk.

So one thing we could perhaps consider is to make FAT in particular 
consider "sync" mounts to be about open/close consistency, not about 
per-write-system-call consistency. So the "close()" wouldn't return until 
the file is on disk, but we wouldn't force a synchronous rewrite the inode 
or the file allocation table thousands of times just because the file was 
big.

FAT really is kind of different. I suspect we could just change what 
"sync" means for it. But it would probably be good to have a VFS-level 
notion of open-close consistency. It is, after all, what NFS is already 
supposed to give you, so there is precedence for that being a useful IO 
serialization model.

Al, what do you think?

		Linus
