Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbXHIGvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbXHIGvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXHIGvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:51:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:45988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXHIGvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:51:15 -0400
From: Neil Brown <neilb@suse.de>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Date: Thu, 9 Aug 2007 16:50:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18106.47442.440816.650446@notabene.brown>
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] allow mapping from block-device-file to sysfs entry.
In-Reply-To: message from Kay Sievers on Tuesday August 7
References: <18104.3098.696484.970773@notabene.brown>
	<1186468623.2700.4.camel@laptopd505.fenrus.org>
	<18104.7056.369176.547630@notabene.brown>
	<3ae72650708070041s52861b7dr484cacf98353a3c6@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 7, kay.sievers@vrfy.org wrote:
> On 8/7/07, Neil Brown <neilb@suse.de> wrote:
> > On Monday August 6, arjan@infradead.org wrote:
> > > On Tue, 2007-08-07 at 16:07 +1000, Neil Brown wrote:
> > > > Suppose that in a program I have an open file descriptor for a device,
> > > > and I want to find the /sys/block information for this device.
> > > > There is currently no direct way to do this.  I need to read
> > > >    /sys/block/*/dev, /sys/block/*/*/dev
> > > > and match major/minor numbers with the result from fstat.
> > > >
> > > > I would like a more direct mechanism.
> 
>   $ udevinfo --query=path --name=sda
>   /block/sda

If I interpret the result of 'strace' properly, this looks at
   /dev/.udev/names/sda
and prints the result after decoding '\x2f' as '/'.
I want to go from an open file descriptor, or at least an entry in
/dev.

And I don't think I want to depend on udev if I can avoid it....

> >
> > That makes a lot of sense.
> > So it would return "block/sda/sda1" now,
> 
> Every devpath always starts with a '/' in the kernel, its kind of
> weird, but we should not introduce a new variation of it. :)

Fair comment.  So
       /block/sda/sda1
now, and whatever later.

> 
> They can be definitely longer than than 256, probably not longer than
> 512 today, but you can't be sure about that.

I guess we go for PATH_MAX then?

Any idea how to get a sysfs path in a generic way?
I tried:
		struct inode *inode = filp->f_path.dentry->d_inode;
		struct kobject *ko = NULL;
		char *path = NULL;
		if (S_ISBLK(inode->i_mode) &&
		    inode->i_bdev &&
			inode->i_bdev->bd_disk)
			ko = &inode->i_bdev->bd_disk->kobj;
		if (S_ISCHR(inode->i_mode) &&
		    inode->i_cdev)
			ko = &inode->i_cdev->kobj;
		if (ko)
			path = kobject_get_path(ko, GFP_KERNEL);


For /dev/sda, it returns /block/sda which is good.
For /dev/sda1 it still returns /block/sda which is not good.
For /dev/null it returns /mem which doesn't even exist in sysfs
For /dev/tty it doesn't return anything.

I'm tempted to just implement it for block devices and let someone
else worry about char devices.

Thanks,

NeilBrown
