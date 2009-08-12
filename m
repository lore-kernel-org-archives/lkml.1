Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZHLOBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZHLOBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZHLOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:01:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53008 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbZHLOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:01:53 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 09:01:50 -0500
Message-Id: <1250085710.4000.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 17:06 -0400, Alan Stern wrote:
> This patch (as1279) adds kerneldoc for flush_scheduled_work()
> containing a stern warning that the function should be avoided.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/kernel/workqueue.c
> ===================================================================
> --- usb-2.6.orig/kernel/workqueue.c
> +++ usb-2.6/kernel/workqueue.c
> @@ -739,6 +739,24 @@ int schedule_on_each_cpu(work_func_t fun
>  	return 0;
>  }
>  
> +/**
> + * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.
> + *
> + * Blocks until all works on the keventd_wq global workqueue have completed.
> + * We sleep until all works present upon entry have been handled, but we
> + * are not livelocked by new incoming ones.
> + *
> + * Use of this function is discouraged, as it is highly prone to deadlock.
> + * It should never be called from within a work routine on the global
> + * queue, and it should never be called while holding a mutex required
> + * by one of the works on the global queue.  But the fact that keventd_wq
> + * _is_ global means that it can contain works requiring practically any
> + * mutex.  Hence this routine shouldn't be called while holding any mutex.

I really don't see why this should be "discouraged".  It has exactly the
same entangled deadlock problems as a lot of other functions like
wait_event().

> + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> + * They don't do the same thing (they cancel the work instead of waiting
> + * for it to complete), but in most cases they will suffice.
> + */

And this is wrong advice.  If you've violated the entangled deadlock
rules, the cancel functions will deadlock on you as well if the work is
still pending.  The other problem is that cancellation is a completely
different operation from flushing.  Flush is usually used in driver
shutdown routines to complete all outstanding tasks before going away.
Cancel wouldn't really have the same effect since the tasks may never
get done.

The final problem with this is that it creates a dichotomy between this
function, which is simply a wrapper for flush_workqueue() on the
keventd_wq and flush_workqueue().  flush_workqueue() has no scary
warnings, so are we trying to encourage driver writers all to create
their own workqueues for everything and declaring the global kernel
workqueue useless?  Or are we saying flushing workqueues is always bad
and we just haven't got around to updating the documentation on
flush_workqueue()?

James


