Return-Path: <linux-kernel-owner+w=401wt.eu-S1945952AbXC3M3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952AbXC3M3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 08:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945968AbXC3M3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 08:29:45 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55458 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbXC3M3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 08:29:44 -0400
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com,
       dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com,
       rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
In-Reply-To: <460CDBA6.5030608@gmail.com>
References: <460CDBA6.5030608@gmail.com>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 08:29:10 -0400
Message-Id: <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 18:43 +0900, Tejun Heo wrote:
> Orphaning sysfs nodes on unregistration is a big step in this
> direction.  With sysfs reference counting out of the picture,
> implementing 'disconnect immediate' interface only on a few components
> (including request_queue) should suffice for most block device
> drivers.  I'm not familiar with other drivers but I don't think
> they'll be very different.

I agree with this statement.  The big question in my mind is how do we
do it?

The essential problem, and the reason why the lifetime rules are
entangled is that fundamentally, sysfs entries are managed by kobjects.
The things the device drivers are interested in is struct device, which
is usually embedded in driver data structures.  Unfortunately, the
required kobject is usually embedded in struct device meaning that the
relevant driver structure cannot be freed while the sysfs entry still
exists.

It seems to me that the only way to Orphan the sysfs entries is to
separate the kobject and the struct device so their lifetime rules are
no longer entangled.  Then we can free the driver structure with the
embedded struct device while still keeping the necessary kobject around
to perform orphaned sysfs operations.

So it seems to me that what we need to do is to give struct device its
own kref and a pointer to a kobject.  Then we can manage the separate
lifetimes independently.  The device would basically allocate and take a
reference to the kobject on device_add() and relinquish it again (and
null out the kobject pointer) on device_del().  The complexity here is
that we now have to allocate the kobject somewhere else ... probably in
device_add() (it doesn't come for free with the device structures).

James


