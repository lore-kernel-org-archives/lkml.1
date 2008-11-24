Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKXFNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKXFNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYKXFN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:13:27 -0500
Received: from ns.suse.de ([195.135.220.2]:40757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbYKXFN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:13:26 -0500
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Date: Mon, 24 Nov 2008 16:13:24 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18730.14324.830648.449469@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
In-Reply-To: message from Tejun Heo on Monday November 24
References: <20081124035516.3465.66413.stgit@notabene.brown>
	<20081124035530.3465.26724.stgit@notabene.brown>
	<492A2B2B.7030606@kernel.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday November 24, tj@kernel.org wrote:
> (cc'ing Greg)
> 
> NeilBrown wrote:
> > Currently md devices, once created, never disappear until the module
> > is unloaded.  This is essentially because the gendisk holds a
> > reference to the mddev, and the mddev holds a reference to the
> > gendisk, this a circular reference.
> > 
> > If we drop the reference from mddev to gendisk, then we need to ensure
> > that the mddev is destroyed when the gendisk is destroyed.  However it
> > is not possible to hook into the gendisk destruction process to enable
> > this.
> > 
> > So we drop the reference from the gendisk to the mddev and destroy the
> > gendisk when the mddev gets destroyed.  However this has a
> > complication.
> > Between the call
> >    __blkdev_get->get_gendisk->kobj_lookup->md_probe
> > and the call
> >    __blkdev_get->md_open
> > 
> > there is no obvious way to hold a reference on the mddev any more, so
> > unless something is done, it will disappear and gendisk will be
> > destroyed prematurely.
> > 
> > Also, once we decide to destroy the mddev, there will be an unlockable
> > moment before the gendisk is unlinked (blk_unregister_region) during
> > which a new reference to the gendisk can be created.  We need to
> > ensure that this reference can not be used.  i.e. the ->open must
> > fail.
> 
> Ah... I'm not really sure I'm following all of this correctly but would
> it be possible to just add ->release to genhd and do regular reference
> counting rather than this complex dancing?  ->release was recently added
> to cdev so it'll be nicely parallel.

Maybe...

If genhd.c:disk_release called e.g.
	disk->fops->final_put(disk)

then I could possibly link in to that to destroy the md state when the
gendisk finally disappears.

When I want to kill the gendisk I would call blk_unregister_region
directly (not through del_gendisk) to allow it to disappear.
If md_probe then gets called before the final_put, I'd need to
call blk_register_region again to re-install it.

I think that would work.

Would 'block_device_operations' be the right place for this
'final_put' or 'final_release' ??

Thanks.


NeilBrown
