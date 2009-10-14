Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZJNUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZJNUmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZJNUmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:42:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:26665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759872AbZJNUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:42:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="503228719"
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, David Rientjes <rientjes@google.com>,
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
In-Reply-To: <20091014165051.GE5027@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <20091012134328.GB8200@csn.ul.ie> <200910121932.14607.elendil@planet.nl>
	 <200910132238.40867.elendil@planet.nl> <20091014103002.GA5027@csn.ul.ie>
	 <1255537680.21134.14.camel@rc-desk>  <20091014165051.GE5027@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 13:41:51 -0700
Message-Id: <1255552911.21134.51.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 09:50 -0700, Mel Gorman wrote:

> What is your take on GFP_ATOMIC-direct deleting the pool before the tasklet
> can refill it with GFP_KERNEL?

I am not sure I understand your question. We attempt to reclaim a
received buffer on every receive, and with a queue size of 256 + 64 we
assume to have a pretty big buffer to deal with cases when allocations
fail. So, technically, for us to get into this situation where we start
seeing these allocation failures there would have been more than 200
times in which GFP_ATOMIC allocations failed that we did _not_ see since
we only see those warnings when there are less than 8 free buffers
remaining. More on this below ...

>  Should direct allocation be falling back to
> calling with GFP_KERNEL when the pool has been depleted instead of failing?

This is the intention of the current implementation. In the tasklet we
run iwl_rx_replenish_now(), which attempts the GFP_ATOMIC allocations
first by calling iwl_rx_allocate() with the GFP_ATOMIC flag. No
particular action is taken when this fails (apart from the error
message), but if the buffers are running low then iwl_rx_queue_restock()
(which is also called from iwl_rx_replenish_now()) will queue work that
will do the allocation with GFP_KERNEL.

We do queue the GFP_KERNEL allocations when there are only a few buffers
remaining in the queue (8 right now) ... maybe we can make this higher?

I am not sure if this will help in what you are trying to figure out
here, but would it help to play with the numbers here? That is, in
iwl_rx_queue_restock() we have:

if (rxq->free_count <= RX_LOW_WATERMARK)
	queue_work(priv->workqueue, &priv->rx_replenish);

Would it help here to make that value higher? Maybe queue the GFP_KERNEL
allocation when there are, for example, 50 or 100 free buffers
remaining? 

Reinette


