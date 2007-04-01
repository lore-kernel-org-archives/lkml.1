Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXDARnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXDARnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXDARnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:43:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679AbXDARnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:43:24 -0400
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
From: David Zeuthen <davidz@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <20070401152957.GA5068@ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com>
	 <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
	 <20070327110524.975e7113.zaitcev@redhat.com>
	 <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz>
Content-Type: text/plain
Date: Sun, 01 Apr 2007 13:42:46 -0400
Message-Id: <1175449366.3008.120.camel@zelda.fubar.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 15:29 +0000, Pavel Machek wrote:
> Hi!
> 
> > > > In that case the user would see data corruption - just as if he mounts a piece
> > > > of removable media in a USB card reader; yanks out the card and modifies it
> > > > elsewhere, and then puts it back in.
> > > 
> > > > I my opinion we can't really defend ourselves against such users... We can of
> > > > course add checks in the file system drivers in the resume hooks to validate the
> > > > super block and mount read-only if something change. 
> > > 
> > > The GNOME hath spoken?
> 
> > 	I also thought about that,
> > 	
> > 	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
> > 	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
> > 	 for users who know what they are doing)
> > 
> > 	What do you think ?
> 
> Agreed... and notice how easy is to do that in userspace :-))).
> 

The problem with refusing to suspend with usb mass storage devices
mounted is just not going to work; the way we want desktop power
management to work is that the system automatically does s2ram or s2disk
when

 - the system is idle
 - the user closes the laptop lid
   (all this is of course configurable but these are the defaults
    in many distributions of Linux.)

and the kernel refusing to suspend in these cases may result in e.g. the
laptop melting because the lid is closed. For example, in
gnome-power-manager we play a loud "boohoo" sound if suspend fails when
closing the lid. It's all we can do really, the user have closed the lid
and if we didn't alert her _in some way_ the result would be a melted
laptop. You have to realize that people use their system in such a way.

Suspending when idle is really important too, since at some point there
will be legislation (akin to accessibility, e.g. the US's section 508)
that mandates that e.g. the US government will not buy systems that
don't conserve power by going to sleep when idle. That's an incentive at
least for "enterprise distributions" to fix this; more importantly, I
personally think that we have a moral obligation to do all that we can
to conserve power. Refusing to suspend means that many systems with USB
mass storage devices attached will consume e.g. 300W instead of 8W. I
don't know about you, but that sounds awfully wasteful to me.

And there's this: suggesting to just provide an option for people to
override this is not useful; any sane desktop distro will use that
override because users _expect_ that their laptop suspends when they
close the lid and they don't really or know care whether some drive is
connected via USB.

I hate to play this card, but you may want to look at other desktop
operating systems like Mac OS X and Windows - they don't give you USB
disconnects/reconnects on suspend and apps runs fine and can continue
accessing files on mounted USB devices upon resume.

I hope this clarifies the request. Thanks for considering.

      David


