Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZDXSzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZDXSzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZDXSzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:55:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59668 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZDXSzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:55:38 -0400
Date: Fri, 24 Apr 2009 19:55:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Fr?d?ric Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424185524.GO8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org> <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com> <20090424175025.GA30091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424175025.GA30091@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 01:50:25PM -0400, Christoph Hellwig wrote:

> Having a working tree for debugging stuff is fine, but the point is
> that it should never be pulled into mainline and probably frequently
> reabsed to avoid cruft.  In that case there's really no point in
> creating branches to share pieces of tree history, just apply the patch
> locally if you think you want it and merge or rebase once mainline gets
> the patch.
> 
> Al frequently rebases the vfs tree, btw - so even if it was a separate
> branch now there's a fair chance it would end up in mainline with a
> different commit id.

Nah, it's not that.  I can hold that in a separate branch and keep it
anchored.  The question is, what else will end up there?
	* the work inside the methods on BKL _removal_
	* things like merging that ->write_super() call into ->put_super(),
etc.
	* probably parts of work on s_flags mess and ro (tied to remout)

I agree that getting rid of BKL in that area is a good thing; no arguments
about that.  If it had been entirely self-contained, I'd gladly drop that
stuff into a separate branch, let mingo pull it and forgot about the entire
thing.

The things get tricky, though, since we have two more things in the same
area: remount (once Nick comes back with the latest on mnt_write_count,
I'm going to merge that and start on per-sb side, BTW) and stuff around
Jan's sync series.

So let's figure out how do we do that.  I have no problem with a single
branch for *all* of that, separate from the rest of VFS stuff.  However,
I very much suspect that it's not what mingo et.al. have in mind - too
much stuff alien for them.  I can keep a cherry-picked branch with minimal
BKL-affecting backports from that one.  It might or might not be OK,
depending on what the hell their workflow is in -tip.  I honestly have
no idea how the devil the things are done there, except that it apparently
involves much more merges than I'd be comfortable with, but then I never
had a taste for literal clusterf*cks either.

Could the folks from the other side tell
	* what kind of patches do they want in that branch
	* what kind of patches can they accept in that branch
	* when do they intend to see it merged into mainline
	* how much is going to be merged on top of that and how often
(if ever) is it going to be thrown out and re-pulled.  I.e. is that for
a devel/debugging tree pulled together from many topic branches on
regular basis, with branches dropped/re-added/etc. (i.e. something a-la
linux-next) or is that something more cast in stone?

Seriously, let's sort that out; flamefests being what they are, there's
a real problem with keeping two streams of development tolerable for
participants.  I *do* have very unkind words to say to Ingo, but that's
a matter for private mail and I'm not going to let that anywhere near
development question.
