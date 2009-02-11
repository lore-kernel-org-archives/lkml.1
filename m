Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZBKBT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZBKBT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZBKBTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:19:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48668 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbZBKBTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:19:40 -0500
Date: Wed, 11 Feb 2009 01:19:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: fix possible use after free
Message-ID: <20090211011933.GB28946@ZenIV.linux.org.uk>
References: <4991497B.4030200@cn.fujitsu.com> <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com> <20090210124527.GA28946@ZenIV.linux.org.uk> <6599ad830902101601i294ffaa5xd01611c5121a5685@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830902101601i294ffaa5xd01611c5121a5685@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 04:01:07PM -0800, Paul Menage wrote:
> On Tue, Feb 10, 2009 at 4:45 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Feb 10, 2009 at 02:15:36AM -0800, Paul Menage wrote:
> >> On Tue, Feb 10, 2009 at 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >> > In cgroup_kill_sb(), root is freed before sb is detached from the list,
> >> > so another sget() may find this sb and call cgroup_test_super(),
> >> > which will access the root that has been freed.
> >>
> >> I think that I'd assumed that by the time we get to cgroup_kill_sb()
> >> there's no chance of the sb being resurrected by sget().
> >
> > There is none.  grab_super() will fail to get it, so sget() will go
> > through retry logics.  Which doesn't mean that test won't be called
> > on it in the meanwhile.
> 
> OK, so Zefan's patch looks like the safest way to fix this particular
> issue. I think I see some other potential races with
> cgroup_test_super() though - we probably need to synchronize against
> the changing of a root's subsys_bits in rebind_subsystems(). Taking
> cgroup_mutex around the call to sget() would certainly provide that,
> but I'd have to check whether it causes locking cycles.

Deadlock.  The whole point of what sget() is doing with retries is this:
if you have a matching fs in the middle of shutdown, you obviously can't
pick its sb (it's halfway shut down) and you can't start bringing your
instance up until the halfdead one is gone.

So you can't wrap sget() into a mutex that might be grabbed at some
point of ->kill_sb() or it'll wait forever in that scenario.  Note
that test is essentially atomic; we are doing it fast for all superblocks
of this type.

If we find a match, we go ahead and pick that superblock.  So there's no
problem just assuming we'd won the race, got existing superblock and
change (if any) of ->subsys_bits simply happened just after that.

AFAICS, that's perfectly sane - you are talking about the race between
mount picking fs instance with the same options and remount changing
said instance.  Other callers of rebind_subsystems() do not apply -
one in your ->get_sb() won't change the field anyway and one in
->kill_sb() is irrelevant since the superblock will be rejected by
grab_super().

So no exclusion is needed there at all.  If you don't want later remount
of the first mount to affect these flags of second one you shouldn't share
the superblock at all, obviously...
