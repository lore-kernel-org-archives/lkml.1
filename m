Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZJNV4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZJNV4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbZJNV4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:56:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:40709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbZJNV4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:56:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="559634107"
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <200910142333.29625.elendil@planet.nl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <20091014165051.GE5027@csn.ul.ie> <1255552911.21134.51.camel@rc-desk>
	 <200910142333.29625.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 14:55:17 -0700
Message-Id: <1255557317.21134.82.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 14:33 -0700, Frans Pop wrote:
> On Wednesday 14 October 2009, reinette chatre wrote:
> > We do queue the GFP_KERNEL allocations when there are only a few buffers
> > remaining in the queue (8 right now) ...
> 
> Are you sure of this? I have zero messages in my logs about allocation 
> failures with GFP_KERNEL, but I do have plenty with "Only 0 free buffers 
> remaining" with GFP_ATOMIC.

That does make sense to me. We do not expect allocations with GFP_KERNEL
to fail. Considering how I understand how things work I am considering
the following scenario:

* start with system low on available memory
* now introduce incoming traffic (causing the RX code to run)
* upon receipt of frame we attempt an allocation (to reclaim the buffer)
with GFP_ATOMIC (state: num RX buffer free > watermark)
  * this fails since memory is not available
  * num RX buffer free reduces
  * does _not_ queue replenishment of buffers with GFP_KERNEL
* repeat above until we hit the watermark (currently 8)
* upon receipt of frame we attempt an allocation (to reclaim the buffer)
with GFP_ATOMIC (state: num RX buffer free <= watermark) 
  * this fails (now user sees big warning)
  * queue replenishment of buffers with GFP_KERNEL

Essentially what I suspect could happen is that
we do attempt to replenish the buffers with GFP_KERNEL after several
failures with GFP_ATOMIC, but at that point we have already run out
completely.

One way to test this theory is to queue the GFP_KERNEL allocation
earlier (when we still have a significant number of RX buffers
available), 8 may turn out to be too small.

> Does that indicate a bug or could they fall under the ratelimit somehow?

In your kernel log I do see that the driver's error messages related to
GFP_ATOMIC are rate limited (we see many more "order-2 allocation
failure" messages than the "Failed to allocate" messages). All of these
allocation failures are from the "replenish_now" code though, which is
GFP_ATOMIC. So even though we do not see the "Failed to allocate" errors
(which are rate limited) it seems that all allocation failures are from
that (the GFP_ATOMIC) code.

Reinette


