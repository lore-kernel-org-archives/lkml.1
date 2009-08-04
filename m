Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZHDPJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZHDPJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZHDPJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:09:03 -0400
Received: from kroah.org ([198.145.64.141]:50200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbZHDPJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:09:01 -0400
Date: Tue, 4 Aug 2009 07:53:53 -0700
From: Greg KH <greg@kroah.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804145353.GA20041@kroah.com>
References: <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
 <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
 <20090804035319.GA7248@kroah.com>
 <20090804040834.GA16696@kroah.com>
 <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
 <20090804072351.GA17474@kroah.com>
 <20090804091237.GA3174@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804091237.GA3174@localdomain.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 12:12:37PM +0300, Sergey Senozhatsky wrote:
> On (08/04/09 00:23), Greg KH wrote:
> > On Mon, Aug 03, 2009 at 11:19:53PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 3 Aug 2009, Greg KH wrote:
> > > > 
> > > > Oh wait, the original problem, single user mode.  Hm, we need all of
> > > > these to fix that problem?  Or just the first one?
> > > 
> > > Patches 1-3 should fix that one. 4-5 are just cleanups with no semantic 
> > > changes.
> > 
> > Ok, but due to the lateness of the release cycle, is it worth it to add
> > those 3 right now?  Or do we just take the BUG_ON() out as it's pretty
> > harmless while shutting down in single user mode?
> > 
> > What do you think?
> > 
> 
> I don't think that take the BUG_ON out is the best we can do. 
> 
> If I understand correctly, this one (tty_ldisc.c:209):
> static void tty_ldisc_put(struct tty_ldisc *ld)
> {
> 	[...]
> 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
> -	WARN_ON(ld->refcount);
> 	kfree(ld);
> }
> 
> It's better to leave everything as is in that case and wait 32 (to my mind).

Sorry, you are correct, it was a WARN_ON call that caused the warning.

One other option is to put these changes into .32, and add them back to
the .31 -stable tree once it goes into Linus's tree and no one has any
reported problems.

thanks,

greg k-h
