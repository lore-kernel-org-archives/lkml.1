Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZASS4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZASS4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZASS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:56:40 -0500
Received: from outbound-mail-304.bluehost.com ([67.222.53.250]:60676 "HELO
	outbound-mail-304.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758613AbZASS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:56:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=drdQ58ivJKHc9MD6qdknTWT8CFRD4T0rd9anbjdgDMD4AGdfagz8U0mv3Lq1beHwax/j+DQ4HyGulx9vss8p3alLnyUlQ1tsRmxnczCzaOM9E4gWedqB8wt28vEcXd+z;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] PCI: pciehp_core, fix lock imbalance
Date: Mon, 19 Jan 2009 10:56:36 -0800
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <1232205835-21854-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1232205835-21854-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191056.36992.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 17, 2009 7:23 am Jiri Slaby wrote:
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
> diff --git a/drivers/pci/hotplug/pciehp_core.c
> b/drivers/pci/hotplug/pciehp_core.c index 5482d4e..c248554 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -126,8 +126,10 @@ static int set_lock_status(struct hotplug_slot
> *hotplug_slot, u8 status) mutex_lock(&slot->ctrl->crit_sect);
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

Applied to my for-linus branch (with Kenji-san's reviewed-by), thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
