Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbXG2Gzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbXG2Gzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 02:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbXG2Gzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 02:55:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759734AbXG2Gzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 02:55:31 -0400
Date: Sat, 28 Jul 2007 23:55:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maik Hampel <m.hampel@gmx.de>
Cc: Neil Brown <neilb@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: md: raid10: fix use-after-free of bio
Message-Id: <20070728235519.1edc6ccb.akpm@linux-foundation.org>
In-Reply-To: <1185547583.2663.10.camel@c64>
References: <1185547583.2663.10.camel@c64>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 16:46:23 +0200 Maik Hampel <m.hampel@gmx.de> wrote:

> In case of read errors raid10d tries to print a nice error message,
> unfortunately using data from an already put bio.
> 
> Signed-off-by: Maik Hampel <m.hampel@gmx.de>
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f730a14..ea1b3e3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1557,7 +1557,6 @@ static void raid10d(mddev_t *mddev)
>  			bio = r10_bio->devs[r10_bio->read_slot].bio;
>  			r10_bio->devs[r10_bio->read_slot].bio =
>  				mddev->ro ? IO_BLOCKED : NULL;
> -			bio_put(bio);
>  			mirror = read_balance(conf, r10_bio);
>  			if (mirror == -1) {
>  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> @@ -1567,6 +1566,7 @@ static void raid10d(mddev_t *mddev)
>  				raid_end_bio_io(r10_bio);
>  			} else {
>  				const int do_sync = bio_sync(r10_bio->master_bio);
> +				bio_put(bio);
>  				rdev = conf->mirrors[mirror].rdev;
>  				if (printk_ratelimit())
>  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
> 
> 

Surely we just leaked that bio if (mirror == -1)?

better:

--- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
+++ a/drivers/md/raid10.c
@@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
+				bio_put(bio);
 			} else {
 				const int do_sync = bio_sync(r10_bio->master_bio);
+				bio_put(bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
_

