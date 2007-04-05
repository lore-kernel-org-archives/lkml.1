Return-Path: <linux-kernel-owner+w=401wt.eu-S1767401AbXDEWuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767401AbXDEWuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767400AbXDEWuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:50:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:29853 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767230AbXDEWuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,379,1170662400"; 
   d="scan'208"; a="222692776:sNHT19713218"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 4/4] IA64: SPARSE_VIRTUAL 16M page size support
Date: Thu, 5 Apr 2007 15:50:02 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0153594A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070404230635.20292.81141.sendpatchset@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4] IA64: SPARSE_VIRTUAL 16M page size support
Thread-Index: Acd3FF5/BsJk0PFxSY+smnBbyaPx1wAvjnpQ
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>, <akpm@linux-foundation.org>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Martin Bligh" <mbligh@google.com>, <linux-mm@kvack.org>,
       "Andi Kleen" <ak@suse.de>, "Dave Hansen" <hansendc@us.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
X-OriginalArrivalTime: 05 Apr 2007 22:50:02.0996 (UTC) FILETIME=[BF524340:01C777D4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This implements granule page sized vmemmap support for IA64.

Christoph,

Your calculations here are all based on a granule size of 16M, but
it is possible to configure 64M granules.

With current sizeof(struct page) == 56, a 16M page will hold enough
page structures for about 4.5G of physical space (assuming 16K pages),
so a 64M page would cover 18G.

4.5G is possibly a bit wasteful (for a system with only a handful
of GBytes per node, and nodes that are not physically contiguous).
18G is definitely going to result in lots of wasted page structs
(that refer to non-existant physical memory around the edges of
each node).

Maybe a granule is not the right unit of allocation ... perhaps 4M
would work better (4M/56 ~= 75000 pages ~= 1.1G)?  But if this is
too small, then a hard-coded 16M would be better than a granule,
because 64M is (IMHO) too big.

-Tony

P.S. This patch breaks the build for tiger_defconfig, zx1_defconfig
etc.  But you may have fit on the "grand-unified theory" of mem_map
management ... so if the benchmarks come in favourably we could
drop all the other CONFIG options.
