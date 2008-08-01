Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYHARfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYHARfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHAReu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:34:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:16655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYHAReu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,294,1215414000"; 
   d="scan'208";a="28590279"
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
From: Dan Williams <dan.j.williams@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       Arthur Jones <ajones@riverbed.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080801172231.GF20055@kernel.dk>
References: <18578.31924.259887.735206@notabene.brown>
	 <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org>
	 <20080801172231.GF20055@kernel.dk>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 10:34:48 -0700
Message-Id: <1217612088.24551.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-01 at 19:22 +0200, Jens Axboe wrote:
> It is a bit asymmetrical, largely due to the fact that the ->unplug_fn()
> itself grabs the lock. The below patch should fix it, since Neil has
> added a proper queue lock to the md queues. If someone can confirm that
> this fixes it, I'll queue up a patch with proper descriptions.
> 
> > I guess Jens is gone too..
> 
> I'm back, just been busy this week :-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 621a272..f19b52f 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1234,7 +1234,9 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
>  		case 0:
>  			bitmap_file_set_bit(bitmap, offset);
>  			bitmap_count_page(bitmap,offset, 1);
> +			spin_lock_irq(&bitmap->mddev->queue->queue_lock);
>  			blk_plug_device(bitmap->mddev->queue);
> +			spin_unlock_irq(&bitmap->mddev->queue->queue_lock);
>  			/* fall through */
>  		case 1:
>  			*bmc = 2;
> 

We also need to protect the blk_plug_device call a few lines down (and
an obvious compile fix).

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 621a272..c1b07e7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1224,7 +1224,9 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&bitmap->lock);
+			spin_lock_irq(bitmap->mddev->queue->queue_lock);
 			blk_unplug(bitmap->mddev->queue);
+			spin_unlock_irq(bitmap->mddev->queue->queue_lock);
 			schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
@@ -1234,7 +1236,9 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
 			bitmap_count_page(bitmap,offset, 1);
+			spin_lock_irq(bitmap->mddev->queue->queue_lock);
 			blk_plug_device(bitmap->mddev->queue);
+			spin_unlock_irq(bitmap->mddev->queue->queue_lock);
 			/* fall through */
 		case 1:
 			*bmc = 2;



