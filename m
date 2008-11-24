Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYKXGYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYKXGYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYKXGYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:24:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKXGYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:24:19 -0500
Date: Mon, 24 Nov 2008 06:24:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Message-ID: <20081124062417.GZ28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492A3CE6.4010206@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 02:34:30PM +0900, Tejun Heo wrote:
> > Maybe...
> > 
> > If genhd.c:disk_release called e.g.
> > 	disk->fops->final_put(disk)
> > 
> > then I could possibly link in to that to destroy the md state when the
> > gendisk finally disappears.
> > 
> > When I want to kill the gendisk I would call blk_unregister_region
> > directly (not through del_gendisk) to allow it to disappear.
> > If md_probe then gets called before the final_put, I'd need to
> > call blk_register_region again to re-install it.
> > 
> > I think that would work.
> > 
> > Would 'block_device_operations' be the right place for this
> > 'final_put' or 'final_release' ??
> 
> I suppose so.  Maybe just void (*release)(struct gendisk *) but Jens is
> the maintainer.  Jens, what do you think?

First of all, release is already taken (with exactly that argument, BTW).
And doing that at freeing gendisk is a bad idea - md.ko might have been
long gone by the time you've got there, not to mention anything else...
IOW, it's too late; once the damn thing is not opened anymore (and nobody
is the middle of trying to open it), the module might be dead and gone,
so all uses of ->private_data and ->fops are illegal after that point.
