Return-Path: <linux-kernel-owner+w=401wt.eu-S1765401AbXKOTCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765401AbXKOTCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbXKOTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:02:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXKOTC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:02:27 -0500
Date: Thu, 15 Nov 2007 10:59:03 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, Jiri Kosina <jikos@jikos.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115185903.GA29542@kroah.com>
References: <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com> <20071114165906.GB13889@kroah.com> <1195065493.2168.31.camel@lov.site> <Pine.LNX.4.64.0711142018390.15844@twin.jikos.cz> <1195075663.2609.2.camel@lov.site> <a8e1da0711141701xc66109dv93ad2c3d2b76ebec@mail.gmail.com> <1195094293.2731.14.camel@lov.site> <20071115081407.GA3688@darkstar.te-china.tietoenator.com> <20071115170634.GA24587@kroah.com> <1195146984.2748.3.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195146984.2748.3.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 06:16:24PM +0100, Kay Sievers wrote:
> On Thu, 2007-11-15 at 09:06 -0800, Greg KH wrote:
> > On Thu, Nov 15, 2007 at 04:14:07PM +0800, Dave Young wrote:
> > > On Thu, Nov 15, 2007 at 03:38:13AM +0100, Kay Sievers wrote:
> > > > On Thu, 2007-11-15 at 09:01 +0800, Dave Young wrote:
> > > > > On Nov 15, 2007 5:27 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > > > On Wed, 2007-11-14 at 20:19 +0100, Jiri Kosina wrote:
> > > > > > > On Wed, 14 Nov 2007, Kay Sievers wrote:
> > > > > > >
> > > > > > > > Could it be an init-order problem, where something tries to use the
> > > > > > > > block subsystem? Before it is initialized with:
> > > > > > > >   block/genhd.c :: subsys_initcall(genhd_device_init);
> > > > > > > > If that's the case, we have an old bug that nobody noticed with static
> > > > > > > > structures, which are zeroed that time, but definitely not properly
> > > > > > > > initialized. I'll try to build loop non-modular now, and see if that
> > > > > > > > makes the bug appear here.
> > > > > >
> > > > > > > my .config with which I reproduc this on 2.6.24-rc2-mm1 reliably can be
> > > > > > > obtained from http://www.jikos.cz/jikos/junk/.config
> > > > > >
> > > > > > Hmm, that config doesn't do anything here, and if I make it boot, it
> > > > > > does not show the bug.
> > > > > >
> > > > > > Could you possibly enable kobject debugging and see if that exposes
> > > > > > something, maybe something goes wrong with the kset refcount and it gets
> > > > > > released while in use.
> > > > > >
> > > > > Hi,
> > > > > I would do that.
> > > > 
> > > > That would be great.
> > > > 
> > > > > BTW, The bug report as EIP  at __list_add with CONFIG_DEBUG_LIST=y
> > > > 
> > > > Yeah, that hints that the kset, which contains the list, is not
> > > > allocated at the time it is used, or it is already released (kfree)
> > > > again by some buggy logic.
> > > Yes, I debugged it, there's some new findings.
> > > It is freed by put_disk.
> > > The floppy driver alloc_disk and then call put_disk without register_disk.
> > > in kobject_cleanup line 551:
> > > if(s)
> > > 	kset_put(s);
> > > Now the kset is set in alloc_disk after kobject_init, so it is not refereced yet.
> > > please try this patch:
> > >  
> > > block/genhd.c |    2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff -upr linux/block/genhd.c linux.new/block/genhd.c
> > > --- linux/block/genhd.c	2007-11-15 15:59:11.000000000 +0800
> > > +++ linux.new/block/genhd.c	2007-11-15 15:59:39.000000000 +0800
> > > @@ -718,9 +718,9 @@ struct gendisk *alloc_disk_node(int mino
> > >  			}
> > >  		}
> > >  		disk->minors = minors;
> > > -		kobject_init(&disk->kobj);
> > >  		disk->kobj.kset = block_kset;
> > >  		disk->kobj.ktype = &ktype_block;
> > > +		kobject_init(&disk->kobj);
> > >  		rand_initialize_disk(disk);
> > >  		INIT_WORK(&disk->async_notify,
> > >  			media_change_notify_thread);
> > 
> > Ah, yes, that is a bug, and it's my fault, let me go fix that in my
> > patch series.
> 
> Oh, this is an old bug, that just didn't crash with the static ksets, it
> did all the refcounting wrong, but nobody noticed it because the kset
> data was still there.

No, I messed it up when I did the initial kset changes.  If you look at
2.6.24-rc2, it's correct there:
		disk->minors = minors;
		kobj_set_kset_s(disk,block_subsys);
		kobject_init(&disk->kobj);

I have no idea why I switched those lines around, sorry about that.

greg k-h
