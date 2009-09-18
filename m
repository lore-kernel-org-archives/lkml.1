Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZIRUsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZIRUsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZIRUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:48:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223AbZIRUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kmbM/TnPHErwmNTVDj3GS9OirEFmxzSvnstrv5LIpz/th7NZUa6fUmen7DgQQ8g9Ce
         OspT6/D40E3qHRI8G8SwDDtWqWCaOQW61a0EbeJdaGg9eVZEV+mLgw82A3Lx93EG94bj
         xD6Trmo3XrYf1bE/CmvXoyWXdHnwF3WWxBGek=
Message-ID: <4AB3F227.3030602@gmail.com>
Date: Fri, 18 Sep 2009 22:48:39 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 3/4] virtual block device driver (ramzswap)
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org> <1253227412-24342-4-git-send-email-ngupta@vflare.org>
In-Reply-To: <1253227412-24342-4-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> (...)
> +
> +static int page_zero_filled(void *ptr)
> +{
> +	u32 pos;
> +	u64 *page;
> +
> +	page = (u64 *)ptr;
> +
> +	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
> +		if (page[pos])
> +			return 0;
> +	}
> +
> +	return 1;
> +}

Wouldn't unsigned long *page be better for both 32-bit and 64-bit machines?

(This function could return bool)

> (...)
> +static void create_device(struct ramzswap *rzs, int device_id)
> +{
> +	mutex_init(&rzs->lock);
> +	INIT_LIST_HEAD(&rzs->backing_swap_extent_list);
> +
> +	rzs->queue = blk_alloc_queue(GFP_KERNEL);
> +	if (!rzs->queue) {
> +		pr_err("Error allocating disk queue for device %d\n",
> +			device_id);
> +		return;
> +	}
> +
> +	blk_queue_make_request(rzs->queue, ramzswap_make_request);
> +	rzs->queue->queuedata = rzs;
> +
> +	 /* gendisk structure */
> +	rzs->disk = alloc_disk(1);
> +	if (!rzs->disk) {
> +		blk_cleanup_queue(rzs->queue);
> +		pr_warning("Error allocating disk structure for device %d\n",
> +			device_id);
> +		return;
> +	}
> +
> +	rzs->disk->major = ramzswap_major;
> +	rzs->disk->first_minor = device_id;
> +	rzs->disk->fops = &ramzswap_devops;
> +	rzs->disk->queue = rzs->queue;
> +	rzs->disk->private_data = rzs;
> +	snprintf(rzs->disk->disk_name, 16, "ramzswap%d", device_id);
> +
> +	/*
> +	 * Actual capacity set using RZSIO_SET_DISKSIZE_KB ioctl
> +	 * or set equal to backing swap device (if provided)
> +	 */
> +	set_capacity(rzs->disk, 0);
> +	add_disk(rzs->disk);
> +
> +	rzs->init_done = 0;
> +
> +	return;
> +}

needless return

Marcin

