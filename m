Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXISTf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXISTf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXISTfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:35:51 -0400
Received: from hera.cwi.nl ([192.16.191.8]:60176 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXISTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:35:51 -0400
Date: Wed, 19 Sep 2007 21:37:47 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Karel Zak <kzak@redhat.com>, jack@suse.cz
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: iso9660 vs udf
Message-ID: <20070919193747.GA22881@mette>
References: <20070915214926.GA31416@mette> <20070919132327.GF2782@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919132327.GF2782@petra.dvoda.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 03:23:27PM +0200, Karel Zak wrote:
> On Sat, Sep 15, 2007 at 11:49:31PM +0200, Andries E. Brouwer wrote:
> > What goes wrong on the mount side is that when it hesitates between
> > iso9660 and udf it decides for udf when seeing "NSR02".
> > Maybe the heuristics in mount should be tuned.
> 
> Also try:
>      # blkid -c /dev/null /dev/cdrom

# blkid -c /dev/null /dev/hdc
/dev/hdc: TYPE="udf" 

>      # /lib/udev/vol_id  /dev/cdrom

# /sbin/vol_id /dev/hdc
ID_FS_USAGE=filesystem
ID_FS_TYPE=udf
ID_FS_VERSION=
ID_FS_UUID=
ID_FS_LABEL=Wisk1956-82
ID_FS_LABEL_SAFE=Wisk1956-82

>  Maybe vol_id provides better information -- the udf/iso code in
>  libblkid seems poorer that in libvolume_id.

I think the blkid code started out as a copy of the code in mount(8),
but since then they may have developed independently.

Anyway, mount, blkid, vol_id all think that they see udf.
But the kernel cannot handle this type of udf.

>  I'd like to see the CD image (or at least first 2Mb).

Ha, I hoped that someone would say that.
(But do you still want it if I say that it is mostly
a kernel problem?)

By the way, unfortunately a CD image does not work quite the same
as the real thing.

In udf/lowlevel.c you can read

	unsigned int
	udf_get_last_session(struct super_block *sb) {
		...
		i = ioctl_by_bdev(bdev, CDROMMULTISESSION, ...

and this ioctl will succeed on a CDROM, but fail on a loop device. Ach.

Now what goes wrong? In udf/inode.c/udf_current_aext there is support
for allocation types ICBTAG_FLAG_AD_SHORT (0) and ICBTAG_FLAG_AD_LONG (1)
and for no other types. However, ECMA 167 writes (in 14.6.8):

	0-2 Shall be interpreted as a 3-bit unsigned binary number as follows.
	The value 0 shall mean that Short Allocation Descriptors are used.
	The value 1 shall mean that Long Allocation Descriptors are used.
	The value 2 shall mean that Extended Allocation Descriptors are used.
	The value 3 shall mean that the file shall be treated as though
	it had exactly one allocation descriptor describing an extent
	which starts with the first byte of the Allocation Descriptors field
	and has a length, in bytes, recorded in the Length of Allocation
	Descriptors field.
	The values of 4-7 are reserved for future standardisation.

and this particular CD-ROM uses type 3.
So, I guess udf_current_aext() must be updated a bit.

Andries

[will send you a bzip2'd copy of the start of the CD-ROM separately]

>  Karel Zak  <kzak@redhat.com>

