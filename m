Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYFCRQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYFCRQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYFCRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:16:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60715 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbYFCRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:16:26 -0400
X-Sasl-enc: KUazX8IDCkJVzstPFiiikFkJcOtE1tX31hqJbZx6zktv 1212513383
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:13:08 +0800
Message-Id: <1212513189.3025.101.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 09:35 -0700, Linus Torvalds wrote:
> 
> On Wed, 4 Jun 2008, Ian Kent wrote:
> > 
> > The code we're talking about deals with a race between expiring and
> > mounting an autofs mount point at the same time. 
> > 
> > I'll have a closer look and see if I can make it work without turning
> > the dentry negative.
> 
> Hmm.
> 
> Can you walk me through this?
> 
> If the dentry is unhashed, it means that it _either_
> 
>  - has already been deleted (rmdir'ed) or d_invalidate()'d. Right?

In the current code the only way a dentry gets onto this list is by one
of the two operations ->unlink() or ->rmdir(), it is d_drop'ed and left
positive by both of these operations (a carry over from 2.4 when
d_lookup() returned unhashed dentrys, I missed that detail for quite a
while).

> 
>    I don't see why you should ever return the dentry in this case..

It's been a while now but the original patch description should help.

"What happens is that during an expire the situation can arise
that a directory is removed and another lookup is done before
the expire issues a completion status to the kernel module.
In this case, since the the lookup gets a new dentry, it doesn't
know that there is an expire in progress and when it posts its
mount request, matches the existing expire request and waits
for its completion. ENOENT is then returned to user space
from lookup (as the dentry passed in is now unhashed) without
having performed the mount request.

The solution used here is to keep track of dentrys in this
unhashed state and reuse them, if possible, in order to
preserve the flags. Additionally, this infrastructure will
provide the framework for the reintroduction of caching
of mount fails removed earlier in development."

I wasn't able to do an acceptable re-implementation of the negative
caching we had in 2.4 with this framework, so just ignore the last
sentence in the above description. 

> 
>  - or it has not yet been hashed at all

It has been previously hashed, yes.

> 
>    But then d_inode should be NULL too, no?

Unfortunately no, but I thought that once the dentry became unhashed
(aka ->rmdir() or ->unlink()) it was invisible to the dcache. But, of
course there may be descriptors open on the dentry, which I think is the
problem that's being pointed out.

> 
> Anyway, as far as I can tell, you should handle the race between expiring 
> and re-mounting not by unhashing at expire time (which causes these kinds 
> of problems), but by setting a bit in the dentry and using the dentry 
> "revalidate()" callback to wait for the revalidate.

Yes, that would be ideal but the reason we arrived here is that, because
we must release the directory mutex before calling back to the daemon
(the heart of the problem, actually having to drop the mutex) to perform
the mount, we can get a deadlock. The cause of the problem was that for
"create" like operations the mutex is held for ->lookup() and
->revalidate() but for a "path walks" the mutex is only held for
->lookup(), so if the mutex is held when we're in ->revalidate(), we
could never be sure that we where the code path that acquired it.

Sorry, this last bit is unclear.
I'll need to work a bit harder on the explanation if you're interested
in checking further.

Anyway, I'm sure I made the dentry negative upon getting a rehash hit
for a reason so I'll need to revisit it. Perhaps I was misguided in the
first place or perhaps just plain lazy.

Ian


