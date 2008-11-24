Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYKXQIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYKXQIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYKXQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:07:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:51865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbYKXQHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:07:48 -0500
Message-ID: <492AD169.9000805@suse.de>
Date: Tue, 25 Nov 2008 01:08:09 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk> <492AB480.5060207@kernel.org> <492AB98C.7030105@suse.de> <20081124144823.GC28946@ZenIV.linux.org.uk>
In-Reply-To: <20081124144823.GC28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> With ->fops in already freed memory?  Good idea, that...

The existence can be tested on registration and remembered.  Existence
of fops->disk_release signifies that the object and module are around
till the last object is released.

> Look, that's the wrong object *and* the wrong place; gendisk is separate
> from driver-specific data structures for a good reason.
> 
> _IF_ you want to tie something to "opened or in process of being opened",
> the right place is __blkdev_get()/blkdev_put() (BTW, note that get_gendisk()
> is essentially a part of __blkdev_get()).
> 
> It's not about rmmod of module while some disk is opened; _that_ is impossible
> as is.  It's about e.g. modules like sd.ko that would be flat-out impossible
> to unload at all.
> 
> Think for a minute: we do have a bunch of gendisks created by sd; they stay
> around until we rmmod the damn thing and we really want it that way.
> We can't have their existence pinning sd down.  What we do is "module is
> busy if any of those is opened or in the middle of opening".

Devices can be killed from userland via sysfs for SCSI or mdadm for
md.  It's true that such approach is less convenient for unloading but
if it can make usual cases easier, why not?

For both char and block devices, having ->open lookup and grab the
device were easy when each driver supported limited number of devices
and things were pretty much static, but it grows more awkward as
things become more dynamic.  Having to have a lookup table just for
->open lookup isn't pretty at all and missing ->release can get quite
uncomfortable too.

> The same goes for just about any block driver out there; md is weird for
> one reason - it wants to have devices possible to open without any prior
> event that would mark the beginning of availability (such as e.g. hardware
> detection for SCSI, IDE, etc.).  That is a side effect of bad API - there
> *is* a moment for md that would be a good candidate for such event (array
> being completely configured and available for normal IO), but that would
> require an API for creating and configuring these suckers that wouldn't
> start with "First you open the very device you are trying to create..."
> Too bad - we are tied to lousy userland interface and can't get rid of
> it.  That is where all the PITA is coming from.
> 
> And the right way to deal with that is to have explicit boundaries for
> "opened or in process of being opened"; we almost have them (probe and
> final release), so the only point we are missing is on failure exit from
> __blkdev_get()...
> 
> I really think that it's much saner than trying to change the lifetime
> rules for gendisk, etc.

Well, I don't know.  It seems like a lot of trouble just to allow
"rmmod something" without first killing the devices and as people are
now so used to reference counted objects and ->release, not having it
on cdev or gendisk is quite a PITA.  (BTW, Greg, can you please drop
cdev->release patch for now, it's wrong as it currently stands).

Can you see any problem with caching ->disk_release existence on
registration and wrap __module_get/put() around its invocation?  It
wouldn't change behavior of any existing drivers and md can use it if
it wants.  Doing "mdadm --stop --scan" would be enough to unload the
module and md can do whatever forward or back reference it wants to do
to work out the weird userland interface.

Thanks.

-- 
tejun
