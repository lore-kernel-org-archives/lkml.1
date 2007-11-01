Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbXKAADk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbXKAADk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXKAADN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58911 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:11 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu access overhead
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases the speed of the SLUB fastpath by
improving the per cpu allocator and makes it usable for SLUB.

Currently allocpercpu manages arrays of pointer to per cpu objects.
This means that is has to allocate the arrays and then populate them
as needed with objects. Although these objects are called per cpu
objects they cannot be handled in the same way as per cpu objects
by adding the per cpu offset of the respective cpu.

The patch here changes that. We create a small memory pool in the
percpu area and allocate from there if alloc per cpu is called.
As a result we do not need the per cpu pointer arrays for each
object. This reduces memory usage and also the cache foot print
of allocpercpu users. Also the per cpu objects for a single processor
are tightly packed next to each other decreasing cache footprint
even further and making it possible to access multiple objects
in the same cacheline.

SLUB has the same mechanism implemented. After fixing up the
alloccpu stuff we throw the SLUB method out and use the new
allocpercpu handling. Then we optimize allocpercpu addressing
by adding a new function

	this_cpu_ptr()

that allows the determination of the per cpu pointer for the
current processor in an more efficient way on many platforms.

This increases the speed of SLUB (and likely other kernel subsystems
that benefit from the allocpercpu enhancements):


       SLAB    SLUB    SLUB+   SLUB-o	SLUB-a
   8    96      86      45      44      38	3 *
  16    84      92      49      48      43	2 *
  32    84      106     61      59      53	+++
  64    102     129     82      88      75	++
 128    147     226     188     181     176	-
 256    200     248     207     285     204	=
 512    300     301     260     209     250	+
1024    416     440     398     264     391	++
2048    720     542     530     390     511	+++
4096    1254    342     342     336     376	3 *

alloc/free test
      SLAB    SLUB    SLUB+   SLUB-o	SLUB-a
      137-146 151     68-72   68-74	56-58	3 *

Note: The per cpu optimization are only half way there because of the screwed
up way that x86_64 handles its cpu area that causes addditional cycles to be
spend by retrieving a pointer from memory and adding it to the address.
The i386 code is much less cycle intensive being able to get to per cpu
data using a segment prefix and if we can get that to work on x86_64
then we may be able to get the cycle count for the fastpath down to 20-30
cycles.

-- 
