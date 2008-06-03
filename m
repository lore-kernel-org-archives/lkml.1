Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYFCRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYFCRl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYFCRle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:41:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41713 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbYFCRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:41:32 -0400
X-Sasl-enc: xVhjX73ZbQKyZlYVbQUgZbrlJXnpbMuRBbmH23gyZNyf 1212514890
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603173029.GD28946@ZenIV.linux.org.uk>
References: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:38:16 +0800
Message-Id: <1212514697.3025.120.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 18:30 +0100, Al Viro wrote:
> On Wed, Jun 04, 2008 at 01:13:08AM +0800, Ian Kent wrote:
> 
> > "What happens is that during an expire the situation can arise
> > that a directory is removed and another lookup is done before
> > the expire issues a completion status to the kernel module.
> > In this case, since the the lookup gets a new dentry, it doesn't
> > know that there is an expire in progress and when it posts its
> > mount request, matches the existing expire request and waits
> > for its completion. ENOENT is then returned to user space
> > from lookup (as the dentry passed in is now unhashed) without
> > having performed the mount request.
> > 
> > The solution used here is to keep track of dentrys in this
> > unhashed state and reuse them, if possible, in order to
> > preserve the flags. Additionally, this infrastructure will
> > provide the framework for the reintroduction of caching
> > of mount fails removed earlier in development."
> > 
> > I wasn't able to do an acceptable re-implementation of the negative
> > caching we had in 2.4 with this framework, so just ignore the last
> > sentence in the above description. 
> 
> > Unfortunately no, but I thought that once the dentry became unhashed
> > (aka ->rmdir() or ->unlink()) it was invisible to the dcache. But, of
> > course there may be descriptors open on the dentry, which I think is the
> > problem that's being pointed out.
>  
> ... or we could have had a pending mount(2) sitting there with a reference
> to mountpoint-to-be...
> 
> > Yes, that would be ideal but the reason we arrived here is that, because
> > we must release the directory mutex before calling back to the daemon
> > (the heart of the problem, actually having to drop the mutex) to perform
> > the mount, we can get a deadlock. The cause of the problem was that for
> > "create" like operations the mutex is held for ->lookup() and
> > ->revalidate() but for a "path walks" the mutex is only held for
> > ->lookup(), so if the mutex is held when we're in ->revalidate(), we
> > could never be sure that we where the code path that acquired it.
> > 
> > Sorry, this last bit is unclear.
> > I'll need to work a bit harder on the explanation if you're interested
> > in checking further.
> 
> I am.
> 
> Oh, well...  Looks like RTFS time for me for now...  Additional parts of
> braindump would be appreciated - the last time I've seriously looked at
> autofs4 internal had been ~2005 or so ;-/

You will find other problems.

The other bit to this is the patch to resolve the deadlock issue I spoke
about just above. This is likely where most of the current problems
started and the fact that we have always had to drop the mutex to call
back the daemon.

I can post the patches as well if that helps.

The description accompanying that patch was (the inconsistent locking
referred to here is what was described above):

"Due to inconsistent locking in the VFS between calls to lookup and
revalidate deadlock can occur in the automounter.

The inconsistency is that the directory inode mutex is held for both
lookup and revalidate calls when called via lookup_hash whereas it is
held only for lookup during a path walk. Consequently, if the mutex
is held during a call to revalidate autofs4 can't release the mutex
to callback the daemon as it can't know whether it owns the mutex.

This situation happens when a process tries to create a directory
within an automount and a second process also tries to create the
same directory between the lookup and the mkdir. Since the first
process has dropped the mutex for the daemon callback, the second
process takes it during revalidate leading to deadlock between the
autofs daemon and the second process when the daemon tries to create
the mount point directory.

After spending quite a bit of time trying to resolve this on more than
one occassion, using rather complex and ulgy approaches, it turns out
that just delaying the hashing of the dentry until the create operation
work fine."

Ian


