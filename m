Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZDACkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZDACkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZDACkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:40:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46272 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZDACj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:39:59 -0400
Date: Wed, 1 Apr 2009 03:38:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20090401023849.GW28946@ZenIV.linux.org.uk>
References: <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 01:28:01AM +0100, Hugh Dickins wrote:
> Minor bisectability issue: the third patch, which introduces
> int unshare_fs_struct(void), needs to return 0 when it succeeds:
> that gets corrected in the fourth patch.

ACK.

> Lockdep objects to how check_unsafe_exec nests write_lock(&p->fs_lock)
> inside lock_task_sighand(p, &flags).  It's right: we sometimes take
> sighand->siglock in interrupt, so if such an interrupt occurred just
> after you take fs_lock elsewhere, that could deadlock with this.  It
> seems happy with taking fs_lock just outside the lock_task_sighand.

Right you are, check_unsafe_exec() reordered.  Will push in a few.
 
> Otherwise it looks good to me, except I keep worrying about those
> EAGAINs.  The more so once I noticed current->cred_exec_mutex is
> already being used to handle a similar issue with ptrace.  What
> do you think of this rather smaller patch?  which I'd much rather
> send after having slept on it, since it may be embarrassingly and
> obviously wrong, but tomorrow may be too late ...
 
Eh...  I'm not particulary happy with fork() growing heavier and heavier.
Besides, there's a subtle problem avoided by another variant - think what
happens if past the point of no return execve() will unshare fs_struct
(e.g. by explicit unshare() from dynamic linker).

Frankly, -EAGAIN in situation when we have userland race is fine.  And
we *do* have a userland race here - execve() will kill -9 those threads
in case of success, so if they'd been doing something useful, they are
about to be suddenly screwed.

So I stand by my variant.  Note that if we have *other* tasks sharing
fs_struct, your variant will block their clone() for the duration of
execve() while mine will simply leave them alone (and accept that we
have unsafe sharing).
