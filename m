Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbXEVVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbXEVVQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbXEVVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:15:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660AbXEVVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:15:57 -0400
Date: Tue, 22 May 2007 14:12:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 5/7] genhd: send async notification on media change
Message-Id: <20070522141211.fe00333f.akpm@linux-foundation.org>
In-Reply-To: <20070509163835.56ad28e0.kristen.c.accardi@intel.com>
References: <20070510072247.063476979@intel.com>
	<20070509163835.56ad28e0.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 16:38:35 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> Send an uevent to user space to indicate that a media change event has occurred.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-git/block/genhd.c
> ===================================================================
> --- 2.6-git.orig/block/genhd.c
> +++ 2.6-git/block/genhd.c
> @@ -643,6 +643,27 @@ struct seq_operations diskstats_op = {
>  	.show	= diskstats_show
>  };
>  
> +static void media_change_notify_thread(struct work_struct *work)
> +{
> +	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
> +	char event[] = "MEDIA_CHANGE=1";
> +	char *envp[] = { event, NULL };
> +
> +	/*
> +	 * set enviroment vars to indicate which event this is for
> +	 * so that user space will know to go check the media status.
> +	 */
> +	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
> +	put_device(gd->driverfs_dev);
> +}
> +
> +void genhd_media_change_notify(struct gendisk *disk)
> +{
> +	get_device(disk->driverfs_dev);
> +	schedule_work(&disk->async_notify);
> +}
> +EXPORT_SYMBOL_GPL(genhd_media_change_notify);
> +
>  struct gendisk *alloc_disk(int minors)
>  {
>  	return alloc_disk_node(minors, -1);
> @@ -672,6 +693,8 @@ struct gendisk *alloc_disk_node(int mino
>  		kobj_set_kset_s(disk,block_subsys);
>  		kobject_init(&disk->kobj);
>  		rand_initialize_disk(disk);
> +		INIT_WORK(&disk->async_notify,
> +			media_change_notify_thread);
>  	}
>  	return disk;

Why does this do a schedule_work() rather than calling kobject_uevent_env()
directly?
