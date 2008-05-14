Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYENVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYENVqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYENVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:46:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbYENVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:46:43 -0400
Date: Wed, 14 May 2008 14:45:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
In-Reply-To: <20080514221957.6edb2d60@core>
Message-ID: <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
References: <20080514174955.GA515@elte.hu> <87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core> <482B5614.3060203@firstfloor.org> <20080514221957.6edb2d60@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Alan Cox wrote:
> 
> That in itself is a problem Ingo's stuff won't help with: We have lots of
> "magic" accidental, undocumented and pot luck BKL locking semantics
> between subsystems that are not even visible.

The good news is that I suspect they are going away. It probably is mainly 
tty and /proc by now, and /proc is pretty close to done.

It's hard to have too many inter-module dependencies when most of the core 
modules no longer even take the kernel lock any more.

In the VFS layer, we still have 

 - the ioctl thing, obviously. That's just mind-numbing "move things 
   down", not hard per se. But there's a *lot* of them (and I suspect the 
   huge majority of them don't actually need it, since they'd already be 
   racing against read/write anyway if they did).

 - default_llseek(). Probably the same, just a lot less of it.

 - superblock read/write.

and the latter one in particular is really dubious (we already have 
"[un]lock_super()" around it all, I think).

The core kernel, VM and networking already don't really do BKL. And it's 
seldom the case that subsystems interact with other unrelated subsystems 
outside of the core areas.

So it's a lot of work, no doubt, but I do think we should be able to do 
it. The most mind-numbing part is literally all the ioctl crud. There's 
more ioctl points than there are lock_kernel() calls left anywhere else.

		Linus
