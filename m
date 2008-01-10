Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYAJNY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYAJNY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYAJNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:24:20 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:24638 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYAJNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:24:19 -0500
Date: Thu, 10 Jan 2008 14:23:41 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080110142341.71af4dc5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
References: <478227D5.8050402@s5r6.in-berlin.de>
	<20080107154404.GA10880@suse.de>
	<47825DC1.3090102@s5r6.in-berlin.de>
	<20080107172009.GA25943@suse.de>
	<a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	<a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	<20080110094843.GA3014@darkstar.te-china.tietoenator.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 17:48:43 +0800,
Dave Young <hidave.darkstar@gmail.com> wrote:

Please add a kerneldoc comment for each of the new interfaces.

> +int class_for_each_device(struct class *class, void *data,
> +			   int (*fn)(struct device *, void *))
> +{
> +	struct device *dev;
> +	int error = 0;
> +
> +	if (!class)
> +		return -EINVAL;
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->devices, node) {
> +		error = fn(dev, data);

Hm, the equivalent _for_each_device() functions all elevate the
device's refcount while calling fn(). I wonder whether we want this
here as well?

> +		if (error)
> +			break;
> +	}
> +	mutex_unlock(&class->mutex);
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(class_for_each_device);
> +
> +struct device *class_find_device(struct class *class, void *data,
> +				   int (*match)(struct device *, void *))
> +{
> +	struct device *dev;
> +
> +	if (!class)
> +		return NULL;
> +
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->devices, node)
> +		if (match(dev, data) && get_device(dev))

First get the reference and then drop it if the match function returns
0 to make this analogous to the other _find_device() functions?

> +			break;
> +	mutex_unlock(&class->mutex);
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(class_find_device);
> +
> +int class_for_each_child(struct class *class, void *data,
> +			   int (*fn)(struct class_device *, void *))

Haven't looked at the callers, but isn't it better to convert them to
use struct device instead so we don't need to introduce new
class_device api?

> +{
> +	struct class_device *dev;
> +	int error = 0;
> +
> +	if (!class)
> +		return -EINVAL;
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->children, node) {
> +		error = fn(dev, data);

Same comment as above concerning reference counts.

> +		if (error)
> +			break;
> +	}
> +	mutex_unlock(&class->mutex);
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(class_for_each_child);
> +
> +struct class_device *class_find_child(struct class *class, void *data,
> +				   int (*match)(struct class_device *, void *))
> +{
> +	struct class_device *dev;
> +
> +	if (!class)
> +		return NULL;
> +
> +	mutex_lock(&class->mutex);
> +	list_for_each_entry(dev, &class->children, node)
> +		if (match(dev, data) && class_device_get(dev))

And here.

> +			break;
> +	mutex_unlock(&class->mutex);
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(class_find_child);
> +
