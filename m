Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZDALUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZDALUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZDALUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:20:37 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48693 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZDALUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:20:36 -0400
Date: Wed, 1 Apr 2009 12:18:11 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090401023849.GW28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0904011207400.8870@blonde.anvils>
References: <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com>
 <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk>
 <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com>
 <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils>
 <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
 <20090401023849.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Al Viro wrote:
> On Wed, Apr 01, 2009 at 01:28:01AM +0100, Hugh Dickins wrote:
>  
> > Otherwise it looks good to me, except I keep worrying about those
> > EAGAINs.  The more so once I noticed current->cred_exec_mutex is
> > already being used to handle a similar issue with ptrace.  What
> > do you think of this rather smaller patch?  which I'd much rather
> > send after having slept on it, since it may be embarrassingly and
> > obviously wrong, but tomorrow may be too late ...
>  
> Eh...  I'm not particulary happy with fork() growing heavier and heavier.

I don't see it as making fork() any heavier, but never mind.
The important thing is to get a fix out.

> Besides, there's a subtle problem avoided by another variant - think what
> happens if past the point of no return execve() will unshare fs_struct
> (e.g. by explicit unshare() from dynamic linker).

You're too far ahead of me there.

> 
> Frankly, -EAGAIN in situation when we have userland race is fine.  And
> we *do* have a userland race here - execve() will kill -9 those threads
> in case of success, so if they'd been doing something useful, they are
> about to be suddenly screwed.

Good point.  I found it quite odd the way the awkward case (shared
beyond the threadgroup) is allowed to go forward (with possibility
that setuid will be undone), but the easy case is -EAGAINed.  (And
I gave up on trying to find a better name for your "in_exec" flag,
which is rather more subtle than just that!)  But odd as it is,
there's good reason for doing it that way.

> 
> So I stand by my variant.

Fair enough.

> Note that if we have *other* tasks sharing
> fs_struct, your variant will block their clone() for the duration of
> execve() while mine will simply leave them alone (and accept that we
> have unsafe sharing).

Yes, intentional, consistent with the existing cred_exec_mutex technique.

Hugh
