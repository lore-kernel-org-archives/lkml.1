Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0BOMo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:44:59 -0500
Received: from mail001.aei.ca ([206.123.6.130]:38781 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0BOMo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:44:56 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/2] Provide a driver for the Apple Magic Mouse - opps
Date: Mon, 15 Feb 2010 07:42:45 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
       linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002140922.42014.edt@aei.ca> <20100215071145.GA9135@core.coreip.homeip.net>
In-Reply-To: <20100215071145.GA9135@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150742.46242.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010 02:11:46 Dmitry Torokhov wrote:
> On Sun, Feb 14, 2010 at 09:22:41AM -0500, Ed Tomlinson wrote:
> > On Sunday 14 February 2010 03:03:44 Dmitry Torokhov wrote:
> > > On Sat, Feb 13, 2010 at 02:29:29PM -0500, Ed Tomlinson wrote:
> > > > On Wednesday 10 February 2010 08:57:37 Jiri Kosina wrote:
> > > > > On Tue, 9 Feb 2010, Michael Poole wrote:
> > > > > 
> > > > > > I think this patch is ready for real review.  The Magic Mouse requires
> > > > > > that a driver send an unlock Report(Feature) command, similar to the
> > > > > > Wacom wireless tablet and Sixaxis controller quirks.  This turns on an
> > > > > > Input Report that isn't published in the input Report descriptor that
> > > > > > contains touch data (and usually overrides the normal motion and click
> > > > > > Report).
> > > > > > 
> > > > > > Because the mouse has only one switch and no scroll wheel, the driver
> > > > > > (under control of parameters) emulates a middle button and scroll wheel.
> > > > > > User space could also ignore and/or re-synthesize those events based on
> > > > > > the reported events.
> > > > > > 
> > > > > > The first patch exports hid_register_report() so the driver can turn on
> > > > > > the multitouch report.  The second patch adds the device ID and the
> > > > > > driver.  Some user-space tools to talk to the mouse directly (that is,
> > > > > > when it is not associated with the host's HIDP stack) are at
> > > > > > http://github.com/entrope/linux-magicmouse .
> > > > > 
> > > > > I have applied the driver into apple_magic_mouse branch and merged this 
> > > > > branch into for-next, so it should appear in the upcoming linux-next.
> > > > 
> > > 
> > > > This driver (or the hid changes) can triggers an opps.  What I did was
> > > > start X.  Turn on the magic mouse.  It connected on input7&8.  Then I
> > > > powered it off and on.  This time it conneced on input9&10.  Then I
> > > > exited X and got the opps.  Note my X does not hotplug the magic
> > > > mouse.  I've also included a trace of the udev events that generated
> > > > the log below (if there was a remove after X stopped it would not be
> > > > included).  To my eyes it looks like we leak an input device (there is
> > > > not a remove event for input8).
> > > >
> > > 
> > > Indeed, we seem to be missing call to input_unregister_device() in
> > > magicmouse_remove().
> > 
> > How does this look?  With this udevadm shows input8 being removed and
> > there is no more opps.
> 
> Almost... you need to do hid_hw_stop() first and only then unregister
> input device, Otherwise if you unload the module while moving the mouse
> it is likely to still oops.


