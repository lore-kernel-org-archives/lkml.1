Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKXFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKXFfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYKXFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:35:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:54956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYKXFfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:35:17 -0500
Message-ID: <492A3CE6.4010206@kernel.org>
Date: Mon, 24 Nov 2008 14:34:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
References: <20081124035516.3465.66413.stgit@notabene.brown>	<20081124035530.3465.26724.stgit@notabene.brown>	<492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown>
In-Reply-To: <18730.14324.830648.449469@notabene.brown>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 24 Nov 2008 05:34:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)

Neil Brown wrote:
> On Monday November 24, tj@kernel.org wrote:
>> (cc'ing Greg)
>>
>> NeilBrown wrote:
>>> Currently md devices, once created, never disappear until the module
>>> is unloaded.  This is essentially because the gendisk holds a
>>> reference to the mddev, and the mddev holds a reference to the
>>> gendisk, this a circular reference.
>>>
>>> If we drop the reference from mddev to gendisk, then we need to ensure
>>> that the mddev is destroyed when the gendisk is destroyed.  However it
>>> is not possible to hook into the gendisk destruction process to enable
>>> this.
>>>
>>> So we drop the reference from the gendisk to the mddev and destroy the
>>> gendisk when the mddev gets destroyed.  However this has a
>>> complication.
>>> Between the call
>>>    __blkdev_get->get_gendisk->kobj_lookup->md_probe
>>> and the call
>>>    __blkdev_get->md_open
>>>
>>> there is no obvious way to hold a reference on the mddev any more, so
>>> unless something is done, it will disappear and gendisk will be
>>> destroyed prematurely.
>>>
>>> Also, once we decide to destroy the mddev, there will be an unlockable
>>> moment before the gendisk is unlinked (blk_unregister_region) during
>>> which a new reference to the gendisk can be created.  We need to
>>> ensure that this reference can not be used.  i.e. the ->open must
>>> fail.
>> Ah... I'm not really sure I'm following all of this correctly but would
>> it be possible to just add ->release to genhd and do regular reference
>> counting rather than this complex dancing?  ->release was recently added
>> to cdev so it'll be nicely parallel.
> 
> Maybe...
> 
> If genhd.c:disk_release called e.g.
> 	disk->fops->final_put(disk)
> 
> then I could possibly link in to that to destroy the md state when the
> gendisk finally disappears.
> 
> When I want to kill the gendisk I would call blk_unregister_region
> directly (not through del_gendisk) to allow it to disappear.
> If md_probe then gets called before the final_put, I'd need to
> call blk_register_region again to re-install it.
> 
> I think that would work.
> 
> Would 'block_device_operations' be the right place for this
> 'final_put' or 'final_release' ??

I suppose so.  Maybe just void (*release)(struct gendisk *) but Jens is
the maintainer.  Jens, what do you think?

Thanks.

-- 
tejun
