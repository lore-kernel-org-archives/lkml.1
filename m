Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbYGPPyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbYGPPyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbYGPPyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:54:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758328AbYGPPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:54:17 -0400
Message-ID: <487E1958.9060606@linux-foundation.org>
Date: Wed, 16 Jul 2008 10:52:56 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>
In-Reply-To: <1216211371.3122.46.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can get a similar effect by booting with a kernel parameter slub_min_objects=20 or so.

The fundamental difference in your patch is that you check for the wasted space in terms of a fraction of the size of a single object whereas the current logic only checks in terms of fractions of a page.

We could add an additional condition that the wasted space be no larger than half an object?

Affected slab configurations 

24 byte sized caches now become an order 1 cache.
72 byte sizes caches now become order 3
96 byte 0 - > 1
320 1 -> 2
448 2 -> 3

buffer_head 0 -> 1
idr_layer_cache 2 -> 3
inode_cache 2 -> 3
journal_*  1 -> 2

etc

So the effect would be a significant enlargement of caches.

In general the speed of slub is bigger the larger the allocations it can get from the page allocator. The page allocators performance is pretty slow compared to slub alloc logic so its a win to minimize calls to it. However, that in turn will put pressure on
larger page allocations.

