Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYBDHHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYBDHHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 02:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYBDHHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 02:07:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbYBDHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 02:06:59 -0500
Date: Sun, 3 Feb 2008 23:07:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] memstick: use __blk_end_request to complete requests
Message-Id: <20080203230705.581a3315.akpm@linux-foundation.org>
In-Reply-To: <943786.16504.qm@web36704.mail.mud.yahoo.com>
References: <20080202161635.fc02de0c.akpm@linux-foundation.org>
	<943786.16504.qm@web36704.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008 20:31:10 -0800 (PST) Alex Dubov <oakad@yahoo.com> wrote:

> Signed-off-by: Alex Dubov <oakad@yahoo.com>
> 
> --- mspro_block.c.orig	2008-02-04 15:25:16.000000000 +1100
> +++ mspro_block.c	2008-02-04 15:26:28.226886699 +1100
> @@ -668,20 +668,13 @@
> 
>  		spin_lock_irqsave(&msb->q_lock, flags);
>  		if (rc >= 0)
> -			chunk = end_that_request_chunk(req, 1, rc);
> +			chunk = __blk_end_request(req, 0, rc);
>  		else
> -			chunk = end_that_request_first(req, rc,
> -						       req->current_nr_sectors);
> +			chunk = __blk_end_request(req, rc, 0);
> 
>  		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
> -		if (!chunk) {
> -			add_disk_randomness(req->rq_disk);
> -			blkdev_dequeue_request(req);
> -			end_that_request_last(req, rc > 0 ? 1 : rc);
> -		}
>  		spin_unlock_irqrestore(&msb->q_lock, flags);
>  	} while (chunk);
> -
>  }
> 
>  static int mspro_block_has_request(struct mspro_block_data *msb)
> 

Thanks.  However please do prepare patches in `patch -p1' form.

Could you please fix the build error in the code in 2.6.24-mm1?

I part-fixed it (then disabled it) with this:

--- a/drivers/memstick/core/mspro_block.c~a
+++ a/drivers/memstick/core/mspro_block.c
@@ -1233,11 +1232,12 @@ static int mspro_block_resume(struct mem
 	unsigned long flags;
 	int rc = 0;
 
-#ifdef CONFIG_MEMSTICK_UNSAFE_RESUME
+#if defined(CONFIG_MEMSTICK_UNSAFE_RESUME) && 0
 
 	struct mspro_block_data *new_msb;
 	struct memstick_host *host = card->host;
-	struct mspro_sys_attr s_attr, r_attr;
+	struct mspro_sys_attr *s_attr;
+	struct mspro_sys_attr *r_attr;
 	unsigned char cnt;
 
 	mutex_lock(&host->lock);
_

see, this:

		s_attr = container_of(new_msb->attr_group.attrs[cnt],
				      struct mspro_sys_attr,
				      dev_attr);

is broken.  Attribute groups hold `struct attribute' but this code thinks
they hold `struct device_attribute'.  I could bodge it to compile cleanly,
but I don't know if it will work.


