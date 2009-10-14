Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbZJNQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbZJNQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934461AbZJNQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:51:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55053 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbZJNQvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:51:25 -0400
Date: Wed, 14 Oct 2009 17:50:52 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: reinette chatre <reinette.chatre@intel.com>
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
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091014165051.GE5027@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091012134328.GB8200@csn.ul.ie> <200910121932.14607.elendil@planet.nl> <200910132238.40867.elendil@planet.nl> <20091014103002.GA5027@csn.ul.ie> <1255537680.21134.14.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1255537680.21134.14.camel@rc-desk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 09:28:00AM -0700, reinette chatre wrote:
> Hi Mel,
> 
> On Wed, 2009-10-14 at 03:30 -0700, Mel Gorman wrote:
> > From 5fb9f897117bf2701f9fdebe4d008dbe34358ab9 Mon Sep 17 00:00:00 2001
> > From: Mel Gorman <mel@csn.ul.ie>
> > Date: Wed, 14 Oct 2009 11:19:57 +0100
> > Subject: [PATCH] iwlwifi: Suppress warnings related to GFP_ATOMIC allocations that do not matter
> > 
> > iwlwifi refills RX buffers in two ways - a direct method using GFP_ATOMIC
> > and a tasklet method using GFP_KERNEL. There are a number of RX buffers and
> > there are only serious issues when there are no RX buffers left. The driver
> > explicitly warns when refills are failing and the buffers are low but it
> > always warns when a GFP_ATOMIC allocation fails even when there is no
> > packet loss as a result.
> 
> 
> No, it does not always warn when a GFP_ATOMIC allocation fails. Please
> check earlier in iwl_rx_allocate() we have:
> 
> if (rxq->free_count > RX_LOW_WATERMARK)
> 	priority |= __GFP_NOWARN;
> 
> So it will suppress warnings as long as we have buffers available.
> 
> We do want to see warnings if memory is below watermark and allocation
> fails - your patch prevents these warnings from appearing.
> 

Yeah, the patch is balls and is not the way forward.

What is your take on GFP_ATOMIC-direct deleting the pool before the tasklet
can refill it with GFP_KERNEL? Should direct allocation be falling back to
calling with GFP_KERNEL when the pool has been depleted instead of failing?



-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
