Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZKOJqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZKOJqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 04:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZKOJq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 04:46:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZKOJq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 04:46:28 -0500
Date: Sun, 15 Nov 2009 10:46:32 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Jiri Kosina <jkosina@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole
 system goes to hell
Message-ID: <20091115094632.GB11463@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029083820.GZ10727@kernel.dk>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0x3FAF957D
X-OpenPGP-Fingerprint: 0BAE BB83 8B8A 3DE4 08F3  CEB9 DA0F CCBB 3FAF 957D
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091108 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX19U3qksbpqu4DDQ7Myp4Z68W1HRDosENmkAFTy
 ZdJ+HcXlK7p6kLVuCB97CMtBa/5FtNQkLNBu07tcbxBEeu7tp2
 9KFuJleV/m/cBOGYr5FUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.2009, Jens Axboe wrote: 

I had the same problem which has been discussed in this thread, 
and can confirm that this patch from Jens Axboe (which is already merged into 2.6.32-rc7) 
fixes it for me.

> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 4f53a6d..756c31b 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -614,6 +616,18 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  		kthread_stop(wb->task);
>  }
>  
> +static void bdi_prune_sb(struct backing_dev_info *bdi)
> +{
> +	struct super_block *sb;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (sb->s_bdi == bdi)
> +			sb->s_bdi = NULL;
> +	}
> +	spin_unlock(&sb_lock);
> +}
> +
>  void bdi_unregister(struct backing_dev_info *bdi)
>  {
>  	if (bdi->dev) {
> @@ -624,6 +638,8 @@ void bdi_unregister(struct backing_dev_info *bdi)
>  		device_unregister(bdi->dev);
>  		bdi->dev = NULL;
>  	}
> +
> +	bdi_prune_sb(bdi);
>  }
>  EXPORT_SYMBOL(bdi_unregister);
