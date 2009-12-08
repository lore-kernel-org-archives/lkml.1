Return-Path: <linux-kernel-owner+w=401wt.eu-S966187AbZLHVI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966187AbZLHVI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966177AbZLHVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:08:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966176AbZLHVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:08:21 -0500
Date: Tue, 8 Dec 2009 13:08:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912081508220.3046-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912081304070.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912081508220.3046-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
> 
> That's not the way it should be done.  Linus had children taking their
> parents' locks during suspend, which is simple but leads to
> difficulties.

No it doesn't. Name them.

> Instead, the PM core should do a down_write() on each device before
> starting the device's async suspend routine, and an up_write() when the
> routine finishes.

No you should NOT do that. If you do that, you serialize the suspend 
incorrectly and much too early. IOW, think a topology like this:

	a -> b -> c
	  \
	   > d -> e

where you'd want to suspend 'c' and 'e' asynchronously.  If we do a 
'down-write()' on b, then we'll delay until 'c' has suspended, an if we 
have ordered the nodes in the obvious depth-first order, we'll walk the PM 
device list in the order:

	c b e d a

and now we'll serialize on 'b', waiting for 'c' to suspend. Which we do 
_not_ want to do, because the whole point was to suspend 'c' and 'e' 
together.

> Parents should, at the start of their async routine,
> do down_read() on each of their children plus whatever other devices
> they need to wait for.  The core can do the waiting for children part 
> and the driver's suspend routine can handle any other waiting.

Why?

That just complicates things. Compare to my simple locking scheme I've 
quoted several times. 

		Linus
