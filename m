Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXC3NPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXC3NPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXC3NPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:15:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:2558 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXC3NPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e5jiOlkR1EEd9Ppw440SunyQuVxAsZJlELtfEu+LoOjZRQ8AIsh87MW5/fa+3d4M/rycHX/K+C7DM3eN8HcK2AwqZMHGtrhd7D/kf/Ss7aPuOks4S7SjGOaNz3Uxxm3CqPdwkiqEAQIGy/jXyuGRkLTpfdb14H7jMgc9tgJMUUA=
Message-ID: <d120d5000703300615y7b367d82hb42f1c58ca8a6328@mail.gmail.com>
Date: Fri, 30 Mar 2007 09:15:50 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Cc: "Tejun Heo" <htejun@gmail.com>, gregkh@suse.de, hugh@veritas.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, maneesh@in.ibm.com,
       rpurdie@rpsys.net, "Jeff Garzik" <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "SCSI Mailing List" <linux-scsi@vger.kernel.org>
In-Reply-To: <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460CDBA6.5030608@gmail.com>
	 <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 3/30/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Fri, 2007-03-30 at 18:43 +0900, Tejun Heo wrote:
> > Orphaning sysfs nodes on unregistration is a big step in this
> > direction.  With sysfs reference counting out of the picture,
> > implementing 'disconnect immediate' interface only on a few components
> > (including request_queue) should suffice for most block device
> > drivers.  I'm not familiar with other drivers but I don't think
> > they'll be very different.
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
>

If you want to manage lifetime rules independently you might want to
not embed struct device into you subsystems objects but attach them
via pointers and use device_create(). Now that we orphan sysfs access
upon unregistering device this will severe all ties from driver core
to your system once you start teardown of a device and you should be
in clear.

However there are simpler subsystems (input, serio, etc.) where there
is only one core module which provides services to device drivers and
handles registration and deregistration. For such substustems it makes
sense to embed struct devices and manage lifetime for all components
at once.

-- 
Dmitry
