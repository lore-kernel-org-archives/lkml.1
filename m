Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYAYLRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYAYLRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYAYLRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:17:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35017 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYAYLRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HpaU2AQbUrbxTRmLBbuNpm5wYc2Za7uCk4Ve79EanVnRsru1C0L00rWgPrO0/RqQurfGeRszVXCS2I64ONxFsLTPu4E/V9XP3kVwBMMcukF8BuHvg/EgcNpA/enPebptt2Q8aX6hQN8+YGzsoD5bA8ZoxRDQAT3ftPSpnlnAF0w=
Message-ID: <84144f020801250317pbdafc4fnd47cc8a297194e86@mail.gmail.com>
Date: Fri, 25 Jan 2008 13:17:34 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>
In-Reply-To: <20080125195938t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125195938t-sato@mail.jp.nec.com>
X-Google-Sender-Auth: 24e21dec93a20eea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> diff -uprN -X linux-2.6.24-rc8/Documentation/dontdiff linux-2.6.24-rc8/include/linux/ext3_fs_sb.h linux-2.6.24-rc8-freeze/include/linux/ext3_fs_sb.h
> --- linux-2.6.24-rc8/include/linux/ext3_fs_sb.h 2008-01-16 13:22:48.000000000 +0900
> +++ linux-2.6.24-rc8-freeze/include/linux/ext3_fs_sb.h  2008-01-22 18:20:33.000000000 +0900
> @@ -81,6 +81,8 @@ struct ext3_sb_info {
>         char *s_qf_names[MAXQUOTAS];            /* Names of quota files with journalled quota */
>         int s_jquota_fmt;                       /* Format of quota to use */
>  #endif
> +       /* Delayed work for freeze */
> +       struct delayed_work s_freeze_timeout;

Why not put this in struct super_block? Then you don't need this

> +/**
> + * get_super_block - get super_block
> + * @s_fs_info  : filesystem dependent information
> + *               (super_block.s_fs_info)
> + *
> + * Get super_block which holds s_fs_info from super_blocks.
> + * get_super_block() returns a pointer of super block or
> + * %NULL if it have failed.
> + */
> +struct super_block *get_super_block(void *s_fs_info)
> +{

And these can be put to generic code:

>  /*
> + * ext3_add_freeze_timeout - Add timeout for ext3 freeze.
> + *
> + * @sbi                        : ext3 super block
> + * @timeout_msec       : timeout period
> + *
> + * Add the delayed work for ext3 freeze timeout
> + * to the delayed work queue.
> + */
> +void ext3_add_freeze_timeout(struct ext3_sb_info *sbi,
> +                       long timeout_msec)
> +{
> +       s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
> +
> +       /*
> +        * setup freeze timeout function
> +        */
> +       INIT_DELAYED_WORK(&sbi->s_freeze_timeout, ext3_freeze_timeout);
> +
> +       /* set delayed work queue */
> +       cancel_delayed_work(&sbi->s_freeze_timeout);
> +       schedule_delayed_work(&sbi->s_freeze_timeout, timeout_jiffies);
> +}
> +
> +/*
> + * ext3_del_freeze_timeout - Delete timeout for ext3 freeze.
> + *
> + * @sbi        : ext3 super block
> + *
> + * Delete the delayed work for ext3 freeze timeout
> + * from the delayed work queue.
> + */
> +void ext3_del_freeze_timeout(struct ext3_sb_info *sbi)
> +{
> +       if (delayed_work_pending(&sbi->s_freeze_timeout))
> +               cancel_delayed_work(&sbi->s_freeze_timeout);
> +}

> +/*
> + * ext3_freeze_timeout - Thaw the filesystem.
> + *
> + * @work       : work queue (delayed_work.work)
> + *
> + * Called by the delayed work when elapsing the timeout period.
> + * Thaw the filesystem.
> + */
> +static void ext3_freeze_timeout(struct work_struct *work)
> +{
> +       struct ext3_sb_info *sbi = container_of(work,
> +                               struct ext3_sb_info,
> +                               s_freeze_timeout.work);
> +       struct super_block *sb = get_super_block(sbi);
> +
> +       BUG_ON(sb == NULL);
> +
> +       if (sb->s_frozen != SB_UNFROZEN)
> +               thaw_bdev(sb->s_bdev, sb);
> +}
> +

I am also wondering whether we should have system call(s) for these:

On Jan 25, 2008 12:59 PM, Takashi Sato <t-sato@yk.jp.nec.com> wrote:
> +       case EXT3_IOC_FREEZE: {

> +       case EXT3_IOC_THAW: {

And just convert XFS to use them too?

                        Pekka
