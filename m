Return-Path: <linux-kernel-owner+w=401wt.eu-S966018AbZLHUQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966018AbZLHUQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966003AbZLHUQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:16:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57991 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965995AbZLHUQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:16:38 -0500
Date: Tue, 8 Dec 2009 15:16:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <200912082044.52098.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912081508220.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:

> Suppose we use rwsem and during suspend each child uses a down_read() on a
> parent and then the parent uses down_write() on itself.  What if, whatever the
> reason, the parent is a bit early and does the down_write() before one of the
> children has a chance to do the down_read()?  Aren't we toast?
> 
> Do we need any direct protection against that or does it just work itself out
> in a way I just don't see right now?

That's not the way it should be done.  Linus had children taking their
parents' locks during suspend, which is simple but leads to
difficulties.

Instead, the PM core should do a down_write() on each device before
starting the device's async suspend routine, and an up_write() when the
routine finishes.  Parents should, at the start of their async routine,
do down_read() on each of their children plus whatever other devices
they need to wait for.  The core can do the waiting for children part 
and the driver's suspend routine can handle any other waiting.

This is a little more awkward because it requires the parent to iterate 
through its children.  But it does solve the off-tree dependency 
problem for suspends.

Alan Stern

