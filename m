Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXF0Esy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXF0Esy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXF0Esr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:48:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbXF0Esq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:48:46 -0400
Date: Tue, 26 Jun 2007 21:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atkbd: cleanup only once
Message-ID: <20070627042820.GC13513@suse.de>
References: <20070627105907.GA1802@darkstar.te-china.tietoenator.com> <200706270034.09802.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706270034.09802.dtor@insightbb.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 12:34:09AM -0400, Dmitry Torokhov wrote:
> Hi Dave,
> 
> On Wednesday 27 June 2007 06:59, Dave Young wrote:
> > Hi,
> > 
> > If you press ctrl+alt+del several times as kernel booting (before user level bootin), the kernel will oops. I found the ps2_command is called more than once, then the ps2dev->serio maybe NULL pointer.
> > 
> > 2.6.22-rc5 and 2.6.22-rc6 have same result.
> > 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > ---
> > diff -upr linux/drivers/input/keyboard/atkbd.c linux.new/drivers/input/keyboard/atkbd.c
> > --- linux/drivers/input/keyboard/atkbd.c	2007-06-27 10:38:37.000000000 +0000
> > +++ linux.new/drivers/input/keyboard/atkbd.c	2007-06-27 10:37:39.000000000 +0000
> > @@ -795,6 +795,11 @@ static int atkbd_activate(struct atkbd *
> >  
> >  static void atkbd_cleanup(struct serio *serio)
> >  {
> > +	static int flag;
> > +
> > +	if(flag)
> > +		return;
> > +	flag = 1;
> 
> Unfortunately this will prevent atkbd from resetting keyboard on 2nd
> suspend attempt. It will also not work if you have an active MUX and
> have a couple of keyboards connected.
> 
> Greg, now that you removed rwsem from subsystem (and subsystem itself
> for that matter) there is nothing as far as I can see that stops
> several threads from running device_shutdown() simultaneously. I also
> do not see what would isolate device probing and shutting them down
> at the same time. Am I missing something?

There was never anything stopping that from happening before.  No driver
core code was using that rwsem, so it wasn't protecting anything,
despite people trying to use it as if it was :)

That's why I removed it.

So, if you need to have a lock for your subsystem to serialize this,
please do so, I have no objection to it.

thanks,

greg k-h
