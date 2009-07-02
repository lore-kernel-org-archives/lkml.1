Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZGBTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZGBTAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZGBTAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:00:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39576 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZGBTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:00:46 -0400
Date: Thu, 2 Jul 2009 21:00:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hannes Reinecke <hare@suse.de>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org,
       mikem@beardog.cca.cpqcorp.net
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
Message-ID: <20090702190049.GA23611@kernel.dk>
References: <20090702093638.D1B1FD340B@pentland.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702093638.D1B1FD340B@pentland.suse.de>
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

Looks good to me. Mike, Stephen?

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/cciss.c     |   15 +++++++++++++--
>  drivers/block/cciss_cmd.h |    1 +
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index c7a527c..65a0655 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -226,8 +226,18 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
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
> +	if (WARN_ON(hlist_unhashed(&c->list))) {
> +		c->cmd_type = CMD_MSG_STALE;
>  		return;
> +	}
>  
>  	hlist_del_init(&c->list);
>  }
> @@ -4246,7 +4256,8 @@ static void fail_all_cmds(unsigned long ctlr)
>  	while (!hlist_empty(&h->cmpQ)) {
>  		c = hlist_entry(h->cmpQ.first, CommandList_struct, list);
>  		removeQ(c);
> -		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
> +		if (c->cmd_type != CMD_MSG_STALE)
> +			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
>  		if (c->cmd_type == CMD_RWREQ) {
>  			complete_command(h, c, 0);
>  		} else if (c->cmd_type == CMD_IOCTL_PEND)
> diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
> index cd665b0..dbaed1e 100644
> --- a/drivers/block/cciss_cmd.h
> +++ b/drivers/block/cciss_cmd.h
> @@ -274,6 +274,7 @@ typedef struct _ErrorInfo_struct {
>  #define CMD_SCSI	0x03
>  #define CMD_MSG_DONE	0x04
>  #define CMD_MSG_TIMEOUT 0x05
> +#define CMD_MSG_STALE	0xff
>  
>  /* This structure needs to be divisible by 8 for new
>   * indexing method.
> -- 
> 1.5.3.2
> 

-- 
Jens Axboe

