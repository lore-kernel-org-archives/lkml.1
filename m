Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZJ0QFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZJ0QFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZJ0QFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:05:13 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:59943 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZJ0QFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:05:11 -0400
Date: Tue, 27 Oct 2009 12:03:32 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091027160332.GA7776@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
	David Rientjes <rientjes@google.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Karol Lewandowski <karol.k.lewandowski@gmail.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
 <20091019161815.GA11487@think>
 <20091020104839.GC11778@csn.ul.ie>
 <200910262206.13146.elendil@planet.nl>
 <20091027145435.GG8900@csn.ul.ie>
 <20091027155223.GL8900@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027155223.GL8900@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AE719F5.0183:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 03:52:24PM +0000, Mel Gorman wrote:
> 
> > So, after the move to async/sync, a lot more pages are getting queued
> > for writeback - more than three times the number of pages are queued for
> > writeback with the vanilla kernel. This amount of congestion might be why
> > direct reclaimers and kswapd's timings have changed so much.
> > 
> 
> Or more accurately, the vanilla kernel has queued up a lot more pages for
> IO than when the patch is reverted. I'm not seeing yet why this is.

[ sympathies over confusion about congestion...lots of variables here ]

If wb_kupdate has been able to queue more writes it is because the
congestion logic isn't stopping it.  We have congestion_wait(), but
before calling that in the writeback paths it says: are you congested?
and then backs off if the answer is yes.

Ideally, direct reclaim will never do writeback.  We want it to be able
to find clean pages that kupdate and friends have already processed.

Waiting for congestion is a funny thing, it only tells us the device has
managed to finish some IO or that a timeout has passed.  Neither event has
any relation to figuring out if the IO for reclaimable pages has
finished.

One option is to have the VM remember the hashed waitqueue for one of
the pages it direct reclaims and then wait on it.

-chris

