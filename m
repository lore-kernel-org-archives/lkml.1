Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXFSIIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXFSIIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXFSII3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:08:29 -0400
Received: from smtp.nokia.com ([131.228.20.173]:65114 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbXFSII2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:08:28 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1182184301.6074.62.camel@localhost.localdomain>
References: <1182184301.6074.62.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Jun 2007 11:07:35 +0300
Message-Id: <1182240455.4403.52.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Jun 2007 08:07:35.0469 (UTC) FILETIME=[E51E0DD0:01C7B248]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 17:31 +0100, Richard Purdie wrote:
> +static int mtdoops_erase_block(struct mtd_info *mtd, int offset)
> +{
> +	struct erase_info erase;
> +	DECLARE_WAITQUEUE(wait, current);
> +	wait_queue_head_t wait_q;
> +	int ret;
> +
> +	init_waitqueue_head(&wait_q);
> +	erase.mtd = mtd;
> +	erase.callback = mtdoops_erase_callback;
> +	erase.addr = offset;
> +	if (mtd->erasesize < OOPS_PAGE_SIZE)
> +		erase.len = OOPS_PAGE_SIZE;
> +	else
> +		erase.len = mtd->erasesize;
> +	erase.priv = (u_long)&wait_q;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	add_wait_queue(&wait_q, &wait);
> +
> +	ret = mtd->erase(mtd, &erase);
> +	if (ret) {
> +		set_current_state(TASK_RUNNING);
> +		remove_wait_queue(&wait_q, &wait);
> +		printk(KERN_WARNING "mtdoops: erase of region [0x%x, 0x%x] "
> +				     "on \"%s\" failed\n",
> +			erase.addr, erase.len, mtd->name);
> +		return ret;
> +	}
> +
> +	schedule();  /* Wait for erase to finish. */
> +	remove_wait_queue(&wait_q, &wait);
> +
> +	return 0;
> +}

Also, could you please use wait_event_interruptible() instead of
set_current_state() which looks better (indeed, you have wait queue, so
use wq calls).

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

