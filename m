Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbXBJTgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbXBJTgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXBJTgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:36:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXBJTgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:36:06 -0500
Date: Sat, 10 Feb 2007 11:35:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702101054250.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702101114220.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702101034220.11630@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702101054250.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Linus Torvalds wrote:
> 
> But that makes it impossible to do things synchronously, which I think is 
> a *major* mistake.
> 
> The whole (and really _only_) point of my patch was really the whole 
> "synchronous call" part. I'm personally of the opinion that if you cannot 
> handle the cached case as fast as just doing the system call directly, 
> then the whole thing is almost pointless.

Side note: one of the nice things with "do it synchronously if you can" is 
that it also likely would allow us to do a reasonable job at "self-tuning" 
things in the kernel. With my async approach, we get notified only when we 
block, so it'seasy (for example) to have a simple counter that 
automatically adapts to the number of outstanding IO's, in a way that it's 
_not_ if we do things at submit time when we won't even know whether it 
will block or not.

As a trivial example: we actually see what *kind* of blocking it is. Is it 
blocking interruptibly ("long wait") or uninterruptibly ("disk wait")? So 
by the time schedule_async() is called, we actually have some more 
information about the situation, and we can even do different things 
(possibly based on just hints that the user and/or system maintainer gives 
us; ie you can tune the behaviour from _outside_ by setting different 
limits, for example).

			Linus
