Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYDHCNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYDHCNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYDHCNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:13:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3269 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752987AbYDHCNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:13:15 -0400
Date: Mon, 7 Apr 2008 22:13:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Mark Lord <lkml@rtr.ca>, <pavel@suse.cz>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jikos@suse.cz>, <gregkh@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
In-Reply-To: <200804071637.16864.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0804072201280.5103-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, David Brownell wrote:

> Third, if it *does* call end_unlink_async(), it can retriger
> the timer when it needs to do another unlink.  Only when the
> HC is halted (HC_STATE_HALT) is that logic bypassed, scrubbing
> several endpoints at once.  (And a minor fourth point, direct
> calls to end_unlink_async leaves the IAA IRQ machinery active.)
> 
> I think your fix handles the "one pending unlink" case, but
> not the more general "N pending unlinks" ...

Sounds right.  That test at the end of start_unlink_async() should be
changed to !RUNNING instead of HALT.

To help prevent unwanted recursion, I wrote a patch some time ago that
would batch up multiple unlinks.  (The idea was to keep track of which
entries were added to the reclaim queue before the current IAA cycle
got started, and handle them all at one stroke when the current cycle
ends.)  That patch is a bit out-of-date now, but it shouldn't be too
hard to bring it up to speed.

> When the timer would be retriggered, to finish additional unlinks,
> it does matter.  A complete fix for this would (a) disable the IAA
> watchdog timer later, once it can never be retriggered again, and
> (b) make end_unlink_async handle the multiple-unlinks case when the
> HC is suspended, including not retriggering the watchdog.

Agreed.  If the code does (a) after (b) then end_unlink_async doesn't 
need to avoid retriggering the watchdog.

Alan Stern

