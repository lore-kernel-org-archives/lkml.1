Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXHXLUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXHXLUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXHXLU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:20:28 -0400
Received: from ns.suse.de ([195.135.220.2]:60932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXHXLU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:20:27 -0400
Date: Fri, 24 Aug 2007 13:20:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Beekhof <abeekhof@suse.de>
Subject: [patch] 2.6.23-rc3: fsblock
Message-ID: <20070824112025.GA12412@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm still plugging away at fsblock slowly. Haven't really got around to
to finishing up any big new features, but there has been a lot of bug fixing
and little API changes since last release.

I still think fsblock has merit, and even if a more extent-based approach
ends up working better for most things. I think a block based one will
still have its place (either along-side or underneath), and I think fsblock
is just much better than buffer_heads.

fsblock proper and minix port patches are on kernel.org, because they're
pretty big and not well split-up to be posted here.

http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/fsblock/2.6.23-rc3/

Some notes:

mbforget is restored (though very poor implementation for now), and filesystems
do not have their "underlying metadata" unmapped or synched by default for new
blocks. They could do this in their get_block function if they want, or
otherwise ensure that metadata blocks are not just abandoned with possible
dirty data in-flight. Basically my thinking is that it is quite an extra
expense that should be optional.

Made use of lockless radix-tree. Pages in superpage-blocks are tracked with
the pagecache radix-tree, and a fair amount of lookups can be involved. This
makes those operations faster and more scalable.

I've got rid of RCU completely from the fsblock data structures. fsblock's
getblk equivalent must now tolerate blocking (if this turns out to be too
limiting, I might be convinced to add back RCU or some kind of spin locking).
However I want to get rid of RCU freeing, because a normal use-case (the
"nobh" mode) is expected to have a lot of fsblock structures being allocated
and freed as IO is happening, so this needs to be really efficient and RCU
can degrade CPU cache properties in these situations.

Added a real vmap cache. It is still pretty primitive, but it gets like
99% hit rate in my basic tests, so I didn't bother with anything more
fancy yet.

Changed block memory mapping API to only support metadata blocks at this
stage. Just makes a few implementation things easier at this point.

Added the /proc/sys/vm/fsblock_no_cache tunable, which disables caching of
fsblock structures, and actively frees them after IOs etc have finished.

TODO
- introduce, and make use of, range based aops APIs and remove all the
  silly locking code for multi-page blocks (as well as do nice multi-block
  bios). In progress.

- write a extent-based block mapping module that filesystems could optionally
  use to efficiently cache block mappings. In progress.

- port some real filesystems. ext2 is in progress, and I like the idea of
  brtfs, it seems like it would be a lot more manageable than ext3 for me.

