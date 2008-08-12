Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYHLVYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYHLVYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYHLVYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:24:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYHLVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:24:37 -0400
Date: Tue, 12 Aug 2008 14:24:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812205943.GX28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121415390.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
 <20080812205943.GX28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Al Viro wrote:
> 
> Um...  Here it would happen only on attempt to return an entry for file
> that really has an inumber not fitting into the field; what would you
> do in such case?

You'd truncate the inode number. What's the big deal? Inode numbers aren't 
that important - they're just about the _least_ important part of the data 
returned for a readdir. 

Sure, truncating the inode number may confuse some programs like old-style 
/bin/pwd, but the thing is, we effectively _already_ do that by generating 
essentially random numbers for filesystems that don't have UNIX-style 
inode numbers anyway, so what's the big deal really?

> open() on a huge file is a different story, since you would get a valid 
> opened file and that'd be it; the logics in case of open() is, IIRC, "I 
> guess your binary is old, so it'll probably do other things that would 
> really have to trigger -EOVERFLOW; better bail out right now". 

The thing is, the "probably" is likely "probably not". There's a lot of 
things that work quite well.  Sure, if you lseek() you get confused. If 
you do "stat()" and then mmap(), you'll get confused. But a lot of 
programs really do just read/write. Or use llseek(), in fact. O_LARGEFILE 
is actually a later thing tan llseek() was.

So the problem with EOVERFLOW is that it says that programs shouldn't do 
anything at all because they _may_ do bad things.

And don't get me wrong - I think EOVERFLOW was (and is) actually a good 
thing for the _transition_ period. Exactly because it breaks programs in 
obvious ways, and early. It's good to be annoying in order to find 
problems early and fix them.

But I also think that we're not in a transition period any more, and as a 
result the annoyance part is just annoying an doesn't help find and fix 
problems any more, it just makes legacy binaries not work even if they 
could otherwise work fine (and _maybe_ have problems).

So something that made sense five years ago may not make sense any more, 
is what I'm saying. These days, if somebody runs legacy binaries, they do 
it because of archeology reasons or similar..

			Linus
