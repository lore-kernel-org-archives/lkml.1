Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXL0FTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXL0FTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 00:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXL0FTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 00:19:34 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:12224 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750801AbXL0FTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 00:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WOHGXCuXL1+Dhurz3hqjvELS6KA8uJEEa0uDc9RqQrI4hV/qtHkoSmZTAxSvP9fuy7dDJahN0x2yMg6q/qSzwLVHJ/HzemODeQrLHf1m/DANEgdEo/1ysTG7aPYJuUgIa920LSUbWCt+6rLZIjdU7WuIgZUO4aicoYRe2SOiXQc=
Message-ID: <a8e1da0712262119n9743337o7dbe599080b52748@mail.gmail.com>
Date: Thu, 27 Dec 2007 13:19:32 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: [BUG][PATCH -mm] bluetooth : rfcomm add get/put device in del_conn
Cc: greg@kroah.com, marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <20071226031300.GA3007@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071225100321.GA2791@darkstar.te-china.tietoenator.com>
	 <a8e1da0712250207q2da4ce9bwc6ee70dfff240f9f@mail.gmail.com>
	 <20071226031300.GA3007@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 26, 2007 11:13 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Tue, Dec 25, 2007 at 06:07:24PM +0800, Dave Young wrote:
> > On Dec 25, 2007 6:03 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > > Due to 2.6.24-rc6-mm1 kernel changes (maybe kobject or driver core), If I exec:
> > >
> > > rfcomm connect 0 1
> > >
> > > kernel will oops after connect timeout.
> > >
> > > hand copy some oops text:
> > >
> > > EIP is at driver_sysfs_remove+0x1a/0x40
> > > Call Trace:
> > >  show_trace_log_lvl+0x1a/0x30
> > >  show_stack_log_lvl+0x9a/0xc0
> > >  show_registers+0xc7/0x270
> > >  die+0x129/0x240
> > >  do_page_fault+0x3a1/0x670
> > >  error_code+0x72/0x78
> > >  __device_release_driver+0x1e/0xa0
> > >  device_release_driver+0x30/0x50
> > >  bus_remove_device+0x63/0x90
> > >  device_del+0x55/0x190
> > >  del_conn+0xb/0x10 [bluetooth]
> > >  run_workqueue+0xe1/0x210
> > >  worker_thread+0x99/0xf0
> > >  kthread+0x5c/0xa0
> > >  kernel_thread_helper+0x7/0x18
> > >
> > > (The remote bluetooth device is a mobile phone which is power off)
> > >
> > > The reason is that in bus_remobe_dev, the klist_del function will release the device, so just add a get/put pair around the device_del in del_conn.
> > >
> > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > >
> > > ---
> > > net/bluetooth/hci_sysfs.c |    2 ++
> > > 1 file changed, 2 insertions(+)
> > >
> > > diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
> > > --- linux/net/bluetooth/hci_sysfs.c     2007-12-25 17:45:09.000000000 +0800
> > > +++ linux.new/net/bluetooth/hci_sysfs.c 2007-12-25 17:45:51.000000000 +0800
> > > @@ -319,7 +319,9 @@ void hci_conn_add_sysfs(struct hci_conn
> > >  static void del_conn(struct work_struct *work)
> > >  {
> > >         struct hci_conn *conn = container_of(work, struct hci_conn, work);
> > > +       get_device(&conn->dev);
> > >         device_del(&conn->dev);
> > > +       put_device(&conn->dev);
> > >  }
> > >
> > >  void hci_conn_del_sysfs(struct hci_conn *conn)
> > >
> >
> > Hi greg,
> >
> > BTW, Is it a possible bug of driver core or kobject ?
> >
>
> In device_del
>
> if(parent)
>     klist_del()  will drop the kref of device
>
> and then in bus_remove_device
>     klist_del()  will drop it again, so the device would be released.
>
> then the following works will oops.
>
> So might my patch is a wrong fix. how about the below one:
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
> drivers/base/core.c |    2 ++
> 1 file changed, 2 insertions(+)
>
> diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
> --- linux/drivers/base/core.c   2007-12-26 11:00:49.000000000 +0800
> +++ linux.new/drivers/base/core.c       2007-12-26 11:01:18.000000000 +0800
> @@ -926,6 +926,7 @@ void device_del(struct device * dev)
>         struct device * parent = dev->parent;
>         struct class_interface *class_intf;
>
> +       dev = get_device(dev);
>         if (parent)
>                 klist_del(&dev->knode_parent);
>         if (MAJOR(dev->devt))
> @@ -966,6 +967,7 @@ void device_del(struct device * dev)
>         cleanup_device_parent(dev);
>         kobject_del(&dev->kobj);
>         put_device(parent);
> +       put_device(dev);
>  }
>
>  /**
>

Hi all,
The patches in this thread of me are wrong fixes, I'm sorry for this.

I've found the real problem(BUG), it's in bluetooth connection code,
because of workqueue delay, the device could be put before the
device_del called.

I will submit a new patch in a while.

Regards
dave
