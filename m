Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXJXSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXJXSBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbXJXSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:01:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3252 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754401AbXJXSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:01:08 -0400
Date: Wed, 24 Oct 2007 14:01:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1193138869.2239.12.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710241354560.29002-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Kay Sievers wrote:

> > Yes; I haven't been able to figure out why we get different results.
> > 
> > > There must be something going wrong with the block patch in conjunction
> > > with the crazy SCSI release logic.

I found out why it works on my system -- which still leaves open the 
question of why it fails on yours.

Although the gendisk device is a child of the scsi_device, nevertheless 
disk->kobj is not a child of the scsi_device's embedded kobject.  
Instead it is a child of the static (!) block_depr kobject, which is 
defined in block/genhd.c.  Hence the disk's single reference to the 
scsi_device is indeed dropped when the disk is unregistered, which 
breaks the loop of circular references.

It works this way because I have CONFIG_SYSFS_DEPRECATED set; perhaps
you don't.  If you compare the two versions of get_device_parent() in
drivers/base/core.c you'll see the difference (it's the dev_type ==
&disk_type case).

Alan Stern

