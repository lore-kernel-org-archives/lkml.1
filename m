Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYA3Kd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYA3Kd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759759AbYA3KdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:33:04 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:21365 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389AbYA3KdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:33:01 -0500
Date: Wed, 30 Jan 2008 11:32:57 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core : get_device before create/remove sysfs
 files
Message-ID: <20080130113257.53555fee@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080130015625.GA3058@darkstar.te-china.tietoenator.com>
References: <20080130015625.GA3058@darkstar.te-china.tietoenator.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 09:56:25 +0800,
Dave Young <hidave.darkstar@gmail.com> wrote:

> get dev reference before create/remove sysfiles, errno fixes as well.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> drivers/base/core.c |   12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff -upr a/drivers/base/core.c b/drivers/base/core.c
> --- a/drivers/base/core.c	2008-01-30 09:49:56.000000000 +0800
> +++ b/drivers/base/core.c	2008-01-30 09:49:56.000000000 +0800
> @@ -414,7 +414,7 @@ struct kset *devices_kset;
>   */
>  int device_create_file(struct device *dev, struct device_attribute *attr)
>  {
> -	int error = 0;
> +	int error = -ENODEV;

Uhm... why?

>  	if (get_device(dev)) {
>  		error = sysfs_create_file(&dev->kobj, &attr->attr);
>  		put_device(dev);
> @@ -442,9 +442,11 @@ void device_remove_file(struct device *d
>   */
>  int device_create_bin_file(struct device *dev, struct bin_attribute *attr)
>  {
> -	int error = -EINVAL;
> -	if (dev)
> +	int error = -ENODEV;
> +	if (get_device(dev)) {
>  		error = sysfs_create_bin_file(&dev->kobj, attr);
> +		put_device(dev);
> +	}

Why do we need to grab a reference here? If the calling site doesn't
hold unto a reference already, something is seriously broken.

>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(device_create_bin_file);
> @@ -456,8 +458,10 @@ EXPORT_SYMBOL_GPL(device_create_bin_file
>   */
>  void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
>  {
> -	if (dev)
> +	if (get_device(dev)) {
>  		sysfs_remove_bin_file(&dev->kobj, attr);
> +		put_device(dev);
> +	}

Dito.

>  }
>  EXPORT_SYMBOL_GPL(device_remove_bin_file);
