Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXJJBjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXJJBjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXJJBjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:39:47 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:10591 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXJJBjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VctHnRwfiBamcwex3DR2zxLV6bbYaFv5JudfedSg627p8azkXBqTg6/P6Az+W5Pvb4qR5DWFMHThDMFh2i19n66V2CVw2X2WY/JcL5v9hS9EiplX1GEJS+3nRyuh1gccvfQCI+mi4Xt6nueKWUHaQ8meqwphddMAld3/RhbWOJc=
Message-ID: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
Date: Wed, 10 Oct 2007 09:39:44 +0800
From: wit <is01kzh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: about probing a device
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found these routines in the kernel, does this means only one driver
can be matched to a device? What if two drivers both can drive the
device, like sd & sg in scsi subsystem?

static int device_attach(struct device * dev)
{
 	struct bus_type * bus = dev->bus;
	struct list_head * entry;
	int error;

	if (dev->driver) {
		device_bind_driver(dev);
		return 1;
	}

	if (bus->match) {
		list_for_each(entry, &bus->drivers.list) {
			struct device_driver * drv = to_drv(entry);
			error = bus_match(dev, drv);
			if (!error)
				/* success, driver matched */
				return 1;
			if (error != -ENODEV && error != -ENXIO)
				/* driver matched but the probe failed */
				printk(KERN_WARNING
				    "%s: probe of %s failed with error %d\n",
				    drv->name, dev->bus_id, error);
		}
	}

	return 0;
}

void driver_attach(struct device_driver * drv)
{
	struct bus_type * bus = drv->bus;
	struct list_head * entry;
	int error;

	if (!bus->match)
		return;

	list_for_each(entry, &bus->devices.list) {
		struct device * dev = container_of(entry, struct device, bus_list);
		if (!dev->driver) {
			error = bus_match(dev, drv);
			if (error && (error != -ENODEV))
				/* driver matched but the probe failed */
				printk(KERN_WARNING
				    "%s: probe of %s failed with error %d\n",
				    drv->name, dev->bus_id, error);
		}
	}
}

Thanks
