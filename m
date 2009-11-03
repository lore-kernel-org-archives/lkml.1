Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZKCIYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZKCIYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZKCIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:24:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbZKCIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:24:12 -0500
Date: Tue, 3 Nov 2009 00:23:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jim Paris <jim@jtan.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/ps3: Fix slow VRAM IO
Message-Id: <20091103002322.1f04adbe.akpm@linux-foundation.org>
In-Reply-To: <4ADCC4E3.8060104@am.sony.com>
References: <4ADCC4E3.8060104@am.sony.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 12:58:27 -0700 Geoff Levand <geoffrey.levand@am.sony.com> wrote:

> 
> From: Hideyuki Sasaki <Hideyuki_Sasaki@hq.scei.sony.co.jp>
> 
> The current PS3 VRAM driver uses msleep() to wait for completion
> of RSX DMA transfers between system memory and VRAM.  Depending
> on the system timing, the processing delay and overhead of this
> msleep() call can significantly impact VRAM driver IO.
> 
> To avoid the condition, add a short duration (200 usec max)
> udelay() polling loop before entering the msleep() polling
> loop.
> 

When raising a performance-based patch, please always try to include
before-and-after performance measurements in the changelog.  People
want to know the magnitude of the improvement.

> 
>  drivers/block/ps3vram.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -123,7 +123,15 @@ static int ps3vram_notifier_wait(struct 
>  {
>  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
>  	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
> -	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +	unsigned long timeout;
> +
> +	for (timeout = 20; timeout; timeout--) {

	for (timeout = 0; timeout < 20; timeout++) {

would be simpler.

> +		if (!notify[3])
> +			return 0;
> +		udelay(10);
> +	}

You might as well do a udelay(1) here.  The additional cost will be
negligible, and it will reduce latency.

> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);

The maximum latency is now timout_ms + 200usec.

That's OK with the current constants, but if someone later changes a
constant, the error could become significant.

Perhaps that isn't worth bothering about though.

>  	do {
>  		if (!notify[3])


