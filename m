Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZGHK3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZGHK3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZGHK3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:29:35 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62359 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZGHK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:29:34 -0400
Date: Wed, 8 Jul 2009 12:28:52 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Free struct device in fw_dev_release()
Message-ID: <20090708122852.1cf1b1f4@gondolin>
In-Reply-To: <20090708101740.27241.64092.stgit@pc1117.cambridge.arm.com>
References: <20090708101740.27241.64092.stgit@pc1117.cambridge.arm.com>
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

On Wed, 08 Jul 2009 11:17:40 +0100,
Catalin Marinas <catalin.marinas@arm.com> wrote:

> The f_dev in _request_firmware() is allocated via the fw_setup_device()
> and fw_register_device() calls and its class set to firmware_class (the
> class release function is fw_dev_release).
> 
> Commit 6acf70f078ca replaced the kfree(dev) in fw_dev_release() with a
> put_device() call but my understanding is that the release function is
> called via put_device -> kobject_put -> kref_put -> koject_release etc.
> and it should call kfree since it's the last to see this device
> structure alive.
> 
> Because of that, the _request_firmware() function on its -ENOENT error
> path only calls device_unregister(f_dev) which would eventually call
> fw_dev_release() but there is no kfree (the subsequent put_device call
> would just make the kref negative).
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

> Acked-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/base/firmware_class.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index ddeb819..fc46653 100644
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
> @@ -408,13 +408,11 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
>  	if (retval) {
>  		dev_err(device, "%s: device_register failed\n", __func__);
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
