Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbZKKL5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbZKKL5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZKKL5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:57:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZKKL5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:57:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: romit@ti.com, "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before invoking kthread_stop on them
Date: Wed, 11 Nov 2009 12:59:04 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
References: <1257928216.15415.57.camel@boson> <200911111230.58479.rjw@sisk.pl> <1257940231.28810.2.camel@boson>
In-Reply-To: <1257940231.28810.2.camel@boson>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111259.04481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Romit Dasgupta wrote:
> Hello Rafael, 
>               As suggested I have added the relevant information in the
> changelog. The patch is below:
> > For completness, below is the information from the Romit's introductory message
> > (Romit, I really think that should go into the chagelog):
> 
> Kicks out frozen bdi flusher task out of the refrigerator when the said task
> needs to exit.
> Steps to reproduce this.
> 1) Mount a file system from MMC/SD card.
> 2) Unmount the file system. This creates a flusher task.
> 3) Attempt suspend to RAM. System is unresponsive.
> 
> This is because the bdi flusher thread is already in the refrigerator and will
> remain so until it is thawed. The MMC driver suspend routine ultimately will
> issue a 'kthread_stop' on the bdi flusher thread and will block until the
> flusher thread is exited. Since the bdi flusher thread is in the refrigerator
> it never cleans up until thawed.
> 
> Signed-off-by: Romit Dasgupta <romit@ti.com>

Thanks!  I'd still like to know that this change is fine with Jens, though.

Rafael


> ---
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 5a37e20..c757b05 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -606,8 +606,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  	 * Finally, kill the kernel threads. We don't need to be RCU
>  	 * safe anymore, since the bdi is gone from visibility.
>  	 */
> -	list_for_each_entry(wb, &bdi->wb_list, list)
> +	list_for_each_entry(wb, &bdi->wb_list, list) {
> +		if (unlikely(frozen(wb->task)))
> +			wb->task->flags &= ~PF_FROZEN;
>  		kthread_stop(wb->task);
> +	}
>  }
>  
>  void bdi_unregister(struct backing_dev_info *bdi)
