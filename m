Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZE2Tm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZE2Tm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZE2TmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:42:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbZE2TmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:42:16 -0400
Date: Fri, 29 May 2009 12:42:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk,
       mikem@beardog.cca.cpqcorp.net, scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH 2/2] cciss: Fix SCSI device reset handler
Message-Id: <20090529124208.531839fe.akpm@linux-foundation.org>
In-Reply-To: <20090527203007.GA30160@beardog.cca.cpqcorp.net>
References: <20090527203007.GA30160@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 15:30:07 -0500
scameron@beardog.cca.cpqcorp.net wrote:

> +static int wait_for_device_to_become_ready(ctlr_info_t *h,
> +	unsigned char lunaddr[])
> +{
> +	int rc;
> +	int count = 0;
> +	int waittime = HZ;
> +	CommandList_struct *c;
> +
> +	c = cmd_alloc(h, 1);
> +	if (!c) {
> +		printk(KERN_WARNING "cciss%d: out of memory in "
> +			"wait_for_device_to_become_ready.\n", h->ctlr);
> +		return IO_ERROR;
> +	}
> +
> +	/* Send test unit ready until device ready, or give up. */
> +	while (count < 20) {
> +
> +		/* Wait for a bit.  do this first, because if we send
> +		 * the TUR right away, the reset will just abort it.
> +		 */
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(waittime);

That's schedule_timeout_interruptible().

The problem with interruptible sleeps of this nature is that they are
no-ops if the calling process happens to have signal_pending().  I
suspect that this condition will break your driver.

If so, switching to schedule_timeout_uninterruptible() will unbreak it.

