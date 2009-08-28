Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZH1TKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZH1TKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZH1TKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:10:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZH1TKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:10:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/6] PM: Introduce PM links framework
Date: Fri, 28 Aug 2009 21:11:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908281114520.4116-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908281114520.4116-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908282111.19925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009, Alan Stern wrote:
> On Wed, 26 Aug 2009, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce a framework for representing off-tree PM dependencies
> > between devices.
> > 
> > There are PM dependencies between devices that are not reflected by
> > the structure of the device tree.  In other words, as far as PM is
> > concerned, a device may depend on some other devices which are not
> > its children and none of which is its parent.
> > 
> > Every such dependency involves two devices, one of which is a
> > "master" and the other of which is a "slave", meaning that the
> > "slave" have to be suspended before the "master" and cannot be
> > woken up before it.  Thus every device can be given two lists of
> > "dependency objects", one for the dependencies where the device is
> > the "master" and the other for the dependencies where the device is
> > the "slave".  Then, each "dependency object" can be represented as
> 
> 
> > Index: linux-2.6/drivers/base/power/common.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/base/power/common.c
> 
> > +/**
> > + * device_for_each_master - Execute given function for each master of a device.
> > + * @slave: Device whose masters to execute the function for.
> > + * @data: Data pointer to pass to the function.
> > + * @fn: Function to execute for each master of @slave.
> > + *
> > + * The function is executed for the parent of the device, if there is one, and
> > + * for each device connected to it via a pm_link object where @slave is the
> > + * "slave".
> > + */
> > +int device_for_each_master(struct device *slave, void *data,
> > +			   int (*fn)(struct device *dev, void *data))
> > +{
> > +	struct pm_link *link;
> > +	int idx;
> > +	int error = 0;
> > +
> > +	if (slave->parent) {
> > +		error = fn(slave->parent, data);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	idx = srcu_read_lock(&pm_link_ss);
> > +
> > +	list_for_each_entry(link, &slave->power.slave_links, slave_hook) {
> 
> This needs to use list_for_each_entry_rcu.  Likewise in
> device_for_each_slave().

OK, I wasn't sure about that.

Thanks,
Rafael
