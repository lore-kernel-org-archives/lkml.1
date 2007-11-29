Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbXK2XKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbXK2XKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbXK2XKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:10:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075AbXK2XJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:09:59 -0500
Date: Thu, 29 Nov 2007 15:09:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.0.9999.0711291505440.8458@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2007, Alan Stern wrote:
> 
> Yes indeed.  I wish I could point you to the exact patch containing the 
> fix, but the git software seems to have lost track of it (it's combined
> in with a large number of other patches with no obvious way to separate 
> it out).  It's also available in the various mailing list archives, but 
> I don't have a pointer to it and there's no reasonable way to search 
> for it.
> 
> The patch in question was written by Matthew Wilcox; it added code to 
> the SCSI async-scanning routines to utilize the scan_mutex.  IMO it 
> should have been applied to 2.6.23 but it wasn't.

Heh. It definitely hasn't gotten lost by "the git software". In fact, with 
the kinds of hints you already gave, git makes it really _trivial_ to find 
it.

Here's what you do:

	git log v2.6.23.. --author=Wilcox

and then just search for "scan_mutex", in the hope that Matthew wrote a 
nice commit message. And yes, he did, so in less than a blink you get:

	commit 6b7f123f378743d739377871c0cbfbaf28c7d25a
	Author: Matthew Wilcox <matthew@wil.cx>
	Date:   Tue Jun 26 15:18:51 2007 -0600
	
	    [SCSI] Fix async scanning double-add problems

	    Stress-testing and some thought has revealed some places where
	    asynchronous scanning needs some more attention to locking.
	
	     - Since async_scan is a bit, we need to hold the host_lock while
	       modifying it to prevent races against other CPUs modifying the word
	       that bit is in.  This is probably a theoretical race for the moment,
	       but other patches may change that.
	     - The async_scan bit means not only that this host is being scanned
	       asynchronously, but that all the devices attached to this host are not
	       yet added to sysfs.  So we must ensure that this bit is always in sync.
	       I've chosen to do this with the scan_mutex since it's already acquired
	       in most of the right places.
		...

which I assume is the commit you're talking about.

		Linus
