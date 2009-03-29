Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZC3AHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZC3AHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZC3AHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:07:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbZC3AHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:07:18 -0400
Date: Mon, 30 Mar 2009 01:56:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>,
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
Message-ID: <20090329235639.GA32199@redhat.com>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329222022.GJ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Al Viro wrote:
>
> On Sun, Mar 29, 2009 at 11:36:35PM +0200, Oleg Nesterov wrote:
> > > ... or just do that to fs_struct.  After finding that there's no outside
> > > users.  Commenst?
> >
> > This is even worse. Not only we race with our sub-threads, we race
> > with CLONE_FS processes.
> >
> > We can't mark fs_struct after finding that there's no outside users
> > lockless. Because we can't know whether this is "after" or not, we
> > can't trust "atomic_read(fs->count) <= n_fs".
>
> We can lock fs_struct in question, go through the threads, then mark
> or bail out.  With cloning a reference to fs_struct protected by the
> same lock.

Yes, this is what I meant, copy_fs() needs this lock too,

> FWIW, I'm not at all sure that we want atomic_t for refcount in that
> case...

I think you are right, because exit_fs() should take fs->lock as well.

But, again. What whould we do when check_unsafe_exec() takes fs->lock
and sees that this ->fs is already marked?

In that case -EWHATEVER is not very good, it could be another process
(not sub-thread) doing exec.

Oleg.

