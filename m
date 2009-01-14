Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbZANVOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbZANVOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZANVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:13:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbZANVNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:13:50 -0500
Date: Wed, 14 Jan 2009 13:13:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erik Ekman <erik@kryo.se>
Cc: linux-kernel@vger.kernel.org, abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [PATCH -tip][RFC] pnpbios: Fix warning if no hotplug
Message-Id: <20090114131321.78c2d088.akpm@linux-foundation.org>
In-Reply-To: <20090110115219.1ebb94cd.erik@kryo.se>
References: <20090110115219.1ebb94cd.erik@kryo.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 11:52:19 +0100
Erik Ekman <erik@kryo.se> wrote:

> pnpbios: Fix warning if no hotplug
> 
> When hotplug is turned off, I get:
> drivers/pnp/pnpbios/core.c: In function 'pnpbios_thread_init':
> drivers/pnp/pnpbios/core.c:578: warning: unused variable 'task'
> 
> Is this a good way to fix this? Or should I just a #ifdef
> CONFIG_HOTPLUG around the task variable?
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>
> ---
> diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
> index 996f648..e706d22 100644
> --- a/drivers/pnp/pnpbios/core.c
> +++ b/drivers/pnp/pnpbios/core.c
> @@ -575,8 +575,6 @@ fs_initcall(pnpbios_init);
>  
>  static int __init pnpbios_thread_init(void)
>  {
> -	struct task_struct *task;
> -
>  #if defined(CONFIG_PPC)
>  	if (check_legacy_ioport(PNPBIOS_BASE))
>  		return 0;
> @@ -584,10 +582,13 @@ static int __init pnpbios_thread_init(void)
>  	if (pnpbios_disabled)
>  		return 0;
>  #ifdef CONFIG_HOTPLUG
> -	init_completion(&unload_sem);
> -	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> -	if (!IS_ERR(task))
> -		unloading = 0;
> +	{
> +		struct task_struct *task;
> +		init_completion(&unload_sem);
> +		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> +		if (!IS_ERR(task))
> +			unloading = 0;
> +	}
>  #endif
>  	return 0;
>  }

Well you could just remove `task' altogether and do

	if (!IS_ERR(kthread_run(pnp_dock_thread, NULL, "kpnpbiosd")))
		unloading = 0;

but

a) `unloading' doesn't actually do anything, and can be removed

b) this function shouldn't return 0 if kthread_run() failed
