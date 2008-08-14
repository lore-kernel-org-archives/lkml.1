Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYHNOAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYHNOAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbYHNN7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:59:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40508 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYHNN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:59:45 -0400
Date: Thu, 14 Aug 2008 15:08:12 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       James.Bottomley@HansenPartnership.com, teheo@novell.com,
       oneukum@suse.de
Subject: Re: Power management for SCSI
Message-ID: <20080814130812.GC2262@elf.ucw.cz>
References: <20080813095055.GA475@elf.ucw.cz> <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Add support for autosuspend/autoresume. Lowlevel driver can use it to
> > spin the disk down and power down its SATA link, to turn off the USB
> > interface, etc.
> > 
> > Spinning down the disk is useful - saves ~0.5W here. Powering down
> > SATA controller is even better -- should save ~1W.
> > 
> > Now, I guess the patch will need to be split to small pieces for
> > merge... I tried to rearrange it so that the documentation and hooks
> > go before stuff that needs the hooks, and before Kconfig enabler. If
> > it looks reasonably good, I'll split it into smaller pieces.
> 
> James had a number of objections to my original patch; you can read 
> them here:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2008-March/016849.html
> 
> I haven't had time yet to work on an improved version.

Ok, I see, "its done at the wrong level" sounds pretty serious.

First the general comments/questions:

#
#1. It's done at the wrong level: suspend "device" is actually a target
#function.  There's no way on a multi-lun device we want to keep the
#flags and last_busy anywhere but in the target

So... if there's one device with Lun0==cdrom1 and Lun1==cdrom2, it is a
single target, and we want to keep flags/last busy common to all that?

What is good data structure to add? I see scsi_tgt*.h, but it is very
short, and there does not seem to be good structure to hook into.

#2. As you say in the comment, the thing we're trying to power down is
#the link.  In most SCSI implementations, the link has a rather complex
#relationship to the target, what we want to do in
#periodic_autosuspend_scan() is run over the devices on each link, and
#if
#they're not busy suspend the link?  What's probably needed is a set of
#adjunct helpers for the transport classes to do this.

So the host suspend/resume stuff should go into struct
scsi_transport_template?

#3. The link power down is much faster than device spin down ... in
#your
#patch these two things seem to be coupled ... we really need to keep
#them separate.
#

ACK.

#4. The entanglement with error handling is incredibly problematic
#(since
#eh is a nastily complex state machine in its own right).  What do
#transports that use eh_strategy_handler do about all of this?

/me scared...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
