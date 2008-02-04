Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYBDKaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYBDKaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYBDKaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:30:08 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:36537 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYBDKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:30:06 -0500
Date: Mon, 4 Feb 2008 11:30:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@SteelEye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204103001.GA2674@basil.nowhere.org>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203095252.GA11043@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Feb 2008 10:23:43.0478 (UTC) FILETIME=[04A3D160:01C86718]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	q = &__get_cpu_var(call_single_queue);
> +	spin_lock_irqsave(&q->lock, flags);
> +	list_replace_init(&q->list, &list);
> +	spin_unlock_irqrestore(&q->lock, flags);

I think you could do that lockless if you use a similar data structure
as netchannels (essentially a fixed size single buffer queue with atomic 
exchange of the first/last pointers) and not using a list. That would avoid 
at least one bounce for the lock and likely another one for the  list
manipulation.

Also the right way would be to not add a second mechanism for this,
but fix the standard smp_call_function_single() to support it.

-Andi
