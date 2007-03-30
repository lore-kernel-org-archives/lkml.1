Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbXC3NiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbXC3NiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXC3NiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:38:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:23520 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXC3NiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eZpq1oHVPRqs0RO7cAww+TR3dSCkAQv1m4CUPr8yHmoQG9H/y73qbViaYPbFExCmBI+hwIvbfcA1nwxddkUnI6OI0aq9HKPJc3TXh0m9DgNqbhhrTMgxPUh0BSaO7fH7JDDGbhNxAZgytR+HPY/Dd7zJ9pXzRGMYzLWqwHWSwvU=
Message-ID: <460D12B8.6050101@gmail.com>
Date: Fri, 30 Mar 2007 22:38:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com,
       dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com,
       rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <460CDBA6.5030608@gmail.com> <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-03-30 at 18:43 +0900, Tejun Heo wrote:
>> Orphaning sysfs nodes on unregistration is a big step in this
>> direction.  With sysfs reference counting out of the picture,
>> implementing 'disconnect immediate' interface only on a few components
>> (including request_queue) should suffice for most block device
>> drivers.  I'm not familiar with other drivers but I don't think
>> they'll be very different.
> 
> I agree with this statement.  The big question in my mind is how do we
> do it?
> 
> The essential problem, and the reason why the lifetime rules are
> entangled is that fundamentally, sysfs entries are managed by kobjects.
> The things the device drivers are interested in is struct device, which
> is usually embedded in driver data structures.  Unfortunately, the
> required kobject is usually embedded in struct device meaning that the
> relevant driver structure cannot be freed while the sysfs entry still
> exists.
> 
> It seems to me that the only way to Orphan the sysfs entries is to
> separate the kobject and the struct device so their lifetime rules are
> no longer entangled.  Then we can free the driver structure with the
> embedded struct device while still keeping the necessary kobject around
> to perform orphaned sysfs operations.
> 
> So it seems to me that what we need to do is to give struct device its
> own kref and a pointer to a kobject.  Then we can manage the separate
> lifetimes independently.  The device would basically allocate and take a
> reference to the kobject on device_add() and relinquish it again (and
> null out the kobject pointer) on device_del().  The complexity here is
> that we now have to allocate the kobject somewhere else ... probably in
> device_add() (it doesn't come for free with the device structures).

My plan was to make sysfs more independent from struct device/kobject.
e.g. Something like the following.

* kobject_get() on attr/symlink creation
* open() doesn't need extra kobject reference
* deleting a node makes it release the kobject reference and the kobject
pointer is nullified.

This way the sysfs reference counting can be put completely out of
picture without impacting the rest of code.  Handling symlink and
suicidal attributes might need some extra attention but I think they can
be done.

In the long term, I think sysfs should be independent from driver model
and kobject such that an entity which wants to use sysfs but is not a
device doesn't have to dance with kobject just to use sysfs.

Thanks.

-- 
tejun
