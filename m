Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbYCZLbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbYCZLbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYCZLbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:31:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYCZLbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:31:09 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
To: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 26 Mar 2008 12:30:40 +0100
References: <abhxL-xC-7@gated-at.bofh.it> <abhRd-1bf-15@gated-at.bofh.it> <ablib-2zv-65@gated-at.bofh.it> <abn0B-735-35@gated-at.bofh.it> <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/z6mBqSl212RABaQsTxwdiJCJxN5wO3SdpjSS
 KODiBG0a1TnlFrklY2BPNm9jgpikndpFSUQiGx9aKV7ZA4lRPc
 TZYH4arueQV3OAnQYOKng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:
> On Tue, Mar 25, 2008 at 04:05:32PM -0700, H. Peter Anvin wrote:

>>> How does this have anything to do with boot times?  Do you really have a
>>> foolish shell script that iteratorates over every single disk in the
>>> sysfs tree for every disk?  What does it do that for?
>>
>> Any time you want to get the sysfs information for a filesystem which is
>> already mounted, that's what you're forced to do.
>>
>>> I thought we were talking about 2TB disks here, with a proposed new
>>> ioctl, not foolishness of boot scripts...
>>
>> I pointed out that having a way to map device numbers to sysfs directories
>> would have the same effect, *and* would be usable for other purposes.  I'd
>> rather see that than a new ioctl, and another, and another...
> 
> Again, a simple udev rule will give you that today if you really want
> it...

So e.g. lilo should depend on sysfs and *a*special*configuration* of udev,
while the admin MUST NOT use mknod'ed device files nor manually create
symlinks pointing to them, and not use relative path names?
That's plain stupid.

> And I think 'udevinfo' can be used to retrieve this information as well.

$ udevinfo /dev/hda
missing option
$ udevinfo /dev/hda --help
Usage: udevinfo OPTIONS
  --query=<type>    query database for the specified value:
    name            name of device node
    symlink         pointing to node
    path            sysfs device path
    env             the device related imported environment
    all             all values

  --path=<devpath>  sysfs device path used for query or chain
  --name=<name>     node or symlink name used for query

  --root            prepend to query result or print udev_root
  --attribute-walk  print all SYSFS_attributes along the device chain
  --export-db       export the content of the udev database
  --help            print this text
$ udevinfo --name=/dev/hda
missing option
$ udevinfo --name=/dev/hda --query=all
P: /block/hda
N: hda
S: disk/by-id/ata-Maxtor_2F040L0_F1748ZQE
S: disk/by-path/pci-0000:00:0f.0-ide-0:0
E: DEVTYPE=disk
E: ID_TYPE=disk
E: ID_MODEL=Maxtor_2F040L0
E: ID_SERIAL=F1748ZQE
E: ID_REVISION=VAM51JJ0
E: ID_BUS=ata
E: ID_PATH=pci-0000:00:0f.0-ide-0:0


As you can see, it gives no major:minor information. But it is in the DB:

$ cd /dev/.udev/db
$ grep -l hda * 2>/dev/null
\x2fblock\x2fhda
\x2fblock\x2fhda\x2fhda1
$ cat "\x2fblock\x2fhda"
N:hda
S:disk/by-id/ata-Maxtor_2F040L0_F1748ZQE
S:disk/by-path/pci-0000:00:0f.0-ide-0:0
M:3:0
E:DEVTYPE=disk
E:ID_TYPE=disk
E:ID_MODEL=Maxtor_2F040L0
E:ID_SERIAL=F1748ZQE
E:ID_REVISION=VAM51JJ0
E:ID_BUS=ata
E:ID_PATH=pci-0000:00:0f.0-ide-0:0

What a great tool - for making linux look bad.


