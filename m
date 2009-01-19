Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZASCCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZASCCA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZASCBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:01:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36003 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbZASCBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:01:46 -0500
Message-ID: <4973DEFF.9040203@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 11:01:35 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] PCI: pciehp_core, fix lock imbalance
References: <1232205835-21854-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1232205835-21854-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> set_lock_status omits mutex_unlock in fail path. Add the omitted
> unlock.
> 
> As a result a lockup caused by this can be triggered from userspace
> by writing 1 to /sys/bus/pci/slots/.../lock often enough.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/hotplug/pciehp_core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 5482d4e..c248554 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -126,8 +126,10 @@ static int set_lock_status(struct hotplug_slot *hotplug_slot, u8 status)
>  	mutex_lock(&slot->ctrl->crit_sect);
>  
>  	/* has it been >1 sec since our last toggle? */
> -	if ((get_seconds() - slot->last_emi_toggle) < 1)
> +	if ((get_seconds() - slot->last_emi_toggle) < 1) {
> +		mutex_unlock(&slot->ctrl->crit_sect);
>  		return -EINVAL;
> +	}
>  
>  	/* see what our current state is */
>  	retval = get_lock_status(hotplug_slot, &value);

Good catch!

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thanks,
Kenji Kaneshige


