Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbYHEVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbYHEVES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbYHEVED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:04:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758766AbYHEVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:04:00 -0400
Date: Tue, 5 Aug 2008 14:03:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] firmware: avoiding multiple replication for same
 firmware file
Message-Id: <20080805140327.16494fb0.akpm@linux-foundation.org>
In-Reply-To: <1217570459.2902.1.camel@jaswinder.satnam>
References: <1217570459.2902.1.camel@jaswinder.satnam>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008 11:30:59 +0530
Jaswinder Singh <jaswinder@infradead.org> wrote:

> Now when request_firmware will be called it will check whether firmware
> is already allocated or not. If already allocated then it provide handle
> of old firmware handle and increase count of firmware.
> 
> release_firmware will decrease count of firmware, if count is one only then
> firmware will be release.
> 
> Added release_firmware_all() can be called from driver cleanup or exit
> to release firmware forcefully.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  drivers/base/firmware_class.c |  112 ++++++++++++++++++++++++++++++++++++-----
>  include/linux/firmware.h      |    5 ++
>  2 files changed, 104 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index b0be1d1..9743a3d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -49,6 +49,15 @@ struct firmware_priv {
>  	struct timer_list timeout;
>  };
>  
> +struct firmware_list {
> +	const struct firmware *fw;
> +	char *name;
> +	int count;
> +	struct list_head list;
> +};

OK, that's a per-item data structure.

> +static struct firmware_list firmwarelist;

No, we shouldn't declare an entire static `struct firmware_list' just
for storage of all the dynamically allocated ones. Instead simply do:

static LIST_HEAD(firmwarelist);

and use that.

Please also add a comment indicating which lock protects that global
list.  If it is indeed protected.  If not, fix it.  If no fix is
needed, add a comment explaining why this list doesn't need locking.

>  #ifdef CONFIG_FW_LOADER
>  extern struct builtin_fw __start_builtin_fw[];
>  extern struct builtin_fw __end_builtin_fw[];
> @@ -400,11 +409,21 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  	struct firmware_priv *fw_priv;
>  	struct firmware *firmware;
>  	struct builtin_fw *builtin;
> +	struct firmware_list *tmp;
>  	int retval;
>  
>  	if (!firmware_p)
>  		return -EINVAL;
>  
> +	/* Return firmware pointer from firmware list if already allocated */
> +	list_for_each_entry(tmp, &firmwarelist.list, list) {

And this becomes

	list_for_each_entry(tmp, &firmwarelist, list)

> +		if (strcmp(name, tmp->name) == 0) {
> +			tmp->count++;
> +			*firmware_p = tmp->fw;
> +			break;
> +		}
> +	}
> +
>  	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
>  	if (!firmware) {
>  		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",

I don't think that existing printk was needed - the page allocator (or
the oom-killer) will dump information for us in the unlikely event that
this allocation failed.

> @@ -413,6 +432,27 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  		goto out;
>  	}
>  
> +	tmp = kzalloc(sizeof(struct firmware_list), GFP_KERNEL);
> +	if (!tmp) {
> +		printk(KERN_ERR "%s: kmalloc(struct firmware_list) failed\n",
> +		       __func__);

So the newly-added ones don't have much value.

> +		retval = -ENOMEM;
> +		goto error_kfree_fw;
> +	}
> +
> +	tmp->name = kzalloc(strlen(name), GFP_KERNEL);

Could have been kmalloc(), but see below.

> +	if (!tmp->name) {
> +		printk(KERN_ERR "%s: kmalloc firmware_list->name failed\n",
> +		       __func__);

Unneeeded printk.

> +		retval = -ENOMEM;
> +		goto error_kfree_fw_list;
> +	}
> +
> +	tmp->fw = *firmware_p;
> +	tmp->count = 1;
> +	strcpy(tmp->name, name);

Please replace the kmalloc+strcpy with a call to kstrdup().

> +	list_add(&(tmp->list), &(firmwarelist.list));

That is excessively parenthesised.

There is no locking for that list.

>  	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
>  	     builtin++) {
>  		if (strcmp(name, builtin->name))
> @@ -429,7 +469,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  
>  	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
>  	if (retval)
> -		goto error_kfree_fw;
> +		goto error_kfree_fw_name;
>  
>  	fw_priv = dev_get_drvdata(f_dev);
>
> ...
>
> -/**
> +static void __release_firmware(const struct firmware *fw,
> +			       struct firmware_list *tmp)
> +{
> +	struct builtin_fw *builtin;
> +
> +	for (builtin = __start_builtin_fw; builtin != __end_builtin_fw;
> +	     builtin++) {
> +		if (fw->data == builtin->data)
> +			goto free_fw;
> +	}
> +	vfree(fw->data);
> +free_fw:
> +	kfree(fw);
> +	list_del(&tmp->list);

locking.

> +	kfree(tmp->name);
> +	kfree(tmp);
> +}
> +


