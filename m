Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZFIMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZFIMd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZFIMds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:33:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42242 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZFIMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:33:48 -0400
Subject: Re: [PATCH] MTD: Add UBI reboot notifier
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <018abcd2d98090bda0f75d3c95c9ec85@localhost>
References: <018abcd2d98090bda0f75d3c95c9ec85@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Jun 2009 15:32:55 +0300
Message-Id: <1244550775.5847.385.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2009 12:32:59.0204 (UTC) FILETIME=[6C3CF040:01C9E8FE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me. I'm though wandering if UBIFS should also
register a reboot notifier an sync write-buffers in it...
But this is not related to your patch.

Some nit-picking.

On Mon, 2009-06-08 at 22:14 -0700, Kevin Cernekee wrote:
>  /**
> + * ubi_reboot_notifier - halt UBI transactions immediately prior to a reboot
> + * @n: notifier_block struct (inside our struct ubi_device)
> + * @val: unused
> + * @v: unused
> + */
> +static int ubi_reboot_notifier(struct notifier_block *n, unsigned long val,
> +	void *v)
> +{
> +	struct ubi_device *ubi = container_of(n, struct ubi_device,
> +		reboot_notifier);
> +
> +	if (ubi->bgt_thread)
> +		kthread_stop(ubi->bgt_thread);
> +	return NOTIFY_DONE;
> +}

Several small things in comments and indentations. Take a look how
other UBI funcs do things, I'd be happier to keep the code consistent.

> +/**
>   * ubi_attach_mtd_dev - attach an MTD device.
>   * @mtd: MTD device description object
>   * @ubi_num: number to assign to the new UBI device
> @@ -876,6 +894,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
>  		ubi->thread_enabled = 1;
>  	wake_up_process(ubi->bgt_thread);
>  
> +	/* Flash device priority is 0.  UBI needs to shut down first. */
> +	ubi->reboot_notifier.priority = 1;
> +	ubi->reboot_notifier.notifier_call = ubi_reboot_notifier;
> +	register_reboot_notifier(&ubi->reboot_notifier);
> +
>  	ubi_devices[ubi_num] = ubi;
>  	return ubi_num;
>  
> @@ -945,6 +968,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
>  	 * Before freeing anything, we have to stop the background thread to
>  	 * prevent it from doing anything on this device while we are freeing.
>  	 */
> +	unregister_reboot_notifier(&ubi->reboot_notifier);
>  	if (ubi->bgt_thread)
>  		kthread_stop(ubi->bgt_thread);
>  
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index c055511..44a45b9 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -36,6 +36,7 @@
>  #include <linux/device.h>
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
> +#include <linux/notifier.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/ubi.h>
>  
> @@ -420,6 +421,7 @@ struct ubi_device {
>  	struct task_struct *bgt_thread;
>  	int thread_enabled;
>  	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
> +	struct notifier_block reboot_notifier;

How about commenting this field above the struct ubi_device
definition?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

