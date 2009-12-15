Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZLODJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZLODJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZLODJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:09:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759092AbZLODJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:09:51 -0500
Date: Mon, 14 Dec 2009 19:09:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>, Russ Dill <Russ.Dill@gmail.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912141827200.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912141902040.14385@localhost.localdomain>
References: <20091211212646.GB6624@kroah.com> <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain> <20091215005216.GA9309@kroah.com> <alpine.LFD.2.00.0912141658290.14385@localhost.localdomain> <alpine.LFD.2.00.0912141744360.14385@localhost.localdomain>
 <alpine.LFD.2.00.0912141827200.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Linus Torvalds wrote:
> 
> I'll double-check by reverting it from current -tip, but if you don't hear 
> anything different from me, you can assume that that double-check 
> succeeded and confirms that that commit really is the cause of my printer 
> no longer working.

Confirmed.

With that commit reverted, everything works fine again. So it's definitely 
a2582bd478c13c574d4c16ef1209d333f2a25935, although I have no idea _why_ it 
causes problems.

One thing I note is that it literally changed semantics, as per the 
comment in there. It used to be:

	This walks the driver device list and returns a pointer to the interface
	with the matching minor.

and after that it is

	This walks the bus device list and returns a pointer to the interface
	with the matching minor.

Notice the "driver device list" -> "bus device list" change.

Also notice that the minor number of my 'lp0' device is zero, so I could 
easily imagine that some device without a driver at all or whatever will 
have a zero there, and then it would return the wrong device entirely.

So I really think that commit is very suspect. Not matching against the 
driver that we passed in looks like some total screwup.

But I don't know the code or the use. I do know that reverting it fixes 
it.

		Linus
