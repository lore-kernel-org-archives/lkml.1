Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZBPDTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZBPDTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 22:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZBPDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 22:18:56 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57600 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbZBPDSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 22:18:54 -0500
Date: Mon, 16 Feb 2009 12:15:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
Message-ID: <20090216031523.GA16824@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <1234646219.6609.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234646219.6609.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 09:16:59PM +0000, Adrian McMenamin wrote:
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/buffer_head.h>
> +#include <linux/mtd/mtd.h>
> +#include "vmufat.h"
> +
Why do you have an mtd include?

> +struct dentry *vmufat_inode_lookup(struct inode *in, struct dentry *dent,
> +	struct nameidata *nd)
> +{
[snip]
> +	sb = in->i_sb;
> +	vmudetails = (struct memcard *)sb->s_fs_info;

All of your sb->s_fs_info casts are superfluous. Do not cast void
pointers.

> +			if (!ino || IS_ERR(ino)) {
> +				error = -EACCES;
> +				goto release_bh;
> +			}
In the IS_ERR case, you can use PTR_ERR for setting the error value.
Throughout most of this code you completely ignore the error value that
is handed down and invent your own instead, making debugging far more
painful than it needs to be.

> +		/* do we need to move to the next block in the directory? */
> +		if ((fno / 0x10) > (vmudetails->dir_bnum - blck_read)) {
> +			brelse(bh);
> +			blck_read--;

Was the extra vowel really that much more work to write out?

> +	/* BCD timestamp it */
> +	unix_date = CURRENT_TIME.tv_sec;
> +	day = unix_date / 86400 - 3652;
> +	year = day / 365;
> +
> +	if ((year + 3) / 4 + 365 * year > day)
> +		year--;
> +
> +	day -= (year + 3) / 4 + 365 * year;
> +	if (day == 59 && !(year & 3)) {
> +		nl_day = day;
> +		month = 2;
> +	} else {
> +		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> +		for (month = 0; month < 12; month++)
> +			if (day_n[month] > nl_day)
> +				break;
> +	}
> +
> +	century = 19;
> +	if (year > 19)
> +		century = 20;
> +
> +	bh->b_data[z + 0x10] = bcd_from_u8(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;
> +
> +	bh->b_data[z + 0x11] = bcd_from_u8(u8year);
> +	bh->b_data[z + 0x12] = bcd_from_u8((__u8) month);
> +	bh->b_data[z + 0x13] =
> +	    bcd_from_u8((__u8) day - day_n[month - 1] + 1);
> +	bh->b_data[z + 0x14] =
> +	    bcd_from_u8((__u8) ((unix_date / 3600) % 24));
> +	bh->b_data[z + 0x15] = bcd_from_u8((__u8) ((unix_date / 60) % 60));
> +	bh->b_data[z + 0x16] = bcd_from_u8((__u8) (unix_date % 60));
> +
This should be abstracted out in to a separate function, and you can get
rid of most of this hand-rolled time mangling by using the rtc lib
routines.

Additionally, all of the bcd conversion code is superfluous, since you
can include linux/bcd.h and use bin2bcd and bcd2bin directly.

> +static int vmufat_inode_rename(struct inode *in_source,
> +			      struct dentry *de_source,
> +			      struct inode *in_target,
> +			      struct dentry *de_target)
> +{
> +	return -EPERM;
> +}
> +
Just get rid of this if you aren't going to support it.

> +	saved_file =
> +	    kmalloc(sizeof(struct vmufat_file_info), GFP_KERNEL);
> +
Error handling?

> +	}
> +	/* Now every other block */
> +	else {

Please refrain from adopting magical coding styles.

> +			}
> +
> +		}
> +
> +
> +	}
> +
> +
Lots of superfluous whitespace.

> +	readbuf = kzalloc(count, GFP_KERNEL);
> +	/* Traverse through FAT to read the blocks in */
> +	x = 0;
Again, no error handling.

> +static int vmufat_file_open(struct inode *in, struct file *f)
> +{
> +	return 0;
> +}
> +
You should be able to kill this off, also.

