Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYA0Tdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYA0Tdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYA0TcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:32870 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYA0TcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=GxQV5lecSqTrx7vuiI4y0RX1yaJXdcie3LT61s6UZEpKdthqGktdjOktdshspBnSr4qU+z1xMJ8EtkLrbhcsJT6HU718HI2EINzF5ns9k9D2e2OgFOw7BJYIRHt7aCDXrDG8zNX4RtA6W9gGEtlDTx6MagWzqC6Y58c6E8131WY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 07/32] ide-tape: refactor the debug logging facility
Date: Sun, 27 Jan 2008 17:12:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271712.48082.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Teach the debug logging macro to differentiate different log levels based on the
> type of debug level enabled specifically instead of a threshold-based one.
> Thus, convert tape->debug_level to a bitmask that is written to over /proc.

This warrants rename of the setting from "debug_level" to "debug_mask".

> Also,
> - Cleanup and simplify debug macro thus removing a lot of code lines,
> - Get rid of unused debug levels,
> - Adjust the loglevel at several places where it was simply missing (e.g.
> idetape_chrdev_open() etc.)
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |  310 +++++++++++++++++-------------------------------
>  1 files changed, 107 insertions(+), 203 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index efb9d25..a2e7df0 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -103,24 +103,27 @@ typedef struct os_dat_s {
>  #define IDETAPE_MAX_PIPELINE_STAGES	400
>  #define IDETAPE_INCREASE_STAGES_RATE	 20
>  
> -/*
> - *	The following are used to debug the driver:
> - *
> - *	Setting IDETAPE_DEBUG_LOG to 1 will log driver flow control.
> - *	some places.
> - *
> - *	Setting them to 0 will restore normal operation mode:
> - *
> - *		1.	Disable logging normal successful operations.
> - *		2.	Disable self-sanity checks.
> - *		3.	Errors will still be logged, of course.
> - *
> - *	All the #if DEBUG code will be removed some day, when the driver
> - *	is verified to be stable enough. This will make it much more
> - *	esthetic.
> - */
> +enum {
> +	DBG_ERR =		(1 << 0),
> +	DBG_SENSE =		(1 << 1),
> +	DBG_CHRDEV =		(1 << 2),
> +	DBG_PROCS =		(1 << 3),
> +	DBG_PCRQ_STACK =	(1 << 4),
> +};
> +
> +/* define to see debug info */
>  #define IDETAPE_DEBUG_LOG		0
>  
> +#if IDETAPE_DEBUG_LOG
> +#define debug_log(lvl, fmt, args...)			\
> +{							\
> +	if (tape->debug_level & lvl)			\
> +	printk(KERN_INFO "ide-tape: " fmt, ## args)	\
> +}
> +#else
> +#define debug_log(lvl, fmt, args...) do {} while (0)
> +#endif
> +

with IDETAPE_DEBUG_LOG defined to 1:

drivers/ide/ide-tape.c: In function ‘idetape_next_pc_storage’:
drivers/ide/ide-tape.c:929: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_next_rq_storage’:
drivers/ide/ide-tape.c:953: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_analyze_error’:
drivers/ide/ide-tape.c:988: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_active_next_stage’:
drivers/ide/ide-tape.c:1045: warning: format ‘%f’ expects type ‘double’, but argument 2 has type ‘const char *’
drivers/ide/ide-tape.c:1045: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_increase_max_pipeline_stages’:
drivers/ide/ide-tape.c:1073: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_remove_stage_head’:
drivers/ide/ide-tape.c:1119: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_abort_pipeline’:
drivers/ide/ide-tape.c:1154: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_end_request’:
drivers/ide/ide-tape.c:1182: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_request_sense_callback’:
drivers/ide/ide-tape.c:1247: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_postpone_request’:
drivers/ide/ide-tape.c:1333: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_pc_intr’:
drivers/ide/ide-tape.c:1359: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1392: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1398: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1418: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1424: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1481: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:1505: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_issue_packet_command’:
drivers/ide/ide-tape.c:1640: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_pc_callback’:
drivers/ide/ide-tape.c:1679: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_rw_callback’:
drivers/ide/ide-tape.c:1810: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_do_request’:
drivers/ide/ide-tape.c:1886: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_kmalloc_stage’:
drivers/ide/ide-tape.c:2079: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_add_stage_tail’:
drivers/ide/ide-tape.c:2179: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_read_position_callback’:
drivers/ide/ide-tape.c:2224: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:2228: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:2229: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:2236: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_read_position’:
drivers/ide/ide-tape.c:2378: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_queue_rw_tail’:
drivers/ide/ide-tape.c:2511: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_add_chrdev_write_request’:
drivers/ide/ide-tape.c:2619: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_add_chrdev_read_request’:
drivers/ide/ide-tape.c:2857: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_rewind_tape’:
drivers/ide/ide-tape.c:2955: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_blkdev_ioctl’:
drivers/ide/ide-tape.c:2982: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_read’:
drivers/ide/ide-tape.c:3114: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c:3156: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_write’:
drivers/ide/ide-tape.c:3177: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_mtioctop’:
drivers/ide/ide-tape.c:3336: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_ioctl’:
drivers/ide/ide-tape.c:3474: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_open’:
drivers/ide/ide-tape.c:3534: error: expected ‘;’ before ‘}’ token
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_release’:
drivers/ide/ide-tape.c:3633: error: expected ‘;’ before ‘}’ token
make[1]: *** [drivers/ide/ide-tape.o] Error 1
make: *** [drivers/ide/ide-tape.o] Error 2

after adding missing ';' after printk()...

drivers/ide/ide-tape.c: In function ‘idetape_active_next_stage’:
drivers/ide/ide-tape.c:1045: warning: format ‘%f’ expects type ‘double’, but argument 2 has type ‘const char *’
drivers/ide/ide-tape.c: In function ‘idetape_chrdev_open’:
drivers/ide/ide-tape.c:3534: warning: ‘tape’ is used uninitialized in this function

>  /*
>   *	After each failed packet command we issue a request sense command
>   *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
> @@ -557,7 +560,7 @@ typedef struct ide_tape_obj {
>           * 5 : 4+include pc_stack rq_stack info
>           * 6 : 5+USE_COUNT updates
>           */

the above documentation needs to be updated/merged with DBG_* enums

> -         int debug_level; 
> +         u32 debug_level;

debug_level -> debug_mask

also checkpatch.pl complaints about this line:

ERROR: use tabs not spaces
#72: FILE: drivers/ide/ide-tape.c:563:
+         u32 debug_level;$

[...]

the rest of the patch looks fine

Please recast/resubmit.

Thanks,
Bart
