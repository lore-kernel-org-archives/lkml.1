Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYBSJUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYBSJUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYBSJTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:19:49 -0500
Received: from brick.kernel.dk ([87.55.233.238]:6571 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYBSJTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:19:47 -0500
Date: Tue, 19 Feb 2008 10:19:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Clements <paul.clements@steeleye.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-ID: <20080219091943.GS23197@kernel.dk>
References: <20080208101151.935b575c.akpm@linux-foundation.org> <47ACA250.1010404@steeleye.com> <20080208204510.GD23197@kernel.dk> <20080208204713.GF23197@kernel.dk> <47ACC835.4070102@steeleye.com> <20080208140244.c850a5d3.akpm@linux-foundation.org> <47ADAB00.90306@steeleye.com> <20080212151602.f1803ef0.akpm@linux-foundation.org> <20080218181630.GI23197@kernel.dk> <20080218155001.97bf5976.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218155001.97bf5976.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18 2008, Andrew Morton wrote:
> On Mon, 18 Feb 2008 19:16:30 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Feb 12 2008, Andrew Morton wrote:
> > > On Sat, 09 Feb 2008 08:30:40 -0500
> > > Paul Clements <paul.clements@steeleye.com> wrote:
> > > 
> > > > +		old_e = disk->queue->elevator;
> > > > +		if (elevator_init(disk->queue, "deadline") == 0 ||
> > > > +			elevator_init(disk->queue, "noop") == 0) {
> > > > +				elevator_exit(old_e);
> > > > +		}
> > > >  	}
> > > 
> > > afacit elevator_init() will not trigger a request_module().  And you really
> > > do want to trigger the request_module() here.  Perhaps the block layer
> > > should provide a means of doing so?
> > 
> > Good point, I think elevator_get() should do that automatically. Does
> > this look sane?
> > 
> > diff --git a/block/elevator.c b/block/elevator.c
> > index bafbae0..88318c3 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -134,6 +134,21 @@ static struct elevator_type *elevator_get(const char *name)
> >  	spin_lock(&elv_list_lock);
> >  
> >  	e = elevator_find(name);
> > +	if (!e) {
> > +		char elv[ELV_NAME_MAX + strlen("-iosched")];
> > +
> > +		spin_unlock(&elv_list_lock);
> > +
> > +		if (!strcmp(name, "anticipatory"))
> > +			sprintf(elv, "as-iosched");
> > +		else
> > +			sprintf(elv, "%s-iosched", name);
> > +
> > +		request_module(elv);
> > +		spin_lock(&elv_list_lock);
> > +		e = elevator_find(name);
> > +	}
> > +
> >  	if (e && !try_module_get(e->elevator_owner))
> >  		e = NULL;
> 
> Looks nice and simple.  There might be some of the usual ordering problems
> when this is called during boot, maybe is-initramfs-available-yet problems,
> etc.  But it's unlikely to make things regress from where they are now.

Isn't request_module() and below robust enough to handle that?

> Should we emit a warning if the desired elevator wasn't available?

Hmm, not sure. Either the request came from a driver, in which case
it'll be notified that we could not load that elevator. Or it'll come
through sysfs online switching, in which case we already print a
warning.

-- 
Jens Axboe

