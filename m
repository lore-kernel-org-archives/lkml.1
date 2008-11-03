Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYKCQIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYKCQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYKCQI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:08:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYKCQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:08:26 -0500
Subject: Re: bdi: register sysfs bdi device only once per queue
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1225727635.6009.9.camel@linux>
References: <1225727635.6009.9.camel@linux>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Nov 2008 17:08:50 +0100
Message-Id: <1225728530.7803.1630.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 16:53 +0100, Kay Sievers wrote:
> Andrew, can you pick this up this please?
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: bdi: register sysfs bdi device only once per queue
> 
> Devices which share the same queue, like floppies and mtd devices,
> get registered multiple times in the bdi interface, but bdi accounts
> only the last registered device of the devices sharing one queue.

David, is there any reason the mtd devices do this?

> On remove, all earlier registered devices leak, stay around in
> sysfs, and cause "duplicate filename" errors if the devices are
> re-created.
> 
> This prevents the creation of multiple bdi interfaces per queue,
> and the bdi device will carry the dev_t name of the block device
> which is the first one registered, of the pool of devices using
> the same queue.
> 
> Tested-By: Peter Korsgaard <jacmet@sunsite.dk>
> Acked-By: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index f2e574d..e6676e5 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  	int ret = 0;
>  	struct device *dev;
>  
> +	if (bdi->dev)
> +		goto exit;
> +
>  	va_start(args, fmt);
>  	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
>  	va_end(args);

Would it make sense to make it print something like, please fix me?
