Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZINDBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZINDBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZINDBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:01:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:64003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZINDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,380,1249282800"; 
   d="scan'208";a="493101745"
Subject: Re: iwlagn: order 2 page allocation failures
From: Zhu Yi <yi.zhu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20090911084717.GB32497@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
	 <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
	 <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie>
	 <1252617290.30150.321.camel@rc-desk>  <20090911084717.GB32497@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 11:01:10 +0800
Message-Id: <1252897270.5650.169.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 16:47 +0800, Mel Gorman wrote:
> On Thu, Sep 10, 2009 at 02:14:50PM -0700, reinette chatre wrote:
> > On Thu, 2009-09-10 at 02:02 -0700, Mel Gorman wrote:
> > 
> > > 
> > > As a total aside, there is still the problem that the driver is depending on
> > > order-2 allocations. On systems without swap, the allocation problem could be
> > > more severe as there are fewer pages the system can use to regain contiguity.
> > 
> > I looked more at the implementation and hardware interface but I do not
> > see a way around this. We have to provide 8k buffer to device, and we
> > have to make sure it is aligned. 
> > 
> 
> That would imply an order-1 allocation instead of an order-2 though so
> it would appear than we are being worse than we have to. It would appear
> to be because of this +256 bytes that goes onto every buffer.
> 
> > Do you have any suggestions?
> > 
> 
> Nothing concrete. Finding an alternative to having the socket buffer
> 8192+256 to make it an order-1 allocation would be an improvement but I
> don't know how that should be tackled. Lacking the hardware, I can't
> experiment myself :(

Essentially, the hardware only requires an order-1 allocation aligned on
256 bytes boundary. But as it is used as an SKB, a trailing struct
skb_shared_info is added. This forces us to both increase the order and
do alignment ourselves. I believe some improvement could be done here.
But it should not be an easy one.

BTW, does SLAB/SLUB guarantee size of multiple PAGE_SIZE __kmalloc()
allocation align on PAGE_SIZE (or 256 bytes) boundary?

Thanks,
-yi

