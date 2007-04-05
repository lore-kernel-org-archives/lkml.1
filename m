Return-Path: <linux-kernel-owner+w=401wt.eu-S1161001AbXDEDJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbXDEDJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXDEDJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:09:20 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:4519 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161001AbXDEDJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:09:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADgEFEZKhRO4UGdsb2JhbACPeAEBGyM
From: Dmitry Torokhov <dtor@insightbb.com>
To: Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Wed, 4 Apr 2007 23:09:18 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz> <46145026.3050305@gmail.com>
In-Reply-To: <46145026.3050305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704042309.19344.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 21:25, Li Yu wrote:
> Jiri Kosina wrote:
> > BTW as soon as you have some presentable code, could you please send
> > it so
> > that we could see what aproach you have taken? Debating over code is 
> > usualy more efficient than just ranting random ideas :)
> >
> >   
> There is a "presentable patch" in the attachment ;)

Some random notes without reading it all carefully...

> +static int hid_bus_match(struct device *dev, struct device_driver
> *drv) +{
> +	struct hid_driver *hid_drv;
> +	struct hid_device *hid_dev;
> +
> +	hid_drv = to_hid_driver(drv);
> +	hid_dev = to_hid_device(dev);
> +
> +	if (is_hid_driver_sticky(hid_drv))
> +		/* the sticky driver match device do not pass here. */
> +		return 0;
> +	if (hid_dev->bus != hid_drv->bus)
> +		return 0;

How can this happen?

> +	if (!hid_drv->match || hid_drv->match(hid_drv, hid_dev)) {
> +		hid_dev->driver = hid_drv;

This usually done in bus->probe() function, when we know for sure that
driver binds to to the device.

> +static void hid_bus_release(struct device *dev)
> +{
> +}
> +
> +struct device hid_bus = {
> +	.bus_id   = "hidbus0",
> +	.release  = hid_bus_release
> +};
> +
> +static void hid_dev_release(struct device *dev)
> +{
> +}
> +

That will for sure raise Greg KH's blood pressure ;)

> +	for (i=0; hid_dev->attrs && hid_dev->attrs[i]; ++i) {
> +		ret = device_create_file(&hid_dev->device, hid_dev->attrs[i]);
> +		if (ret)
> +			break;
> +

That should be handled via bus's device attributes and not open coded...

> - *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
> - *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
> + *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@@suse.cz>
> + *  Copyright (c) 2005 Michael Haboustak <mike-@@cinci.rr.com> for Concept2, Inc
>   *  Copyright (c) 2006 Jiri  Kosina

Any particular reason for mangling addresses?

> +	if (interrupt)
> +		local_irq_save(flags);
> +	spin_lock(&hid_lock);
> +	list_for_each_entry(driver, &hid_sticky_drivers, sticky_link) {
> +		hook = driver->hook;
> +		if (hook && hook->raw_event) {
> +			ret = hook->raw_event(hid, type, data, size, interrupt);
> +			if (!ret)
> +				break;
> +		}
> +	}
> +	spin_unlock(&hid_lock);
> +	if (interrupt)
> +		local_irq_restore(flags);
> +

This is scary. spin_lock_irqsave() and be done with it.

> +int hid_open(struct hid_device *hid)
> +{
> +	struct hid_transport *tl;
> +	int ret;
> +
> +	if (hid->driver->open)
> +		return hid->driver->open(hid);
> +	ret = 0;
> +	spin_lock(&hid_lock);
> +	tl =  hid_transports[hid->bus];
> +	if (tl->open)
> +		ret = tl->open(hid);
> +	spin_unlock(&hid_lock);
> +	return ret;
> +}

Spinlock is not the best choise here, I'd expect most ->open()
implementation wait on some IO.

-- 
Dmitry
