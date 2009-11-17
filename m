Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZKQVGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZKQVGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZKQVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:06:03 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49191 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZKQVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HJVYM8dIe4eaKTDAo/hEtiVHXuZrHRHbd9uPkkUAajILHkzfEnzlH078DbpU0nlO0+
         9JGzeRAWZrFzHXsfACrfGZIYPjEe+o6jl64Ak6peBloUls9WSeAZg2iL1j6deXIeKWQ6
         qhhG4hiZ5KXWQ2x9BPiAmc0Z9uJrLCgtIEfjE=
MIME-Version: 1.0
Date: Tue, 17 Nov 2009 14:06:07 -0700
Message-ID: <f9d2a5e10911171306r416eaf2k45c3256370e82eda@mail.gmail.com>
Subject: Use of usb_find_interface in open is racy
From: Russ Dill <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many usb drivers that create character devices use "struct
usb_class_driver", a set of fops, and a usb_find_interface in their
open call. A prime example is drivers/usb/usb-skeleton.c. A race
occurs when userspace receives a hotplug event for the addition for
the interface and then opens the associated device file before the
device is added to the driver's klist_devices.

The usb core senses a new usb device (usb_new_device) and calls
device_add. This eventually gets down to really_probe and the
usb-skeleton probe function, skel_probe. skel_probe calls
usb_register_dev() which registers the associated character device for
skel_class. The hotplug events for the class device get emitted.

User space receives the hotplug event for the class device, makes the
device node and notifies another program that opens the device node.
The program opens the device node which calls into usb_open and then
skel_open. skel_open calls usb_find_interface. usb_find_interfaces
searches the klist_devices of skel_driver, finds no device associated
with the minor number and returns NULL. skel_open returns -ENODEV.

Control returns to really_probe and really_probe calls driver_bound
which adds the device to the list of devices associated with
skel_driver (klist_devices).

I'm not sure what the right way to solve this is. A call to
wait_for_device_probe() in the skel_open call before calling
usb_find_interface fixes the problem, but it is a rather large hammer.
