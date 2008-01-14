Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYANMOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYANMOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYANMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:13:58 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:33589 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYANMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:13:57 -0500
Date: Mon, 14 Jan 2008 13:13:47 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Message-ID: <20080114131347.6ddd036a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
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

On Sat, 12 Jan 2008 17:47:54 +0800,
Dave Young <hidave.darkstar@gmail.com> wrote:

Minor style suggestion (same for class_find_child):

> +struct device *class_find_device(struct class *class, void *data,
> +				   int (*match)(struct device *, void *))
> +{
> +	struct device *dev;
> +	int error = 1;

How about using inverse logic here (e.g., start with int found = 0)...

> +
> +	if (!class)
> +		return NULL;
> +
> +	down(&class->sem);
> +	list_for_each_entry(dev, &class->devices, node) {
> +		dev = get_device(dev);
> +		if (dev) {
> +			if (match(dev, data)) {
> +				error = 0;

...and set found = 1 here...

> +				break;
> +			} else
> +				put_device(dev);
> +		} else
> +			break;
> +	}
> +	up(&class->sem);
> +
> +	if (error)
> +		return NULL;
> +	return dev;

...and do
	return found ? dev : NULL;
in the end?

Especially since not finding the device is not really an error.

> +}

Otherwise this looks fine to me.
