Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYEAII4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYEAII4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 04:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYEAIIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 04:08:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40326 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYEAIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 04:08:40 -0400
To: dave@linux.vnet.ibm.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <1209620457.4461.59.camel@nimitz.home.sr71.net> (message from
	Dave Hansen on Wed, 30 Apr 2008 22:40:57 -0700)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <1209620457.4461.59.camel@nimitz.home.sr71.net>
Message-Id: <E1JrTpy-0004mH-Gg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 May 2008 10:08:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > R/O bind mounts patches have been reviewed numerous times.  Still a
> > relatively large number of places remained where checking for R/O
> > mounts was missed.
> 
> In all the other... erm... interesting discussion, I missed this point.
> 
> Were there some bits outside of the nfsd code where I missed the r/o
> mount checks?

Yes, the removexattr syscalls.  Al fixed those in the final
submission.

And the whole of ecryptfs was missed as a source of filesystem
modification.  How that's supposed to get fixed, along with nfsd is
arguable.

But regardless of all that, I think the path_* interface is a good
one, even if it has just a couple of users that actually _require_ the
r/o bracketing.  It's good because:

  - it's consistent

  - it provides some (not all) guarantees, i.e. it's easier to prove
    that all callers play by the rules

  - for the syscall case it has zero cost

  - for all the other cases it has either zero, or minimal cost

Yes, it does require the caller to have a vfsmount available, but it's
hard to imagine that the caller does not have it:

  - most userspace calls do have it, as they are either operating on a
    path or a file descriptor.  There are some exceptions like sync(2)
    and ustat(2), the latter not being a very exemplary interface, and
    neither of them being relevant to this discussion.

  - all kernel callers (nfs export, stacking) should have it, as they
    need it for open() anyway

And even if some theoretical caller didn't have the vfsmount, it still
should be easy to allocate one, providing a clean way to do the r/o
bracketing, and not requiring another mechanism to be exported that
provides the same functionality on the superblock.

Sorry for the claptrap.  I'm going to resubmit this one more time
with some slight modifications and additions, and it'd be really nice
if you or other interested parties would provide comments and opinions
(either way), because I don't think me and Al have anything new to say
to each other.

Thanks,
Miklos
