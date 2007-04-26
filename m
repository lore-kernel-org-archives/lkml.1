Return-Path: <linux-kernel-owner+w=401wt.eu-S1031350AbXDZRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031350AbXDZRIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031345AbXDZRIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:08:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbXDZRHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:07:32 -0400
Date: Thu, 26 Apr 2007 10:07:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0704261000480.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
 <1177573348.5025.224.camel@nigel.suspend2.net>
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Linus Torvalds wrote:
> 
> Once you have that snapshot image in user space you can do anything you 
> want.

Side note: the exception, of course, is page out more. The swap device has 
to be read-only.

We actually have support for that mode (it's how "swapoff" works: it marks 
swap devices as not accepting _new_ entries, even though old entries are 
still valid). So you can have a fully running system, with 99% of memory 
swapped out, and still guarantee that you won't swap out anything *more* 
(which would destroy the swap image, which you don't want, since it's 
where a lot of the memory may end up being, in order to make the snapshot 
itself as small as possible)!

Anybody who cares can look at the code that messes with the the 
SWP_WRITEOK flag. You'd basically swap out enough to make the snapshot 
image fit comfortably in memory, and then you'd clear SWP_WRITEOK on all 
swap devices and return to user space. Or something very close to that.

But the point here is that we should actually really be able to have a 
fully working system, even _after_ we created the snapshot. I don't even 
think you should need any "initrd only" kind of situation.

If somebody can do that, with just those two system calls, I'll remove 
every other suspend-to-disk wannabe from the kernel in a heartbeat. I may 
have missed something subtle, of course, but I really *think* it should be 
doable.

			Linus
