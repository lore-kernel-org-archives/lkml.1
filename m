Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYENV6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYENV6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbYENV5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:57:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757383AbYENV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:57:45 -0400
Date: Wed, 14 May 2008 14:56:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree 
In-Reply-To: <6457.1210801515@vena.lwn.net>
Message-ID: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org>
References: <6457.1210801515@vena.lwn.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Jonathan Corbet wrote:
> 
> There's also every char device open() method - a rather long list in its
> own right.  I'd be surprised if one in ten of them really needs it, but
> one has to look...

I don't think there are *that* many. I found only 83 instances of 
"register_chrdev()" in the kernel, so the open methods should be pretty 
limited.

Of course, some open methods call other sub-registrations, but you'd start 
off by moving the lock_kernel() down just *one* stage. 

So it literally should be:
 - remove one lock_kernel/unlock_kernel pair in fs/char_dev.c
 - add max 83 pairs in the places that register those things
 - external modules will need to add it themselves some day.

> 1: We could add an unlocked_open() to the file_operations structure;
>    drivers could be converted over as they are verified not to need the
>    BKL on open.  Disadvantages are that it grows this structure for a
>    relatively rare case - most open() calls already don't need the BKL.
>    But it's a relatively easy path without flag days.

I really don't think it's worth the pain. See above. The numbers aren't 
that huge, and external modules simply aren't a pressing enough issue.

		Linus
