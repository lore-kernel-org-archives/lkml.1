Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbZDSQrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbZDSQrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZDSQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:47:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52283 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZDSQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:47:10 -0400
Date: Sun, 19 Apr 2009 17:44:28 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
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
In-Reply-To: <20090406155103.GB21220@redhat.com>
Message-ID: <Pine.LNX.4.64.0904191730130.9099@blonde.anvils>
References: <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk>
 <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com>
 <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090406155103.GB21220@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Oleg Nesterov wrote:
> On 04/01, Al Viro wrote:
> >
> > On Wed, Apr 01, 2009 at 01:28:01AM +0100, Hugh Dickins wrote:
> >
> > > Otherwise it looks good to me, except I keep worrying about those
> > > EAGAINs.
> >
> > Frankly, -EAGAIN in situation when we have userland race is fine.  And
> > we *do* have a userland race here - execve() will kill -9 those threads
> > in case of success, so if they'd been doing something useful, they are
> > about to be suddenly screwed.
> 
> Can't resist! I dislike the "in_exec && -EAGAIN" oddity too.
> 
> Yes sure, we can't break the "well written" applications. But imho this
> looks strange. And a bit "assymetrical" wrt LSM_UNSAFE_SHARE, I mean
> check_unsafe_exec() allows sub-threads to race or CLONE_FS but only if
> LSM_UNSAFE_SHARE.
> 
> Another reason, we can have the "my test-case found something strange"
> bug-reports.
> 
> So. Please feel free to nack or just ignore this message, but since I
> personally dislike the current behaviour I should at least try to suggest
> something else.

I didn't spend very long on this: it looked rather equivalent to the
current->fs->cred_exec_mutex patch that I proposed, but spinning its
own infrastructure rather than relying on the existing mutex (and of
course based on top of Al's patches, now in the tree, which have
changed the path of least resistance).

I've probably missed subtleties, but I still prefer my own suggestion;
though Al hinted at a subtle problem with that which I never grasped.

Of course I agree with you sharing my unease at -EAGAIN and in_exec.
Maybe we just lie in wait preparing a "told you so" for when someone
reports "something strange"!  But I'd really like to see your fix
patch go in.

Hugh
