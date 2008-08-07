Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYHGOPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYHGOPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYHGOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:14:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45362 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750704AbYHGOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:14:50 -0400
Date: Thu, 7 Aug 2008 10:14:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <489A2B52.6090605@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808070956480.2598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Simon Arlott wrote:

> > Not exactly -- you should move most of usb/ forward so that it comes
> > before usb/host/.  Or alternatively move usb/host/ later so that it 
> > comes after the rest of usb/.
> 
> Well, putting usb/ before net/ etc. requires that usb/host/ is the usb/stuff/ or 
> they'll all wait until they can probe for devices.

I don't understand.

I never said you should move usb/.  I said you should move usb/host/ 
after all the rest of usb/*/.

> > Doesn't the host init _already_ come before device init?  If host init 
> > were moved _after_ device init, I don't think there would be a lot of 
> > side effects.  But it's hard to be sure without trying it.
> 
> Host init is before device init, as that's the Makefile link order. Any device 
> init causes it to wait for *all* devices,

"wait" is the wrong word.  Each device init (more accurately, each
device driver init) probes all the USB devices.  But it doesn't have to
wait if nothing else is probing those devices concurrently and if no 
hub activity is going on.

This means that you won't save much time by running multiple USB device
driver initialization threads.  Better to do all those inits in a
single thread.

The ideal situation is to have each device driver initcall run when 
there are _no_ USB devices to be probed -- i.e., before the host 
drivers have been initialized.

> so swapping them around means devices 
> are going to appear at any time after that - there's no device initcall to make 
> it block.
> 
> Presumably it would be possible to have a late_initcall (which would 
> be early in that list if usb was earlier) that could ensure khubd had finished 
> [its current queue] before continuing - as if there was a device driver initcall?
> 
> If someone currently has HCD init compiled in but nothing else, then the boot 
> process would block unnecessarily... the initcall would need to be disabled 
> in that case to maintain existing behaviour - which is why it probably needs 
> to be a config option, which requires some mess in the Makefile or a new 
> initcall type.

Again, I don't understand.  What's wrong with simply reordering 
drivers/usb/Makefile so that all the host/ entries come at the end?

> >> Lack of a keyboard makes it impossible to do anything if the module fails to 
> >> load... as I understand it when the HCD init runs, any BIOS emulation stops?
> > 
> > That's right.  The host driver kicks the BIOS off the hardware.

As David Brownell pointed out, I was wrong about this.  The BIOS gets 
kicked off even before the host driver starts running, as part of PCI 
initialization.

> It seems like there's always going to be a stage where there's no keyboard...

Yes.

> > I noticed in your logs earlier that some of your USB drivers were 
> > compiled in and others weren't.  Maybe if _all_ of them were compiled 
> > in you wouldn't experience as much contention and the init delays would 
> > be shorter.
> 
> I don't know where you got that from - they're definitely all compiled in. 
> Whichever is first to have its initcall run is blocked, and the logs may have 
> been from a test of that.

I must have misinterpreted one of the earlier messages in this thread.

Alan Stern

