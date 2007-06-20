Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXFTV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXFTV4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXFTV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:56:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXFTV4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:56:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mattia Dongili <malattia@linux.it>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Date: Thu, 21 Jun 2007 00:03:29 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070620153813.GA3569@inferi.kami.home> <200706202250.04414.rjw@sisk.pl>
In-Reply-To: <200706202250.04414.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706210003.30536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 June 2007 22:50, Rafael J. Wysocki wrote:
> On Wednesday, 20 June 2007 17:38, Mattia Dongili wrote:
> > On Wed, Jun 20, 2007 at 01:40:18PM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, 20 June 2007 07:22, Mattia Dongili wrote:
> > > > On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > > > > 
> > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > > > 
> > > > Hello,
> > > > on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> > > > is becoming troublesome as different sets have slightly different
> > > > problems.
> > > > At one point (with the GREGKH usb stuff built) I had the kernel
> > > > reporting it cannot stop the usb-storage thread so I guess that
> > > > something later in the series made things worse (freezable workqueues?).
> > > > 
> > > > Clues?
> > > 
> > > Can you please try 2.6.22-rc5 with the patches from
> > > 
> > > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/
> > > 
> > > applied.  That should allow us to eliminate some suspects. ;-)
> > 
> > you're safe then! .22-rc5 + your suspend patch-set can suspend and
> > resume happily.
> 
> OK, thanks.  OTOH, that would have been less patches to check ... ;-)
> 
> I'll see if I can reproduce your problem here.

Yes, I can.  It's only necessary to load usb-storage (without any devices
actually using it) and it fails device_suspend() immediately (I don't think
it's freezer-related).

I've got the following trace from it:

usb_endpoint usbdev3.2_ep81: PM: suspend 0->1, parent 3-1:1.0 already 2
Suspending device 3-1:1.0
Suspending device usbdev3.2_ep00
Suspending device 3-1
Suspending device eth1
Suspending device eth0
Suspending device usbdev3.1
Suspending device usbdev3.1_ep81
Suspending device 3-0:1.0
Suspending device usbdev3.1_ep00
Suspending device usb3
hub 3-0:1.0: hub_suspend
ohci_hcd 0000:00:02.1: needs reinit!
usb usb3: suspend fail, err -16
usb usb3: 'global' suspend -16
hub 3-0:1.0: hub_resume
hub 3-0:1.0: activate --> -108
suspend_device(): usb_suspend+0x0/0x30() returns -16
Could not suspend device usb3: error -16
WARNING: at /home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/urb.c:293 usb_submit_urb()

Call Trace:
 [<ffffffff80409dd3>] usb_submit_urb+0x363/0x3b0
 [<ffffffff881e21cf>] :usbhid:hid_start_in+0x8f/0xb0
 [<ffffffff881e221a>] :usbhid:hid_resume+0x2a/0x30
 [<ffffffff8040c832>] usb_resume_interface+0x92/0x100
 [<ffffffff8040c93e>] usb_external_resume_device+0x9e/0x170
 [<ffffffff8040ca3b>] usb_resume+0x2b/0x40
 [<ffffffff803ed097>] resume_device+0x87/0x190
 [<ffffffff803ed239>] dpm_resume+0x99/0xc0
 [<ffffffff803ecef7>] device_suspend+0x147/0x190
 [<ffffffff803c1891>] tty_ldisc_deref+0x61/0x80
 [<ffffffff80268e1e>] hibernation_snapshot+0x3e/0xe0
 [<ffffffff802e7fce>] dnotify_parent+0x3e/0x90
 [<ffffffff8026c059>] snapshot_ioctl+0x379/0x540
 [<ffffffff8026bce0>] snapshot_ioctl+0x0/0x540
 [<ffffffff802b2b72>] do_ioctl+0x92/0xe0
 [<ffffffff802b2c33>] vfs_ioctl+0x73/0x2d0
 [<ffffffff804b2c7a>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff802b2f21>] sys_ioctl+0x91/0xb0
 [<ffffffff8020bc6e>] system_call+0x7e/0x83

usbhid 3-1:1.0: resume error -16
usb_endpoint usbdev3.2_ep81: PM: resume from 0, parent 3-1:1.0 still 2
input input4: PM: resume from 0, parent 3-1:1.0 still 2
Restarting tasks ... <7>hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
hub 3-0:1.0: hub_port_status failed (err = -108)
hub 3-0:1.0: hub_port_status failed (err = -108)
hub 3-0:1.0: hub_port_status failed (err = -108)
done.
swsusp: Basic memory bitmaps freed

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
