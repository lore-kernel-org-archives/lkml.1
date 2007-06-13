Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXFMQRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXFMQRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXFMQRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:17:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:33283 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759280AbXFMQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:17:33 -0400
Date: Wed, 13 Jun 2007 20:17:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       markh@compro.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-ID: <20070613161746.GB275@tv-sign.ru>
References: <20070601183642.GA92@tv-sign.ru> <466078FF.2080508@cfl.rr.com> <20070602123030.GA719@tv-sign.ru> <4661D698.5040009@cfl.rr.com> <20070603081417.GA81@tv-sign.ru> <46641B16.9090701@compro.net> <4666B2A4.7090603@compro.net> <20070606102828.752bf955.akpm@linux-foundation.org> <20070607013128.GW11166@waste.org> <4667DB8C.4040803@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667DB8C.4040803@cfl.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 06/07, Mark Hounschell wrote:
>
> >From an earlier thread member:
> 
> >> Mark writes:
> >> Again I don't understand why flush_scheduled_work() running on behalf
> >> of a process affinitized to processor-1 requires cooperation from
> >> events/2 (affinitized to processor-2)
> >> when there is an events/1 already affinitized to processor 1?
> 
> >Oleg write:
> >flush_workqueue() blocks until any scheduled work on any CPU has run to
> >completion. If we have some work_struct pending on CPU 2, it can be
> >completed only when events/2 executes it.
> 
> Could not flush_scheduled_work() just follow the affinity mask of the
> task that caused the call to begin with. If calling task had a cpu-mask
> of 3 then flush_scheduled_work() would do the events/0 and events/1
> thing and if the calling task had an affinity mask of 1 then only
> events/0 would be done?
> 
> In other words changing what Oleg says above just slightly:
> 
> flush_workqueue() blocks until any scheduled work on any CPU in the
> calling tasks affinity mask has run to completion?

No, we can't do this, this makes flush_workqueue() meaningless.

Even if we could, this can't help. Suppose that a kernel thread takes some
global lock (for example, in our case cache_reap() takes cache_chain_mutex)
and then it is preempted by RT task which doesn't relinquish CPU.

So this problem is "wider", flush_workqueue() was just a random victim.

Oleg.

