Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbXHNOdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbXHNOdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbXHNOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:33:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36388 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757124AbXHNOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:33:07 -0400
Message-Id: <20070814142103.204771292@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 07:21:03 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset implements recursive reclaim. Recursive reclaim
is necessary if we run out of memory in the writeout patch from reclaim.

This is f.e. important for stacked filesystems or anything that does
complicated processing in the writeout path.

Recursive reclaim works because it limits itself to only reclaim pages
that do not require writeout. It will only remove clean pages from the LRU.
The dirty throttling of the VM during regular reclaim insures that the amount
of dirty pages is limited. If recursive reclaim causes too many clean pages
to be removed then regular reclaim will throttle all processes until the
dirty ratio is restored. This means that the amount of memory that can
be reclaimed via recursive reclaim is limited to clean memory. The default
ratio is 10%. This means that recursive reclaim can reclaim 90% of memory
before failing. Reclaiming excessive amounts of clean pages may have a
significant performance impact because this means that executable pages
will be removed. However, it ensures that we will no longer fail in the
writeout path.

A patch is included to test this functionality. The test involved allocating
12 Megabytes from the reclaim paths when __PF_MEMALLOC is set. This is enough
to exhaust the reserves.

-- 