> +__u8 bcd_from_u8(__u8 num)
> +{
> +	__u8 topnib = num / 10;
> +	__u8 botnib = num % 10;
> +	return topnib << 4 | botnib;
> +}
> +
> +inline int int_from_bcd(__u8 bcd)
> +{
> +	int topnib = (bcd >> 4) & 0x000f;
> +	int botnib = bcd & 0x000f;
> +
> +	return (topnib * 10) + botnib;
> +}
> +
As already mentioned, these are already in linux/bcd.h.

> +static void vmufat_put_super(struct super_block *sb)
> +{
> +	struct memcard *vmudetails;
> +	sb->s_dev = 0;
> +	vmudetails = (struct memcard *) (sb->s_fs_info);
> +	kfree(vmudetails);

vmudetails is completely unused here, just kfree sb->s_fs_info.

> +	/* BCD timestamp it */
> +	unix_date = CURRENT_TIME.tv_sec;
> +	day = unix_date / 86400 - 3652;
> +	year = day / 365;
> +	if ((year + 3) / 4 + 365 * year > day)
> +		year--;
> +	day -= (year + 3) / 4 + 365 * year;
> +	if (day == 59 && !(year & 3)) {
> +		nl_day = day;
> +		month = 2;
> +	} else {
> +		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> +		for (month = 0; month < 12; month++)
> +			if (day_n[month] > nl_day)
> +				break;
> +	}
> +
> +	century = 19;
> +	if (year > 19)
> +		century = 20;
> +	bh->b_data[z + 0x10] = bcd_from_u8(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;
> +	bh->b_data[z + 0x11] = bcd_from_u8(u8year);
> +	bh->b_data[z + 0x12] = bcd_from_u8((__u8) month);
> +	bh->b_data[z + 0x13] =
> +	    bcd_from_u8((__u8) day - day_n[month - 1] + 1);
> +	bh->b_data[z + 0x14] =
> +	    bcd_from_u8((__u8) ((unix_date / 3600) % 24));
> +	bh->b_data[z + 0x15] = bcd_from_u8((__u8) ((unix_date / 60) % 60));
> +	bh->b_data[z + 0x16] = bcd_from_u8((__u8) (unix_date % 60));
> +
> +	((__u16 *) bh->b_data)[z / 2 + 0x0C] = cpu_to_le16(in->i_blocks);
> +	if (inode_num != 0)
> +		((__u16 *) bh->b_data)[z / 2 + 0x0D] = 0;
> +	else /* game */
> +		((__u16 *) bh->b_data)[z / 2 + 0x0D] = cpu_to_le16(1);
> +	in->i_mtime.tv_sec = unix_date;

Again, all of this can be simplified using rtc lib and bcd routines.

> +static int check_sb_format(struct buffer_head *bh)
> +{
> +	__u32 s_magic = 0x55555555;
> +
This magic value is used in lots of places, you should have a define for
it, and add it to linux/magic.h.

> +	if (!((((__u32 *) bh->b_data)[0] == s_magic)
> +	      && (((__u32 *) bh->b_data)[1] == s_magic)
> +	      && (((__u32 *) bh->b_data)[2] == s_magic)
> +	      && (s_magic == ((__u32 *) bh->b_data)[3])))
> +		return 0;

&&'s at the end of the line. You can also switch the if to a return and
kill off the else.

> +	vmudata = kmalloc(sizeof(struct memcard), GFP_KERNEL);
> +
> +	/* user blocks */
No error handling again. You will want to verify all of your kmallocs,
since you seem to have this issue a lot.

> +	while ((erasesize /= 2) != 0)
> +		log_2++;	/* thanks to MR Brown */
> +
> +	sb->s_blocksize_bits = log_2;

ilog2()?

I've tried to skip over the bits already noted by Evgeniy, but you may
have already fixed up some of the issues noted above anyways.

Also, in the next iteration of this patch, please do not break the Cc
list and send multiple times to different lists, it makes it very
difficult to follow what is going on, especially if the threads of
conversation diverge.
