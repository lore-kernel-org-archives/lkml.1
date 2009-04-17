Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbZDQR2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbZDQR2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761051AbZDQR2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:28:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760595AbZDQR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:28:06 -0400
Date: Fri, 17 Apr 2009 10:21:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount syscalls
 with a mutex
In-Reply-To: <1239987885.23397.4817.camel@laptop>
Message-ID: <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
References: <1239892078-6039-1-git-send-email-abogani@texware.it>  <20090416160645.GB17804@elte.hu>  <20090416235649.GF26366@ZenIV.linux.org.uk>  <20090417000142.GF21405@elte.hu>  <20090417001345.GH26366@ZenIV.linux.org.uk>  <20090417002744.GB29630@elte.hu>
  <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> Anyway, it seems quite clear that the first thing is to push the current
> BKL usage down into the filesystems -- which should be somewhat
> straight-forward.

Yes, if somebody sends the obvious mechanical patch, we can apply that 
easily. Then, most common filesystems can probably remove the BKL 
trivially by maintainers that know that they don't do anything at all with 
it.

Of course, right now we do hold the BKL over _multiple_ downcalls, so in 
that sense it's not actually totally 100% correct and straightforward to 
just move it down. Eg in the generic_shutdown_super() case we do

	lock_kernel();
	  ->write_super();
	  ->put_super();
	invalidate_inodes();
	unlock_kernel();

and obviously if we split it up so that we push a lock_kernel() into both, 
we end up unlocking in between. I doubt anything cares, but it's still a 
technical difference.

There are similar issues with 'remount' holding the BKL over longer 
sequences.

Btw, the superblock code really does seem to depend on lock_kernel. Those 
"sb->s_flags" accesses are literally not protected by anything else afaik.

That said, I think that fs/locks.c is likely a much bigger issue. Very few 
people care about any realtimeness of mount/unmount/remount. But file 
locking? That is much more likely to be an issue.

And I know we had patches for file locking BKL-removal at some point. What 
happened to them? Were they just broken, or forgotten, or waiting in Jon's 
tree, or what?

		Linus
