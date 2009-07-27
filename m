Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZG0Vew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZG0Vew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZG0Vev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:34:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbZG0Vev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:34:51 -0400
Date: Mon, 27 Jul 2009 14:32:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: unsik Kim <donari75@gmail.com>
Cc: axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org,
       donari75@gmail.com
Subject: Re: [PATCH 1/2] mg_disk: remove prohibited sleep operation
Message-Id: <20090727143256.8b99ced7.akpm@linux-foundation.org>
In-Reply-To: <1248325066-4071-1-git-send-email-donari75@gmail.com>
References: <1248325066-4071-1-git-send-email-donari75@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 13:57:45 +0900
unsik Kim <donari75@gmail.com> wrote:

> mflash's polling driver operate in standard request_fn_proc's context,
> sleep in this isn't permitted.
> Signed-off-by: unsik Kim <donari75@gmail.com>
> ---
>  drivers/block/mg_disk.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> index 64f90f5..26371d5 100644
> --- a/drivers/block/mg_disk.c
> +++ b/drivers/block/mg_disk.c
> @@ -244,8 +244,6 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
>  			mg_dump_status("not ready", status, host);
>  			return MG_ERR_INV_STAT;
>  		}
> -		if (prv_data->use_polling)
> -			msleep(1);
>  
>  		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
>  	} while (time_before(cur_jiffies, expire));

This change has the potential to cause the driver to use much much more
CPU time and power.  Are you really sure that the driver is optimal in
this area?

On possibility is to pass a flag into mg_wait() telling it whether it
is permitted to sleep:

		if (may_sleep && prv_data->use_polling)
			msleep(1);
		else
			mdelay(1);

or

		if (may_sleep && prv_data->use_polling)
			msleep(1);
		else
			/* nothing */;


so that then we only consume extra power if the caller is the
request_fn handler.

