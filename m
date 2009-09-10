Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZIJBsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZIJBsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZIJBsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:48:20 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:57202 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbZIJBsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:48:18 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Thu, 10 Sep 2009 03:48:16 +0200
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, Larry Finger <Larry.Finger@lwfinger.net>,
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
References: <200909060941.01810.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <1252526738.30150.91.camel@rc-desk>
In-Reply-To: <1252526738.30150.91.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909100348.20361.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2009 01:48:20.0942 (UTC) FILETIME=[C69D46E0:01CA31B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

On Wednesday 09 September 2009, reinette chatre wrote:
> I agree that this patch may be the reason we are seeing this issue. We
> would like to keep using GFP_ATOMIC here, but it is not necessary for
> an allocation failure to be so noisy since the function doing the
> allocation (iwl_rx_allocate) is always followed by a call to
> iwl_rx_queue_restock which will schedule a refill if the buffers are
> running low. We can thus use ___GFP_NOWARN for the allocations in
> iwl_rx_allocate and leave it to the restocking to find the needed
> memory when it tried its allocations using GFP_KERNEL.
>
> I do think it is useful to let user know about these allocation
> failures, even if it does not result in packet loss. Wrapping it in
> net_ratelimit() will help though.
>
> How about the patch below?

A couple of comments/suggestions.

If the driver recovers cleanly from the error, shouldn't the priority of 
the message be lowered from CRIT to INFO. Or maybe even DEBUG; AFAIK most 
distros will have DEBUG_KERNEL enabled by default.
This means it will still show up in logs, but not the console.

Shouldn't the message include some indication that the driver will recover 
by itself and that no user action is needed? This will help avoid users 
(unnecessarily) reporting this as a bug when it does occur.
I expect that users would still report it if they get flooded with the 
message (or ratelimit warnings for it), which I think is what you'd want.

And maybe s/Can not/Cannot/ or s/Can not/Failed to/.

Cheers,
FJP
