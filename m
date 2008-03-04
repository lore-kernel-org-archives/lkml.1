Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYCDRul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYCDRul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbYCDRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:50:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34960 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757938AbYCDRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:50:09 -0500
Date: Tue, 4 Mar 2008 12:50:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <200803031359.38263.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803041245460.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, David Brownell wrote:

> Card insert/remove events can be system wake events though.  Which
> makes that restriction impractical.
> 
> I think hosts need to be able to call mmc_detect_change() as soon as
> they see a stable signal.  The MMC core can hold off handling that
> for a while, if it needs to wait until the code walking the device
> tree gets around to resuming that host.  It's a lot more natural to
> hold off such stuff one time there than in N host drivers; especially
> since the MMC core already has such hold-off code.

That's what ended up happening.  The workqueue used by
mmc_detect_change() was made freezable, so hosts could call the routine
at any time but it wouldn't do anything until the system sleep was
over.

A more flexible approach would avoid freezing the workqueue, and allow 
it to process card removals at any time.  But card insertions would be 
ignored if the mmc_host device was suspended; at resume time the core 
probes for changes that occurred during the sleep.

Alan Stern

