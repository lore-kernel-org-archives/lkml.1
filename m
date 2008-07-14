Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYGNCIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYGNCIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYGNCII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:08:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:54801 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYGNCIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=HNqe637vMySqlo1xzPotJ9SOX2SxzIoaSX4coq2Ot0k4okqgGKNcw4jIR0CwAyM5xe
         MkPvkhCsTXnZVSo86zoJxd1CSGESDoGYH1iemhKRRCzte4pkceaeuesyn6HKIyRpq3sw
         vy1LPnoPhI9WiKNFEI7dQ2HoLWPJ/BDx4vnUM=
Message-ID: <30353c3d0807131908l6c700b49xc63ffaeae1369601@mail.gmail.com>
Date: Sun, 13 Jul 2008 22:08:04 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: linux-kernel@vger.kernel.org
Subject: char_dev inquiry
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: d9f779a3974be9fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reviewing several character device drivers over the past few
weeks, I have a few concerns concerning the current state of char_dev.

Currently, cdev has a kobject which is initialized in either cdev_init
or cdev_alloc. The reference count for this kobject is incremented
during chrdev_open, and decremented by cdev_del and __fput(in
file_table.c). When the reference count reaches 0,
cdev_dynamic_release or cdev_default_release is called, depending on
how the kobject was initialized, to free cdev related memory. The
strategic manipulation of the kobject reference count in cdev ensures
that cdev is not freed while fops releases are still pending.

Typically however cdev is embedded within another structure and
initialized using cdev_init. This allows easy access to the containing
structure during fops callbacks via container_of. Freeing the
containing structure however is somewhat problematic. Since cdev
maintains a reference count that determines when it is freed, the
containing structure must not be freed before cdev's kobject release
callback has been called. Currently the only way to ensure this
behavior is to call cdev_del after the final fops release has been
called.

For a moment, lets presume we reference count the containing structure
with a kref. We'll manipulate the kref similar to how cdev manipulates
its kobject. Thus, when cdev_init is called, we call kref_init on our
kref. When we receive an fops open callback we increment our reference
counter, and decrement it when we receive an fops release callback.
Finally, we decrement it after we call cdev_del. Consider the
following usb driver layout:

1) module_init
    a) register_chrdev_region - alloc some minor numbers
    b) register with usb subsystem
2) usb probe
    a) alloc containing structure
    b) initialize internal cdev structure using cdev_init
    c) kref_init internal kref object
    d) cdev_add
3) fops open (take lock)
    a) if disconnected return error
    b) kref_get internal kref object
4) fops close (take lock)
    a) kref_put internal kref object
5) usb disconnect (take lock)
    a) set disconnected flag
    b) cdev_del
    c) kref_put internal kref object
6) module_exit
    a) unregister with usb subsystem
    b) unregister_chrdev_region - free minor numbers
7) release via kref
    a) free containing structure

While the above appears to be right, usb disconnect may occur before
the final call to fops close. In this case, the containing structure
will be freed before the kobject release function of the internal cdev
structure has been called. This will result in a crash.

The only way around this is to delay the call to cdev_del until our
release method is called. Doing so however means we must continue to
process and expect calls to fops open since we are unable to remove
the character device. The resulting layout would be as follow:

1) module_init
    a) register_chrdev_region - alloc some minor numbers
    b) register with usb subsystem
2) usb probe
    a) alloc containing structure
    b) initialize internal cdev structure using cdev_init
    c) kref_init internal kref object
    d) cdev_add
3) fops open (take lock)
    a) if disconnected return error
    b) kref_get internal kref object
4) fops close (take lock)
    a) kref_put internal kref object
5) usb disconnect (take lock)
    a) set disconnected flag
    b) kref_put internal kref object
6) module_exit
    a) unregister with usb subsystem
    b) unregister_chrdev_region - free minor numbers
7) release via kref
    a) cdev_del
    b) free containing structure

A better solution would be to introduce a release callback in the cdev
structure that is called during cdev's kobject release callback. By
doing so we no longer have to maintain a reference count on containing
structure, nor do we have to delay the call to cdev_del until after
the final fops release has occurred in order to remove the character
device. The disconnected flag is still used due to concurrency issues
on SMP and pre-emptable systems, but the number of fops open calls
affected by it should be greatly reduced since the character device is
no longer present. The resulting layout would be as follows:

1) module_init
    a) register_chrdev_region - alloc some minor numbers
    b) register with usb subsystem
2) usb probe
    a) alloc containing structure
    b) initialize internal cdev structure using cdev_init
    c) set cdev release callback
    d) cdev_add
3) fops open (take lock)
    a) if disconnected return error
4) fops close (take lock)
5) usb disconnect (take lock)
    a) set disconnected flag
    b) cdev_del
6) module_exit
    a) unregister with usb subsystem
    b) unregister_chrdev_region - free minor numbers
7) release from cdev
    b) free containing structure

While I have only examined usb and pci character devices, this
information may apply to other subsystems as well.

What are your thoughts about introducing a release callback into cdev?

Regards,

David Ellingsworth
