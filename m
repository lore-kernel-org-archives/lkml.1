Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675Ab0ANNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0ANNTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226Ab0ANNTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:19:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0ANNTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:19:18 -0500
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001071752240.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
	 <1262909682.2659.45.camel@localhost>
	 <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
	 <1262912601.2659.89.camel@localhost>
	 <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
	 <1262913752.2659.100.camel@localhost>
	 <alpine.LFD.2.00.1001071727490.7821@localhost.localdomain>
	 <alpine.LFD.2.00.1001071731440.7821@localhost.localdomain>
	 <alpine.LFD.2.00.1001071752240.7821@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 14:18:47 +0100
Message-ID: <1263475127.4244.327.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 18:00 -0800, Linus Torvalds wrote:
> 
> On Thu, 7 Jan 2010, Linus Torvalds wrote:
> > 
> > You cannot mmap a directory (and you can't readdir a non-directory), so if 
> > it's a per-inode NFS lock, then the simplest fix _might_ be to just put 
> > directory locks in a different lockdep class from non-directory locks. 
> > That might fix it.
> > 
> > Of course, if it's not a per-inode lock, that doesn't help.
> 
> Hmm. I notice that we already do this in unlock_new_inode() for i_mutex. 
> And I googled for the problem, and it does indeed seem to be about the 
> normal i_mutex <-> mmap_sem thing with filldir-vs-mmap.
> 
> Is there perhaps some path where NFS creates new inodes without going 
> through the normal path? Like the root inode or something? So then you'd 
> have a root inode with i_mutex annotated as being in the same class as a 
> regular file, which completes the lockdep chain.

Quite possible, but I got lost trying to find anything like the root
inode.

> Or maybe there is something else I'm missing.
> 
> I'm adding Peter and Ingo to the Cc as the "lockdep guys". Maybe they see 
> what I am missing.

Not really, nfs_fhget() seems to know about directories as it has a
S_ISDIR() check of itself before doing unlock_new_inode(), so I would
expect unlock_new_inode() to indeed set the
file_system_type::i_mutex_dir_key.



