Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbYG2U6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbYG2U6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYG2U6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:58:05 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45212 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYG2U6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:58:04 -0400
Message-ID: <488F84ED.9010200@keyaccess.nl>
Date: Tue, 29 Jul 2008 23:00:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
References: <20080720085924.122feb2b@infradead.org> <20080720090041.5924f5ff@infradead.org>
In-Reply-To: <20080720090041.5924f5ff@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-07-08 18:00, Arjan van de Ven wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] fastboot: sync the async execution before late_initcall and move level 6s (sync) first

> Second, this patch makes sure that level 6s (sync) happens before the async code starts,
> and puts a user in driver/pci in this category that needs to happen before device init.

[ ... ]

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 44a46c9..d75295d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1889,7 +1889,7 @@ static int __devinit pci_setup(char *str)
>  }
>  early_param("pci", pci_setup);
>  
> -device_initcall(pci_init);
> +device_initcall_sync(pci_init);
>  
>  EXPORT_SYMBOL(pci_reenable_device);
>  EXPORT_SYMBOL(pci_enable_device_io);
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 39c1afc..514dbdf 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -372,11 +372,12 @@
>    	*(.initcall5.init)						\
>    	*(.initcall5s.init)						\
>  	*(.initcallrootfs.init)						\
> +  	*(.initcall6s.init)						\
>  	__async_initcall_start = .;					\
>  	*(.initcall6a.init)						\
>  	__async_initcall_end = .;					\
>    	*(.initcall6.init)						\
> -  	*(.initcall6s.init)						\
> +	__device_initcall_end = .;					\
>    	*(.initcall7.init)						\
>    	*(.initcall7s.init)

Isn't this a bit confusing? All the other sync levels are directly after 
their respective levels. I can see why you want another level now, but 
shouldn't that mean late_initcall now wants to be 8, device_initcall 7 
and your new 6s just 6 (device_core_initcall or something...)?

Rene.
