Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036Ab0AHCBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0AHCBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768Ab0AHCBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:01:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab0AHCBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:01:52 -0500
Date: Thu, 7 Jan 2010 18:00:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <alpine.LFD.2.00.1001071731440.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001071752240.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box>  <1262909682.2659.45.camel@localhost>  <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
  <1262912601.2659.89.camel@localhost>  <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain> <1262913752.2659.100.camel@localhost> <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain> <alpine.LFD.2.00.1001071731440.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> You cannot mmap a directory (and you can't readdir a non-directory), so if 
> it's a per-inode NFS lock, then the simplest fix _might_ be to just put 
> directory locks in a different lockdep class from non-directory locks. 
> That might fix it.
> 
> Of course, if it's not a per-inode lock, that doesn't help.

Hmm. I notice that we already do this in unlock_new_inode() for i_mutex. 
And I googled for the problem, and it does indeed seem to be about the 
normal i_mutex <-> mmap_sem thing with filldir-vs-mmap.

Is there perhaps some path where NFS creates new inodes without going 
through the normal path? Like the root inode or something? So then you'd 
have a root inode with i_mutex annotated as being in the same class as a 
regular file, which completes the lockdep chain.

Or maybe there is something else I'm missing.

I'm adding Peter and Ingo to the Cc as the "lockdep guys". Maybe they see 
what I am missing.

		Linus
