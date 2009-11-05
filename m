Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZKEUOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZKEUOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbZKEUOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:14:34 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:57260 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758233AbZKEUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:14:33 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Thu, 5 Nov 2009 21:14:32 +0100
User-Agent: KMail/1.9.9
Cc: Chris Mason <chris.mason@oracle.com>, David Rientjes <rientjes@google.com>,
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
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091020104839.GC11778@csn.ul.ie> <200910262206.13146.elendil@planet.nl>
In-Reply-To: <200910262206.13146.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911052114.36718.elendil@planet.nl>
X-OriginalArrivalTime: 05 Nov 2009 20:14:37.0985 (UTC) FILETIME=[998C4110:01CA5E54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Frans Pop wrote:
> On Tuesday 20 October 2009, Mel Gorman wrote:
> > I've attached a patch below that should allow us to cheat. When it's
> > applied, it outputs who called congestion_wait(), how long the timeout
> > was and how long it waited for. By comparing before and after sleep
> > times, we should be able to see which of the callers has significantly
> > changed and if it's something easily addressable.
>
> The results from this look fairly interesting (although I may be a bad
> judge as I don't really know what I'm looking at ;-).
>
> I've tested with two kernels:
> 1) 2.6.31.1: 1 test run
> 2) 2.6.31.1 + congestion_wait() reverts: 2 test runs

I've taken another look at the data from this debug patch, resulting in 
these graphs: http://people.debian.org/~fjp/tmp/kernel/congestion.pdf

I think the graph may show the reason for the congestion_wait() regression. 
Horizontal axis shows time, vertical axis shows number of logged 
congestion_wait calls per type.

The top chart is without the revert, the bottom one after the revert.

Note how before the revert the graph shows distinct steps: first you get 
almost exclusively kwapd, followed by almost exclusively alloc_pages and 
try_to_free. I suspect the periods where kswapd is almost horizontal 
correspond to the freezes.

With the revert the lines for the different functions are almost straight 
and everything happens much better interspersed.

Cheers,
FJP
