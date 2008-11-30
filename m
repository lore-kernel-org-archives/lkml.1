Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYK3Pxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYK3Pxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYK3Pxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:53:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39760 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYK3Pxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:53:39 -0500
Date: Sun, 30 Nov 2008 15:53:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix pktcdvd breakage from commit
	e105b8bfc769b0545b6f0f395179d1e43cbee822
Message-ID: <20081130155336.GE28946@ZenIV.linux.org.uk>
References: <20081130132118.GY28946@ZenIV.linux.org.uk> <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com> <20081130133229.GZ28946@ZenIV.linux.org.uk> <20081130134048.GA28946@ZenIV.linux.org.uk> <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com> <20081130135031.GB28946@ZenIV.linux.org.uk> <ac3eb2510811300557u4922699du87a62cfd29020db1@mail.gmail.com> <20081130141329.GC28946@ZenIV.linux.org.uk> <ac3eb2510811300628t2bb40427p22e22e2ed671d9a9@mail.gmail.com> <20081130145221.GD28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130145221.GD28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 02:52:21PM +0000, Al Viro wrote:
> On Sun, Nov 30, 2008 at 03:28:15PM +0100, Kay Sievers wrote:
> > > So we need to preserve the layout, with the easiest way probably being "add
> > > one more ktype and use kobject_init_and_add() instead of that device_create()".
> > > Sigh...
> > 
> > What do you mean? We just need to replace the bogus "pd->pkt_dev" with
> > MKDEV(0, 0) and we are fine.
> 
> Userland-visible change - right now cat /sys/class/pktcdvd/pktcdvd3/dev will
> give you dev_t of the block device in question.

Looking at the locking scheme there, it appears that we have an unpleasant
race of the same kind as discussed in md-with-eviction thread.  If removal
hits between finding (and grabbing) gendisk and actual call of ->open(),
it will succeed just fine and we might get an open for _different_ object,
while holding a reference to disk that had already gone through del_gendisk().
Call ioctl() on that sucker and you've got
        struct pktcdvd_device *pd = bdev->bd_disk->private_data;
which will point to already freed object.

It really appears that we need to
	* add ->use() and ->unuse() callbacks
	* have exact_lock() call ->use() in addition to get_disk() - either
on each hit, or on the "it's currently not in use" ones.
	* have ->unuse() called on failure exits in __blkdev_get() and in
blkdev_put(), with rules matching those for calls of ->use().

That would allow to close that kind of races, both here and in md.  I'd
probably prefer the second variant for calling rules - we would be able
to bracket the "it's associated with underlying objects" intervals by
those calls...  Hell knows; I really need to get some sleep and look through
the ->open() and ->release() instances for block devices.  Later...
