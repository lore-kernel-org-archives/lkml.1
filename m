Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbXHTVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbXHTVx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXHTVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbXHTVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:17 -0400
Message-Id: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:40 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 0/7] Postphone reclaim laundry to write at high water marks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of the problems with reclaim writeout is that it occurs when memory in a
zone is low. A particular bad problem can occur if memory in a zone is
already low and now the first page that we encounter during reclaim is dirty.
So the writeout function is called without the filesystem or device having
much of a reserve that would allow further allocations. Triggering writeout
of dirty pages early does not improve the memory situation since the actual
writeout of the page is a relatively long process. The call to writepage
will therefore not improve the low memory situation but make it worse
because extra memory may be needed to get the device to write the page.

This patchset fixes that issue by:

1. First reclaiming non dirty pages. Dirty pages are deferred until reclaim
   has reestablished the high marks. Then all the dirty pages (the laundry)
   is written out.

2. Reclaim is essentially complete during the writeout phase. So we remove
   PF_MEMALLOC and allow recursive reclaim if we still run into trouble
   during writeout.

-- 
