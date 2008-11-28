Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYK1TW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYK1TW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYK1TWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:22:20 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:61442 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYK1TWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:22:19 -0500
Date: Fri, 28 Nov 2008 14:22:15 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] acpi: close race in toshiba_acpi driver
In-reply-to: <20081128081909.65b7607a@infradead.org>
X-X-Sender: lenb@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, philipl@overt.org, akpm@linux-foundation.org
Message-id: <alpine.LFD.2.00.0811281422070.3204@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128081909.65b7607a@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-Len

On Fri, 28 Nov 2008, Arjan van de Ven wrote:

> 
> From 5d8af90c16de14f5d27c9d0b63118277941ebb4e Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 28 Nov 2008 08:14:14 -0800
> Subject: [PATCH] acpi: close race in toshiba_acpi driver
> 
> the toshiba ACPI driver will, in a failure case, free the rfkill state
> before stopping the polling timer that would use this state. More interesting,
> in the same failure case handling, it calls the exit function, which also
> frees the rfkill state, but after stopping the polling.
> 
> If the race happens, a NULL pointer is passed to rfkill_force_state()
> which then causes a nice dereference.
> 
> Fix the race by just not doing the too-early freeing of the rfkill state.
> 
> This appears to be the cause of a hot issue on kerneloops.org; while I
> have no solid evidence of that this patch will fix the issue, the race
> appears rather real.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/acpi/toshiba_acpi.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
> index 66aac06..25f531d 100644
> --- a/drivers/acpi/toshiba_acpi.c
> +++ b/drivers/acpi/toshiba_acpi.c
> @@ -848,8 +848,6 @@ static int __init toshiba_acpi_init(void)
>  	ret = input_register_polled_device(toshiba_acpi.poll_dev);
>  	if (ret) {
>  		printk(MY_ERR "unable to register kill-switch input device\n");
> -		rfkill_free(toshiba_acpi.rfk_dev);
> -		toshiba_acpi.rfk_dev = NULL;
>  		toshiba_acpi_exit();
>  		return ret;
>  	}
> -- 
> 1.6.0.4
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 
