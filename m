Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZEHXKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZEHXKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZEHXKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:10:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbZEHXKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:10:37 -0400
Date: Fri, 8 May 2009 16:05:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: benh@kernel.crashing.org, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Geert.Uytterhoeven@sonycom.com, jim@jtan.com
Subject: Re: [PATCH 04/15] ps3vram: Replace mutex by spinlock + list
Message-Id: <20090508160544.28189203.akpm@linux-foundation.org>
In-Reply-To: <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 May 2009 16:01:13 +0200
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> +static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
> +{
> +	struct ps3_system_bus_device *dev = q->queuedata;
> +	struct ps3vram_priv *priv = dev->core.driver_data;
> +
> +	dev_dbg(&dev->core, "%s\n", __func__);
> +
> +	spin_lock_irq(&priv->lock);
> +	if (priv->tail) {
> +		priv->tail->bi_next = bio;
> +		priv->tail = bio;
> +		spin_unlock_irq(&priv->lock);
> +		return 0;
> +	}
> +
> +	priv->tail = bio;
> +	spin_unlock_irq(&priv->lock);
> +
> +	do {
> +		bio = ps3vram_do_bio(dev, bio);
> +	} while (bio);

Is there something which prevents two threads of control from walking
the same list at the same time?

> +
>  	return 0;
>  }

