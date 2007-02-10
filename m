Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbXBJTDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbXBJTDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXBJTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:03:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXBJTDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:03:06 -0500
Date: Sat, 10 Feb 2007 11:01:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702101034220.11630@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702101054250.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702101034220.11630@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Davide Libenzi wrote:
> 
> For the queue approach, I meant the async_submit() to simply add the 
> request (cookie, syscall number and params) inside queue, and not trying 
> to execute the syscall. Once you're inside schedule, "stuff" has already 
> partially happened, and you cannot have the same request re-initiated by a 
> different thread.

But that makes it impossible to do things synchronously, which I think is 
a *major* mistake.

The whole (and really _only_) point of my patch was really the whole 
"synchronous call" part. I'm personally of the opinion that if you cannot 
handle the cached case as fast as just doing the system call directly, 
then the whole thing is almost pointless.

Things that take a long time we already have good methods for. "epoll" and 
"kevent" are always going to be the best way to handle the "we have ten 
thousand events outstanding". There simply isn't any question about it. 
You can *never* handle ten thousand long-running events efficiently with 
threads - even if you ignore all the CPU overhead, you're going to have a 
much bigger memory (and thus *cache*) footprint.

So anybody who wants to use AIO to do those kinds of long-running async 
things is out to lunch. It's not the point. 

You use the AIO stuff for things that you *expect* to be almost 
instantaneous. Even if you actually start ten thousand IO's in one go, and 
they all do IO, you would hopefully expect that the first ones start 
completingn before you've even submitted them all. If that's not true, 
then you'd just be better off using epoll.

Also, if you can make the cached case as fast as just doing the direct 
system call itself, that just changes the whole equation for using it. You 
suddenly don't have any downsides. You can start using the async 
interfaces in places you simply couldn't otherwise, or in places where 
you'd have to do a lot of performance tuning ("it makes sense under this 
particular load because I actually need to get 100 IO's going at the same 
time to saturate the disk").

So the "do cached things synchronously" really is important. Just because 
that makes a whole complicated optimization question go away: you 
basically *always* win for normal stuff.

		Linus
