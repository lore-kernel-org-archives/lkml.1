Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYCaR2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYCaR2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYCaR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:28:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYCaR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:28:29 -0400
Date: Mon, 31 Mar 2008 10:28:13 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
Message-ID: <20080331172813.GA11583@kroah.com>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <200803310215.39414.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803310215.39414.dtor@insightbb.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 02:15:39AM -0400, Dmitry Torokhov wrote:
> Hi Linus,
> 
> On Sunday 30 March 2008, Linus Torvalds wrote:
> > 
> > On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
> > >
> > > I can't reproduce the bug on my UP box and currently can't afford
> > > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > > guess it needs SMP to crash), so while this doesn't show any new
> > > problems, I can't tell whether it actually fixes anything. Testers
> > > welcome!
> > 
> > Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
> > really really hope somebody can figure out what made this all start to 
> > trigger. It does smell like some core device layer change, because we do 
> > not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
> > seem relevant.
> > 
> > Greg, are there any refcounting changes that would cause the input devices 
> > to be free'd earlier or something?
> > 
> 
> The following commit changed lifetime runes on kobjects breaking input:
> 
> commit 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Wed Dec 19 01:40:42 2007 +0100
> 
>     Kobject: auto-cleanup on final unref
> 
>     We save the current state in the object itself, so we can do proper
>     cleanup when the last reference is dropped.
> 
>     If the initial reference is dropped, the object will be removed from
>     sysfs if needed, if an "add" event was sent, "remove" will be send, and
>     the allocated resources are released.
> 
>     This allows us to clean up some driver core usage as well as allowing us
>     to do other such changes to the rest of the kernel.
> 
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Before we dropped reference to kobject's parent only when child kobject
> was released (in kobject_cleanup). The changeset above moves the release
> to kobject_del() which is way too early in my opinion. The kobject is only
> marked for deletion at that time, not really deleted.

It was "deleted" from sysfs, and should have never been used again by
any callers.  If the reference count was dropped to zero with this call,
it would be cleaned up as well, it seems that you were assuming that it
would not be?  Perhaps you just need to grab another reference as this
would have caused you problems without this change anyway, but without
slab debugging, you never saw it.

> I will look how to properly fix evdev and the rest of input interfaces
> tomorrow.

If you need any help, please let me know.

thanks,

greg k-h
