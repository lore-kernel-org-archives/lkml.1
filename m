Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYARDhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYARDhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYARDhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:37:24 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:41258 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471AbYARDhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o3UWaCy4nqo1wG/2dcKDynmH9GPJ5gONa920vJCjBLh2TJ/lg1VutJKb9AFsZYZtui312TLRfmy5FeB1BXPvziDDmZISdLGl1PIRR2KHw7K7k4fRw9XG1A6+rfle7R23NaB5liAf+vDYINECzlOGwfi8nNZMfP6GMw9ch4otWl4=
Message-ID: <a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
Date: Fri, 18 Jan 2008 11:37:21 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
In-Reply-To: <20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	 <20080111230929.GA7052@boogie.lpds.sztaki.hu>
	 <a8e1da0801132305s4f0c3d7asa268382bb6e44777@mail.gmail.com>
	 <20080114135228.6b9a8da2@gondolin.boeblingen.de.ibm.com>
	 <20080115015741.GB2780@darkstar.te-china.tietoenator.com>
	 <20080116010205.GA2970@darkstar.te-china.tietoenator.com>
	 <20080116230646.GB6715@boogie.lpds.sztaki.hu>
	 <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	 <20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	 <20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 7:42 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Thu, 17 Jan 2008 16:15:04 +0800,
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
> > On Thu, Jan 17, 2008 at 03:24:50PM +0800, Dave Young wrote:
> > > On Jan 17, 2008 7:06 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> > > > Hi,
> > > >
> > > > On Wed, Jan 16, 2008 at 09:02:05AM +0800, Dave Young wrote:
> > > >
> > > > > The rfcomm tty device will possibly retain even when conn is down,
> > > > > and sysfs doesn't support zombie device moving, so this patch
> > > > > move the tty device before conn device is destroyed.
> > > > >
> > > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > >
> > > > This seems to work, both the oops and the hang are gone. I get these
> > > > messages in syslog when the Bluetooth link hangs and I want to kill pppd
> > > > with "poff":
> > > >
> > > > Jan 16 23:55:59 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
> > > > Jan 16 23:56:09 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
>
> Might be helpful to try with CONFIG_DEBUG_DRIVER=y and
> CONFIG_KOBJECT_DEBUG=y to spot where a reference is not dropped.
>
> > > >
> > > > But a "killall -9 pppd" seems to help and then the re-connect (after the
> > > > phone got power-cycled) works.
> > >
> > > Weird, I guess "device_move(dev, NULL) two times" cause the problem.
> > >
> > > Anyway, device_move should check the old_parent and new_parent , if
> > > they equal to each other then just return.
>
> sysfs_move_dir() does this (to avoid a loop later in the function).
> Don't know if that's a good thing to check at a higher level as well,
> because the calling code should really know where their devices are.
>
> Anyway, if this "move in place" exposes a refcounting bug, we must fix
> it.

Lets see the device_move function, seems there's some problems in it:

1302 int device_move(struct device *dev, struct device *new_parent)
1303 {
1304         int error;
1305         struct device *old_parent;
1306         struct kobject *new_parent_kobj;
1307
1308         dev = get_device(dev);
1309         if (!dev)
1310                 return -EINVAL;
1311
1312         new_parent = get_device(new_parent);
1313         new_parent_kobj = get_device_parent (dev, new_parent);

Here could get kobject reference

1314         if (IS_ERR(new_parent_kobj)) {
1315                 error = PTR_ERR(new_parent_kobj);
1316                 put_device(new_parent);
1317                 goto out;
1318         }
1319         pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
1320                  new_parent ? new_parent->bus_id : "<NULL>");
1321         error = kobject_move(&dev->kobj, new_parent_kobj);
1322         if (error) {
1323                 put_device(new_parent);

imagine new_parent is NULL, then the new_parent_kobj should be put

1324                 goto out;
1325         }
1326         old_parent = dev->parent;
1327         dev->parent = new_parent;
1328         if (old_parent)
1329                 klist_remove(&dev->knode_parent);
1330         if (new_parent)
1331                 klist_add_tail(&dev->knode_parent,
&new_parent->klist_children);
1332         if (!dev->class)
1333                 goto out_put;

Why not put new_parent | new_parent_kobj?

1334         error = device_move_class_links(dev, old_parent, new_parent);
1335         if (error) {
1336                 /* We ignore errors on cleanup since we're hosed
anyway... */
1337                 device_move_class_links(dev, new_parent, old_parent);
1338                 if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
1339                         if (new_parent)
1340                                 klist_remove(&dev->knode_parent);
1341                         if (old_parent)
1342                                 klist_add_tail(&dev->knode_parent,
1343
&old_parent->klist_children);
1344                 }
1345                 put_device(new_parent);

Same doubt as above

1346                 goto out;
1347         }
1348 out_put:
1349         put_device(old_parent);
1350 out:
1351         put_device(dev);
1352         return error;
1353 }

Hope I'm wrong, but if it's indeed bugs, I will send a patch about this.

>
> > >
> > > Am I right?
> >
> > Could you apply this patch as well to test? Thanks.
> >
> > diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
> > --- linux/net/bluetooth/rfcomm/tty.c  2008-01-17 16:09:34.000000000 +0800
> > +++ linux.new/net/bluetooth/rfcomm/tty.c      2008-01-17 16:10:22.000000000 +0800
> > @@ -692,7 +692,8 @@ static void rfcomm_tty_close(struct tty_
> >       BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc, dev->opened);
> >
> >       if (--dev->opened == 0) {
> > -             device_move(dev->tty_dev, NULL);
> > +             if (dev->tty_dev->parent)
> > +                     device_move(dev->tty_dev, NULL);
> >
> >               /* Close DLC and dettach TTY */
> >               rfcomm_dlc_close(dev->dlc, 0);
> >
>
> Avoiding to move devices when there is nothing to be moved nevertheless
> sounds like a good idea :)
>
