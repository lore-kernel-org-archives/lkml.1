Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZDXIHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZDXIHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZDXIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:06:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZDXIGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:06:53 -0400
Date: Fri, 24 Apr 2009 10:06:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alessio Igor Bogani <abogani@texware.it>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424080634.GG24912@elte.hu>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424071853.GG8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Apr 24, 2009 at 08:13:12AM +0100, Al Viro wrote:
> 
> > AFAICS, both CIFS_SB(sb) and ->tcon are assign-once, so lock_kernel() should
> > really go here (if it can't be removed completely, of course, but that's up
> > to CIFS folks).  Applied with such modification.
> 
> commit 208f6be8f9244f4a3e8de7b4c6ca97069698303a in 
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/
> 
> if you want to see the version after that change (or wait for 
> linux-next to pick it).

You've not replied to my request (attached below) to put these 
trivial BKL-pushdown bits into a separate branch/tree and not into 
the VFS tree. You've now mixed that commit with other VFS changes.

Had it been in a separate branch, and had we tested it, Linus could 
have pulled the trivial BKL pushdown bits out of normal merge order 
as well. That is not possible now.

Furthermore, by doing this you are also hindering the 
tip:kill-the-BKL effort (which has been ongoing for a year chipping 
away at various BKL details) which facilitated these changes. 
Alessio did these fixes to fix bugs he can trigger in that tree.

You've also not explained why you have done it this way. It would 
cost you almost nothing to apply these bits into a separate branch 
and merge that branch into your main tree. Lots of other maintainer 
are doing that.

So if you've done this by mistake, i'd like to ask you to reconsider 
and put these bits into a separate, stable-commit-ID branch. If 
you've done this intentionally, i'd like you to explain the reasons 
for it, instead of just doing it silently without explanation.

Anwyay, if there's no resolution, i'll apply Alessio's fixes with a 
different commit ID, to not hold up the rather useful work that is 
going on in the kill-the-BKL tree. Later on i'll have to rebase that 
portion of the tree to avoid duplicate commit IDs. I just wanted to 
put it on the record why i have to do that rebase.

Thanks,

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Thu, 23 Apr 2009 23:32:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5 -tip] umount_begin BKL pushdown
Cc: Alessio Igor Bogani <abogani@texware.it>,
	Jonathan Corbet <corbet@lwn.net>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	LFSDEV <linux-fsdevel@vger.kernel.org>


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Apr 23, 2009 at 09:12:00PM +0200, Alessio Igor Bogani wrote:
> > Push the BKL acquisition from vfs to every specific filesystems
> > with hope that it can be eliminated in a second moment.
> > 
> > The first 4 patches add BKL lock into umount_begin() functions 
> > (for the filesystems that have this handler). The last one 
> > remove lock_kernel()/unlock_kernel() from fs/namespace.c (the 
> > only point that invoke umount_begin() funtcions).
> 
> I'd rather collapse all these patches together; no point doing 
> that per-fs (for all 4 of them).  And CIFS side is bogus.
> 
> Another thing: -tip is no place for that.  I can put that into VFS 
> tree, provided that comments above are dealt with.

When that happens, could you please put it into a separate, 
append-only branch i could pull (after some initial test-time) into 
tip:kill-the-BKL?

Thanks,

	Ingo

