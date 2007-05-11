Return-Path: <linux-kernel-owner+w=401wt.eu-S1762441AbXEKN7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762441AbXEKN7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXEKN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:59:11 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:22467 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491AbXEKN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:59:05 -0400
Message-Id: <20070511135827.393181482@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 15:58:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: virtualization@lists.osdl.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hubertus Franke <frankeh@watson.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: [patch 0/6] [rfc] guest page hinting version 5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After way to many months here is the fifth version of the guest page
hinting patches. Compared to version four a few improvements have been
added:
 - Avoid page_host_discards() calls outside of page-states.h
 - The discard list is now implemented via the page_free_discarded
   hook and architecture specific code.
 - PG_state_change page flag has been replaced with architecture
   specficic primitives. s390 now uses PG_arch_1 and avoids to waste
   another page flag (it still uses two additional bits).
 - Add calls to make pages volatile when pages are moved from the
   active to the inactive list and set max_buffer_heads to zero to
   force a try_to_release_page call to get more page into volatile
   state.
 - remap_file_pages now works with guest page hinting, although the
   discard of a page contained in a non-linear mapping is slow.
 - Simplified the check in the mlock code.
 - In general the code looks a bit nicer now.

I tried to implement batched state transitions to volatile but after
a few failures I gave up. Basically, most pages are made volatile with
the unlock_page call after the end of i/o. To postpone a make volatile
attempt requires to take a page reference. Trouble is you can't release
a page reference from interrupt context. This has to be done in task
context, so we can't use a pvec/array for keep the references. There is
no room in struct page for a list, so it turns out lazy make volatile
is hard to implement.

The patches apply on the current git tree.

Many thanks go to Oliver Paukstadt who kept me busy with bug reports
and uncountable dumps ..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

