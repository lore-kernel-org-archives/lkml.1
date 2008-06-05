Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYFEKq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYFEKq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYFEKqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:46:47 -0400
Received: from mx1.melware.net ([78.47.171.162]:37871 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYFEKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:46:46 -0400
X-Greylist: delayed 1299 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 06:46:46 EDT
Date: Thu, 5 Jun 2008 12:25:06 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn divas: fix proc creation
In-Reply-To: <20080530233445.GB7358@martell.zuzino.mipt.ru>
Message-ID: <alpine.DEB.0.99.0806051221380.30590@k10.melware.de>
References: <20080530233445.GB7358@martell.zuzino.mipt.ru>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Alexey Dobriyan wrote:
> 1. creating proc entry and not saving pointer to PDE and checking it
>   is not going to work.

I don't know where you found this. I have look even in older versions, but
the pointer divas_proc_entry is set by proc_create(). The patch to
divasproc.c is wrong, it exists from the beginning of the driver.
(2.6.25.4 doesn't contain the bug you describe).

> 2. if proc entry wasn't created, no reason to remove it on error path.

Agreed here. The reason for doing remove_divas_proc() anyway, was to
make sure all possible settings done in !create_divas_proc() are
reverted. But since nothing else is done here, it is okay to remove it.

Armin

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>
> drivers/isdn/hardware/eicon/divasmain.c |    1 -
> drivers/isdn/hardware/eicon/divasproc.c |    4 ++--
> 2 files changed, 2 insertions(+), 3 deletions(-)
>
> --- a/drivers/isdn/hardware/eicon/divasmain.c
> +++ b/drivers/isdn/hardware/eicon/divasmain.c
> @@ -806,7 +806,6 @@ static int DIVA_INIT_FUNCTION divas_init(void)
>
> 	if (!create_divas_proc()) {
> #ifdef MODULE
> -		remove_divas_proc();
> 		divas_unregister_chrdev();
> 		divasfunc_exit();
> #endif
> --- a/drivers/isdn/hardware/eicon/divasproc.c
> +++ b/drivers/isdn/hardware/eicon/divasproc.c
> @@ -125,8 +125,8 @@ static const struct file_operations divas_fops = {
>
> int create_divas_proc(void)
> {
> -	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
> -		    &divas_fops);
> +	divas_proc_entry = proc_create(divas_proc_name, S_IFREG | S_IRUGO,
> +					proc_net_eicon, &divas_fops);
> 	if (!divas_proc_entry)
> 		return (0);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
