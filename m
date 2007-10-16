Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbXJPNtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbXJPNtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXJPNtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:49:01 -0400
Received: from mail.softservecom.com ([195.160.232.17]:46547 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233AbXJPNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:48:59 -0400
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071015103033.65b47dea.zaitcev@redhat.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071015103033.65b47dea.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1192542533.29039.58.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Tue, 16 Oct 2007 16:48:54 +0300
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2007 13:48:54.0074 (UTC) FILETIME=[4A7971A0:01C80FFB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

On Mon, 2007-10-15 at 20:30, Pete Zaitcev wrote:

> > +	in_end_size = le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize);
> > +	out_end_size = le16_to_cpu(dev->interrupt_out_endpoint->wMaxPacketSize);
> 
> Did you verify if this works? We use pre-swapped descriptors in 2.4.
> I suspect you allocate 256 times more memory than necessary.

Just checked. Seems to be OK. At least printk shows shows it.

> 
> > +static void adu_delete(struct adu_device *dev)
> > +	kfree(dev);
> 
> > +static int adu_release_internal(struct adu_device *dev)
> > +	if (dev->udev == NULL) {
> > +		adu_delete(dev);
> 
> > +static int adu_open(struct inode *inode, struct file *file)
> > +	retval = adu_release_internal(dev);
> > +	up(&dev->sem);
> 
> The above very clearly is a use-after-free, in case the device was
> open across a disconnect. Solution: Use minor_table_mutex to lock
> dev->open_count instead of dev->sem. There's no rule that the lock
> has to live inside the same structure with members it locks.

Yeah. You are right. Found similar issue in adu_release also. 
It's a problem with 2.6 kernel driver.
So, I've got a material to create some fixes in 2.6 driver too.
I've reworked the code to avoid this issue.

Sending final patch as a reply to Willy's mail. Please check it.


Vitaliy

