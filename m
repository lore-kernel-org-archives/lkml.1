Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZGGRBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZGGRBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZGGRBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:01:31 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:58907 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZGGRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:01:30 -0400
Date: Tue, 7 Jul 2009 19:01:25 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak in request_firmware()
Message-ID: <20090707190125.61920d00@gondolin>
In-Reply-To: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jul 2009 16:17:00 +0100,
Catalin Marinas <catalin.marinas@arm.com> wrote:

> The patch below may fix the problem but it's only later tonight that I
> can test it and confirm:

Your patch looks fine to me (didn't test it either), just one minor nit:

> 
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index ddeb819..12e6e64 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -357,7 +357,7 @@ static void fw_dev_release(struct device *dev)
>  	kfree(fw_priv->pages);
>  	kfree(fw_priv->fw_id);
>  	kfree(fw_priv);
> -	put_device(dev);
> +	kfree(dev);
> 
>  	module_put(THIS_MODULE);
>  }
> @@ -407,14 +407,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
>  	retval = device_register(f_dev);
>  	if (retval) {
>  		dev_err(device, "%s: device_register failed\n", __func__);
> +		kfree(fw_priv->fw_id);

fw_priv->fw_id will be freed in the release function, so you don't need
to free it here.

>  		put_device(f_dev);
> -		goto error_kfree_fw_id;
> +		return retval;
>  	}
>  	*dev_p = f_dev;
>  	return 0;
> 
> -error_kfree_fw_id:
> -	kfree(fw_priv->fw_id);
>  error_kfree:
>  	kfree(f_dev);
>  	kfree(fw_priv);
> 
> 
