Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZEZVRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZEZVRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZEZVQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:16:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbZEZVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:16:56 -0400
Date: Tue, 26 May 2009 14:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] devres: WARN() and return, don't crash on device_del()
 of uninitialized device
Message-Id: <20090526141552.507f8821.akpm@linux-foundation.org>
In-Reply-To: <20090525065346.1D991DE2AC@ozlabs.org>
References: <20090525065346.1D991DE2AC@ozlabs.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 16:53:31 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> I just debugged an obscure crash caused by a device_del() of a all NULL'd
> out struct device (in usb-serial) and found that a patch like this one would
> have saved me time (in addition to improved chances of a bug report from
> users hitting similar driver bugs).
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
>  drivers/base/devres.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-work.orig/drivers/base/devres.c	2009-05-25 16:43:46.000000000 +1000
> +++ linux-work/drivers/base/devres.c	2009-05-25 16:46:36.000000000 +1000
> @@ -428,6 +428,11 @@ int devres_release_all(struct device *de
>  {
>  	unsigned long flags;
>  
> +	/* Looks like an uninitialized device structure */
> +	if (dev->devres_head.next == NULL) {
> +		WARN(1);
> +		return -ENODEV;
> +	}
>  	spin_lock_irqsave(&dev->devres_lock, flags);
>  	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
>  			     flags);

This could be coded a little more neatly as:

	/* Looks like an uninitialized device structure */
	if (WARN_ON(dev->devres_head.next == NULL))
		return -ENODEV;

