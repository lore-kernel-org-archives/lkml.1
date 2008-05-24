Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYEXFWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYEXFWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYEXFWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:22:24 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:17658 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYEXFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:22:23 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=Date:From:To:Cc:Subject:Message-ID:References:
   Mime-Version:Content-Type:Content-Disposition:In-Reply-To:
   User-Agent;
  b=cXHyDflUzKeTUJtZFjDMGOTrw/T/CGtfiJYsInjXK25FiXvS67FtCm6P
   p7UO+MzcylPD64xEMd3UpoFsLuV7SRe1zf0oTu1B0dDxvncIJkEfPaNPV
   GxHW1M3tAsHV/eb;
Date: Sat, 24 May 2008 00:22:05 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edd: fix error paths in module_init
Message-ID: <20080524052205.GE20890@auslistsprd01.us.dell.com>
References: <20080524020321.GA3470@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524020321.GA3470@APFDCB5C>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:03:23AM +0900, Akinobu Mita wrote:
> This patch fixes error handlings when kzalloc() or edd_device_register()
> failed in module_init. It needs to clean registered edd_devices before
> return error.
> 
> Also this patch fixes return value of module_init. module_init should not
> return positive value.

Thanks for these.  You caught me on holiday; I'll take a more thorough
look when I'm back next week.

 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Matt Domsch <Matt_Domsch@Dell.com>
> ---
>  drivers/firmware/edd.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> Index: 2.6-git/drivers/firmware/edd.c
> ===================================================================
> --- 2.6-git.orig/drivers/firmware/edd.c
> +++ 2.6-git/drivers/firmware/edd.c
> @@ -718,8 +718,7 @@ edd_device_register(struct edd_device *e
>  {
>  	int error;
>  
> -	if (!edev)
> -		return 1;
> +	BUG_ON(!edev);

Wouldn't WARN_ON() and return failure be sufficient?  I hate crashing
the system when loading a driver if I can avoid it.


>  	edd_dev_set_info(edev, i);
>  	edev->kobj.kset = edd_kset;
>  	error = kobject_init_and_add(&edev->kobj, &edd_ktype, NULL,
> @@ -744,8 +743,8 @@ static inline int edd_num_devices(void)
>  static int __init
>  edd_init(void)
>  {
> -	unsigned int i;
> -	int rc=0;
> +	int i;
> +	int rc;
>  	struct edd_device *edev;
>  
>  	printk(KERN_INFO "BIOS EDD facility v%s %s, %d devices found\n",
> @@ -753,29 +752,36 @@ edd_init(void)
>  
>  	if (!edd_num_devices()) {
>  		printk(KERN_INFO "EDD information not available.\n");
> -		return 1;
> +		return -ENODEV;
>  	}
>  
>  	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
>  	if (!edd_kset)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < edd_num_devices() && !rc; i++) {
> +	for (i = 0; i < edd_num_devices(); i++) {
>  		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
> -		if (!edev)
> -			return -ENOMEM;
> +		if (!edev) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
>  
>  		rc = edd_device_register(edev, i);
>  		if (rc) {
>  			kfree(edev);
> -			break;
> +			goto out;
>  		}
>  		edd_devices[i] = edev;
>  	}
>  
> -	if (rc)
> -		kset_unregister(edd_kset);
> -	return rc;
> +	return 0;
> +out:
> +	while (--i >= 0)
> +		edd_device_unregister(edd_devices[i]);
> +
> +	kset_unregister(edd_kset);
> +
> +  	return rc;

I didn't really like my initial approach, but the question was: when
you hit a failure, do you try to back completely out (unregister
everything that had successfully registered until now), or do you
leave the things that have succeeded, and only fail the current and
future devices?  For my purposes, having even the first device be
reported, even if the others couldn't be, is useful.  Hence why I
didn't undo all the registrations on failure.


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
