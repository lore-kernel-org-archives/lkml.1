Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYINMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYINMgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYINMgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:36:43 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:59207 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbYINMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:36:41 -0400
Date: Sun, 14 Sep 2008 14:36:30 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
cc: 7eggert@gmx.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Abdel Benamrouche <draconux@gmail.com>,
       Damien Lallement <dlallement@mandriva.com>,
       "pterjan@mandriva.com" <pterjan@mandriva.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
In-Reply-To: <200809132025.40300.herton@mandriva.com.br>
Message-ID: <Pine.LNX.4.58.0809141223300.16805@be10.lrz>
References: <bblSy-60j-19@gated-at.bofh.it> <bbnhC-7Vd-5@gated-at.bofh.it>
 <E1KeRMh-0001Ay-Uj@be1.7eggert.dyndns.org> <200809132025.40300.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008, Herton Ronaldo Krzesinski wrote:
> On Saturday 13 September 2008 06:24:27 Bodo Eggert wrote:
> > Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> > > +++ b/fs/partitions/check.c
> > > @@ -499,9 +499,9 @@ int rescan_partitions(struct gendisk *disk, struct
> > > block_device *bdev)
> > >  if (!size)
> > >  continue;
> > >  if (from + size > get_capacity(disk)) {
> > > -                     printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> > > +                     printk(KERN_WARNING
> > > +                             " %s: p%d exceeds device capacity"
> >                                 ", trimmed\n",
> > >  disk->disk_name, p);
> > 
> > Add "size = get_capacity(disk) - from" here?
> > (Possibly using a cached value for get_capacity(disk)?)
> 
> Trim was already proposed here before (not accepted):
> http://lkml.org/lkml/2006/10/12/364

Because of - as far as I read - possible special-case-forensic-situations 
and possible meddling-with-the-jumper.

IMO:

a) If you need fancy partition handling, you can do it in userspace.
Copying a few MB to a completely different machine, expecting it to work
correctly while depending on the partition numbering to stay the same is
just stupid, and it won't work if you mount by path, anyway. It won't work 
for extended partitions, too, if they don't start in the copied area, 
because they are a chain of partition tables.

Ordinary users need a correctly-working, non-logspewing ("Access beyond
end of disk") system, including the possibility to correctly create
filesystems or to use md on the disks. Having an IO-error-area at the end
of the partition won't exactly help, but maybe destroy the 
HAL-automounted-using-the-wrong-options* filesystem.

Advanced users like me can set up a system in qemu, transfer it to a 
temporary directory, start the old system into /bin/sh, make some bind 
mounts and start the new system.

I might also copy one disk onto two disks, planning to concatenate the
split partition using dmsetup.

Even more advanced users do forensics. Do they really need us to prevent
partition renumbering, as long as there ia a hex editor to trim the
partitions? Can't they just write a small program to fix these partitions
and run it after dd finished? Or create an intrd doing what they want?
Or wouldn't they be be better of with something like "hda.size=0815"?

(*BTW: Is there any documentation for the pile-of-HAL-DBUS-KDE-and-stuff,
which would allow me to actually configure it, and possibly unmount the
devices without sudo?)


b) If there is a soft-clipped disk, find out the unclipped size (and 
unclip it on finding a large partition, if possible and if the partition 
is not "hidden").

If you need to enter a password, the partial partitions should be
read-only and be switched to read-write after entering the password.
Having a corrupted fs because of entering a wrong password is not a good
start for a day. (Yes, my suggestion to just clip it was not enough.)

If you should ever need to access a partition exceeding the true disk
size, you can always use dmsetup or losetup. And don't write to it until
you've copied all the data you want. And especially dont complain about
resulting corruptions.
