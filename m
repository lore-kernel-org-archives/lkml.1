Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZKRWMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZKRWMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZKRWMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:12:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:33142 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbZKRWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:12:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=TGtvt0aJtY70WZgu1Mqk+48QJ7TEEzyppzazFLy189xVlrXutrouI9QNMZchPLxiC0
         Brqy7z7e7CmSfrmWIeMj6LZtZmxOOMFP195SciFjB0EnL1FPRpLZRfDoOIfzCzMQKX6l
         XbGroSpgJDd/YRpajPiGoJZhGYokY29dC2eek=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle changes
Date: Wed, 18 Nov 2009 23:10:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-hotplug@vger.kernel.org
References: <1258468659-5446-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1258468659-5446-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Message-Id: <200911182310.31935.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 15:37:39 Matthew Garrett wrote:

> @@ -1452,6 +1452,15 @@ static inline void __generic_make_request(struct bio *bio)
>  		if (should_fail_request(bio))
>  			goto end_io;
>  
> +		if (bio->bi_bdev->bd_disk->hysteresis_time &&
> +		    bio_has_data(bio) &&
> +		    !mod_timer(&bio->bi_bdev->bd_disk->hysteresis_timer,
> +			       jiffies+msecs_to_jiffies
> +			       (bio->bi_bdev->bd_disk->hysteresis_time))) {
> +			bio->bi_bdev->bd_disk->idle = 0;
> +			schedule_work(&bio->bi_bdev->bd_disk->idle_notify);
> +		}
> +

Wouldn't it be more reliable to hook into places where block requests are
issued/completed instead of queued?  This way you will not miss special
requests (some of them are quite common in practice and may take a relatively
long time to execute, i.e. FLUSH CACHE).

-- 
Bartlomiej Zolnierkiewicz
