Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZGBI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZGBI2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZGBI2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:28:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58335 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZGBI2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:28:01 -0400
Date: Thu, 2 Jul 2009 10:28:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hannes Reinecke <hare@suse.de>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
Message-ID: <20090702082804.GP23611@kernel.dk>
References: <20090702082313.F3754D340B@pentland.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702082313.F3754D340B@pentland.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02 2009, Hannes Reinecke wrote:
> 
> When doing an unexpected shutdown like kexec the cciss
> firmware might still have some commands in flight, which
> it is trying to complete.
> The driver is doing it's best on resetting the HBA,
> but sadly there's a firmware issue causing the firmware
> _not_ to abort or drop old commands.
> So the firmware will send us commands which we haven't
> accounted for, causing the driver to panic.
> 
> With this patch we're just ignoring these commands as
> there is nothing we could be doing with them anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/cciss.c     |   14 ++++++++++++--
>  drivers/block/cciss_cmd.h |    1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index c7a527c..8dd4c0d 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -226,7 +226,16 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
>  
>  static inline void removeQ(CommandList_struct *c)
>  {
> -	if (WARN_ON(hlist_unhashed(&c->list)))
> +	/*
> +	 * After kexec/dump some commands might still
> +	 * be in flight, which the firmware will try
> +	 * to complete. Resetting the firmware doesn't work
> +	 * with old fw revisions, so we have to mark
> +	 * them off as 'stale' to prevent the driver from
> +	 * falling over.
> +	 */
> +	if (unlikely(hlist_unhashed(&c->list))) {
> +		c->cmd_type = CMD_MSG_STALE;
>  		return;
>
>       hlist_del_init(&c->list);

Ehm, that looks rather dangerous. What's the level of testing this patch
received?

-- 
Jens Axboe

