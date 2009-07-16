Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZGPEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZGPEDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZGPEDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:03:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbZGPEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:03:14 -0400
Date: Wed, 15 Jul 2009 21:02:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are
 isolated already (v3)
Message-Id: <20090715210253.bc137b2d.akpm@linux-foundation.org>
In-Reply-To: <20090715235318.6d2f5247@bree.surriel.com>
References: <20090715223854.7548740a@bree.surriel.com>
	<20090715194820.237a4d77.akpm@linux-foundation.org>
	<4A5E9A33.3030704@redhat.com>
	<20090715202114.789d36f7.akpm@linux-foundation.org>
	<4A5E9E4E.5000308@redhat.com>
	<20090715203854.336de2d5.akpm@linux-foundation.org>
	<20090715235318.6d2f5247@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 23:53:18 -0400 Rik van Riel <riel@redhat.com> wrote:

> @@ -1049,6 +1074,14 @@ static unsigned long shrink_inactive_lis
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>  	int lumpy_reclaim = 0;
>  
> +	while (unlikely(too_many_isolated(zone, file, sc))) {
> +		congestion_wait(WRITE, HZ/10);
> +
> +		/* We are about to die and free our memory. Return now. */
> +		if (fatal_signal_pending(current))
> +			return SWAP_CLUSTER_MAX;
> +	}

mutter.

While I agree that handling fatal signals on the direct reclaim path
is probably a good thing, this seems like a fairly random place at
which to start the enhancement.

If we were to step back and approach this in a broader fashion, perhaps
we would find some commonality with the existing TIF_MEMDIE handling,
dunno.


And I question the testedness of v3 :)
