Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZLICf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZLICf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZLICfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:35:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41975 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755118AbZLICfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:35:53 -0500
Date: Tue, 8 Dec 2009 21:35:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081420220.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912082125410.26994-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> It's just that I think the "looping over children" is ugly, when I think 
> that by doing it the other way around you can make the code simpler and 
> only depend on the PM device list and a simple parent pointer access.

I agree that it is uglier.  The only advantage is in handling
asynchronous non-tree suspend dependencies, of which we probably won't
have very many.  In fact, I don't know of _any_ offhand.

Interestingly, this non-tree dependency problem does not affect resume.

> I also think that you are wrong that the above somehow protects against 
> non-topological dependencies. If the device you want to keep delay 
> yourself suspending for is after you in the list, the down_read() on that 
> may succeed simply because it hasn't even done its down_write() yet and 
> you got scheduled early.

You mean, if A comes before B in the list and A must suspend after B?  
Then A's down_read() on B _can't_ occur before B's down_write() on
itself.  The down_write() on B happens before the
list_for_each_entry_reverse() iteration reaches A; it even happens
before B's async task is launched.

> But I guess you could do that by walking the list twice (first to lock 
> them all, then to actually call the suspend function). That whole 
> two-phase thing, except the first phase _only_ locks, and doesn't do any 
> callbacks.

Not necessary.

Alan Stern

