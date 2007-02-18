Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbXBRWyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbXBRWyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXBRWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:54:37 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:35379 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXBRWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:54:37 -0500
To: riel@redhat.com
CC: akpm@linux-foundation.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <45D8C43A.3060800@redhat.com> (message from Rik van Riel on Sun,
	18 Feb 2007 16:25:14 -0500)
Subject: Re: dirty balancing deadlock
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu> <20070218125307.4103c04a.akpm@linux-foundation.org> <45D8C43A.3060800@redhat.com>
Message-Id: <E1HIuv0-0005Cy-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 18 Feb 2007 23:54:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrew Morton wrote:
> > On Sun, 18 Feb 2007 19:28:18 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> >> I was testing the new fuse shared writable mmap support, and finding
> >> that bash-shared-mapping deadlocks (which isn't so strange ;).  What
> >> is more strange is that this is not an OOM situation at all, with
> >> plenty of free and cached pages.
> >>
> >> A little more investigation shows that a similar deadlock happens
> >> reliably with bash-shared-mapping on a loopback mount, even if only
> >> half the total memory is used.
> >>
> >> The cause is slightly different in the two cases:
> >>
> >>   - loopback mount: allocation by the underlying filesystem is stalled
> >>     on throttle_vm_writeout()
> >>
> >>   - fuse-loop: page dirtying on the underlying filesystem is stalled on
> >>     balance_dirty_pages()
> >>
> >> In both cases the underlying fs is totally innocent, with no
> >> dirty/writback pages, yet it's waiting for the global dirty+writeback
> >> to go below the threshold, which obviously won't, until the
> >> allocation/dirtying succeeds.
> >>
> >> I'm not quite sure what the solution is, and asking for thoughts.
> > 
> > But....  these things don't just throttle.  They also perform large amounts
> > of writeback, which causes the dirty levels to subside.
> > 
> >>From your description it appears that this writeback isn't happening, or
> > isn't working.  How come?
> 
> Is the fuse daemon trying to do writeback to itself, perhaps?
> 
> That is, trying to write out data to the FUSE filesystem, for which
> it is also the server.

No.  It's trying to write out data to a different filesystem.

Trying to write out data to itself very obviously deadlocks, but that
doesn't affect anything beside the stupid filesystem itself, and there
are mechanisms for aborting such a situation (forced umount, abort
through fuse-control filesystem).

Miklos
