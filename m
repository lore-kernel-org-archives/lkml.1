Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYFCRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYFCRar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYFCRag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:30:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49898 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYFCRaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:30:35 -0400
Date: Tue, 3 Jun 2008 18:30:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603173029.GD28946@ZenIV.linux.org.uk>
References: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu> <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org> <1212513189.3025.101.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212513189.3025.101.camel@raven.themaw.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 01:13:08AM +0800, Ian Kent wrote:

> "What happens is that during an expire the situation can arise
> that a directory is removed and another lookup is done before
> the expire issues a completion status to the kernel module.
> In this case, since the the lookup gets a new dentry, it doesn't
> know that there is an expire in progress and when it posts its
> mount request, matches the existing expire request and waits
> for its completion. ENOENT is then returned to user space
> from lookup (as the dentry passed in is now unhashed) without
> having performed the mount request.
> 
> The solution used here is to keep track of dentrys in this
> unhashed state and reuse them, if possible, in order to
> preserve the flags. Additionally, this infrastructure will
> provide the framework for the reintroduction of caching
> of mount fails removed earlier in development."
> 
> I wasn't able to do an acceptable re-implementation of the negative
> caching we had in 2.4 with this framework, so just ignore the last
> sentence in the above description. 

> Unfortunately no, but I thought that once the dentry became unhashed
> (aka ->rmdir() or ->unlink()) it was invisible to the dcache. But, of
> course there may be descriptors open on the dentry, which I think is the
> problem that's being pointed out.
 
... or we could have had a pending mount(2) sitting there with a reference
to mountpoint-to-be...

> Yes, that would be ideal but the reason we arrived here is that, because
> we must release the directory mutex before calling back to the daemon
> (the heart of the problem, actually having to drop the mutex) to perform
> the mount, we can get a deadlock. The cause of the problem was that for
> "create" like operations the mutex is held for ->lookup() and
> ->revalidate() but for a "path walks" the mutex is only held for
> ->lookup(), so if the mutex is held when we're in ->revalidate(), we
> could never be sure that we where the code path that acquired it.
> 
> Sorry, this last bit is unclear.
> I'll need to work a bit harder on the explanation if you're interested
> in checking further.

I am.

Oh, well...  Looks like RTFS time for me for now...  Additional parts of
braindump would be appreciated - the last time I've seriously looked at
autofs4 internal had been ~2005 or so ;-/
