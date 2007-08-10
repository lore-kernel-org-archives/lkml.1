Return-Path: <linux-kernel-owner+w=401wt.eu-S936606AbXHJMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606AbXHJMJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbXHJMJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:09:00 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:46818 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbXHJMI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:08:59 -0400
Date: Fri, 10 Aug 2007 14:09:36 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, devel@openvz.org
Subject: Re: [PATCH] Fix OOPS in show_uevent()
Message-ID: <20070810140936.55f297b5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46BC3A57.5070404@openvz.org>
References: <46BC3A57.5070404@openvz.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:13:43 +0400,
Pavel Emelyanov <xemul@openvz.org> wrote:

> The last hunk in this patch fixes this.

Looks sane.

> The other problem is that the envp passed to bus, type and platform callbacks
> from dev_uevent() is the same, so the callbacks can overwrite the info, written
> by the others. Did I miss something important?

I don't think so. 

> 
> This is for 2.6.23-rc2-mm1
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> --- ./drivers/base/core.c.ubug	2007-08-10 14:07:26.000000000 +0400
> +++ ./drivers/base/core.c	2007-08-10 14:07:15.000000000 +0400
> @@ -222,6 +222,11 @@ static int dev_uevent(struct kset *kset,
>  		if (retval)
>  			pr_debug ("%s: bus uevent() returned %d\n",
>  				  __FUNCTION__, retval);
> +
> +		while (*envp != NULL) {
> +			envp++;
> +			num_envp--;
> +		}

Hm, we may also want to adjust the remaining buffer size here, but only
the ->uevent() method has that knowledge...

>  	}
> 
>  	if (dev->class && dev->class->dev_uevent) {
> @@ -230,6 +235,11 @@ static int dev_uevent(struct kset *kset,
>  		if (retval)
>  			pr_debug("%s: class uevent() returned %d\n",
>  				 __FUNCTION__, retval);
> +
> +		while (*envp != NULL) {
> +			envp++;
> +			num_envp--;
> +		}
>  	}
> 
>  	if (dev->type && dev->type->uevent) {
> @@ -238,6 +248,11 @@ static int dev_uevent(struct kset *kset,
>  		if (retval)
>  			pr_debug("%s: dev_type uevent() returned %d\n",
>  				 __FUNCTION__, retval);
> +
> +		while (*envp != NULL) {
> +			envp++;
> +			num_envp--;
> +		}
>  	}
> 
>  	return retval;
> --- ./drivers/base/platform.c.ubug	2007-08-10 14:07:44.000000000 +0400
> +++ ./drivers/base/platform.c	2007-08-10 13:58:55.000000000 +0400
> @@ -547,6 +547,7 @@ static int platform_uevent(struct device
> 
>  	envp[0] = buffer;
>  	snprintf(buffer, buffer_size, "MODALIAS=%s", pdev->name);
> +	envp[1] = NULL;
>  	return 0;
>  }
> 
