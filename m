Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXBRS2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXBRS2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXBRS2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:28:47 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52263 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXBRS2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:28:46 -0500
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: akpm@linux-foundation.org
Subject: dirty balancing deadlock
Message-Id: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 18 Feb 2007 19:28:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing the new fuse shared writable mmap support, and finding
that bash-shared-mapping deadlocks (which isn't so strange ;).  What
is more strange is that this is not an OOM situation at all, with
plenty of free and cached pages.

A little more investigation shows that a similar deadlock happens
reliably with bash-shared-mapping on a loopback mount, even if only
half the total memory is used.

The cause is slightly different in the two cases:

  - loopback mount: allocation by the underlying filesystem is stalled
    on throttle_vm_writeout()

  - fuse-loop: page dirtying on the underlying filesystem is stalled on
    balance_dirty_pages()

In both cases the underlying fs is totally innocent, with no
dirty/writback pages, yet it's waiting for the global dirty+writeback
to go below the threshold, which obviously won't, until the
allocation/dirtying succeeds.

I'm not quite sure what the solution is, and asking for thoughts.

Ideas:

  - per filesystem dirty counters.  If filesystem is clean (or dirty
    is below some minimum), then balance_dirty_pages() should no wait
    any more

  - throttle_vm_writeout() was meant to throttle swapping, no?  So in
    that case there should be a separate swap-writback counter

Thanks,
Miklos
