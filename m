Return-Path: <linux-kernel-owner+w=401wt.eu-S965829AbXDBUei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbXDBUei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965841AbXDBUei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:34:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829AbXDBUeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:34:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Date: Mon, 2 Apr 2007 22:37:49 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, David Zeuthen <davidz@redhat.com>,
       Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       gregkh@suse.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <Pine.LNX.4.44L0.0704012241530.23464-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704012241530.23464-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022237.50578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 April 2007 04:54, Alan Stern wrote:
> On Sun, 1 Apr 2007, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > On Sunday, 1 April 2007 20:34, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > Problem is that suspending _with_ removable mass storage devices
> > > > > attached just will not work. User will unplug them, then complain
> > > > > about corruption. Advanced user will unplug them, work with them
> > > > > somewhere else, replug them, then loose filesystem.
> > > > > 
> > > > > Feel free to send patch to teach filesystems to handle this.
> > > > 
> > > > Actually what's needed is a Persistent Logical Volume Manager.  With it,
> > > > you could even mount a filesystem on a USB device, unplug the device, plug
> > > > it back into a different port, and still be able to use the filesystem.
> > > > 
> > > > But you're still likely to run into trouble if you unplug a storage
> > > > device, move it to another system and write on it, then plug it back into
> > > > the original system.  The PLVM would somehow have to recognize that the
> > > > data had been changed.  I don't know a foolproof way of doing that.
> > > 
> > > Such detection should be possible when done at filesystem level.
> > > 
> > > I.e. ext3 would notice that someone replayed the journal.
> > > 
> > > Or we could create ext5 where each r/w mount would update mount
> > > time... actually we probably already have last mount time in ext3,
> > > so...
> > 
> > I'm thinking we'll need to introduce something like freezing notifiers, ie.
> > the ability to register a notifier by an interested subsystem that will be
> > called right after user space processes have been frozen and right before
> > we start to thaw them (that may allow us to handle the microcode issue in
> > a clean way, for example).
> > 
> > Now if a filesystem registers a freezing notifier, it may be unmounted during
> > the suspend and remounted during the resume in more or less transparent
> > way.  I think an additional mount flag would be needed for filesystem that
> > should install such notifiers, like "removable".
> 
> "Unmounted" and "remounted" aren't quite the right words.  All you really
> need to do is check (during the resume) that the superblock is still in
> the same state as it was when the suspend occurred.

Yes, I was thinking of something more sophisticated, but this is what we need.

> After all, if someone 
> else had mounted the dirty filesystem during the interim, they surely
> would have altered the superblock.  Note that even a read-only mount of a
> dirty ext3 filesystem will recover the journal; presumably that will alter
> the superblock too.
> 
> I don't think a "removable" flag is needed.  There's no reason not to do 
> this for every mounted filesystem.

Well, I'm afraid about such filesystems as vfat ...

> (Also "removable" isn't the right word either, since hot-pluggable devices 
> with non-removable media would need the same treatment.  In fact, while 
> the system is hibernating someone could even remove an internal IDE drive 
> and then put it back!)

I meant the filesystems could be marked as "removable" rather than the
devices containing them, so that the users could tell us which filesystems
might need special handling.

> One final nit:  It's possible for someone to alter the data sectors 
> directly, without mounting the filesystem.  This is sufficiently perverse 
> that we probably shouldn't worry about it.

Agreed.

Greetings,
Rafael
