Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbYKXEYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbYKXEYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYKXEYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:24:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43591 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKXEYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:24:22 -0500
Date: Mon, 24 Nov 2008 04:24:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Message-ID: <20081124042421.GY28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124035530.3465.26724.stgit@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 02:55:30PM +1100, NeilBrown wrote:
> Between the call
>    __blkdev_get->get_gendisk->kobj_lookup->md_probe
> and the call
>    __blkdev_get->md_open
> 
> there is no obvious way to hold a reference on the mddev any more, so
> unless something is done, it will disappear and gendisk will be
> destroyed prematurely.
> 
> Also, once we decide to destroy the mddev, there will be an unlockable
> moment before the gendisk is unlinked (blk_unregister_region) during
> which a new reference to the gendisk can be created.  We need to
> ensure that this reference can not be used.  i.e. the ->open must
> fail.
> 
> So:
>  1/  in md_probe we set a flag in the mddev (hold_active) which
>      indicates that the array should be treated as active, even
>      though there are no references, and no appearance of activity.
>      This is cleared by md_release when the device is closed.
>      This ensure that the gendisk will survive between md_probe and
>      md_open.

That won't work.  Note that you are not guaranteed that md_release() will be
called after md_probe(); there are failure exits in __blkdev_get() that do
not reach ->open() at all.

What lifetime rules do you really want?  I never liked the tricks pulled
by md wrt gendisk lifetimes and that might be a good time to sort that
out for good...

What should happen to things like pending IO, etc. on array destruction?
AFAICS, that's the real question...
