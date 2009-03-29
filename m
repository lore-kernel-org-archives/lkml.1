Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZC2E54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZC2E54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZC2E5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:57:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36215 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZC2E5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:57:45 -0400
Date: Sun, 29 Mar 2009 06:52:06 +0200
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
Message-ID: <20090329045206.GA15519@redhat.com>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329041022.GF28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Al Viro wrote:
>
> On Sun, Mar 29, 2009 at 01:53:43AM +0100, Oleg Nesterov wrote:
>
> > Let's suppose we have two threads T1 and T2. T1 exits, and calls
> > exit_fs().
> >
> > 	exit_fs:
> >
> > 		tsk->fs = NULL;
> > 		// WINDOW
> > 		put_fs_struct(fs);
> >
> > Now, if T2 does exec() and check_unsafe_exec() happens in the WINDOW
> > above, we set LSM_UNSAFE_SHARE.
> >
> > Or we can race with sub-thread doing clone(CLONE_FS|CLONE_THREAD),
> > the new thread is not visible in ->thread_group, buy copy_fs()
> > can already increment fs->count.
>
> Frankly, I don't think we really care.  Note that having several sub-threads
> and doing execve() in one of them will kill the rest, so you really want
> to do some kind of synchronization to get something similar to reasonable
> behaviour anyway.

OK.

Let's suppose that check_unsafe_exec() does not set LSM_UNSAFE_SHARE and
drops ->siglock. After that, another sub-thread does clone(CLONE_FS) without
CLONE_THREAD.

Unless we killed other threads, I can't see how we can check ->fs is not
shared with another process, we can fool ->bprm_set_creds() anyway.

Confused.

Oleg.

