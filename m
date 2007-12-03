Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbXLCK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbXLCK1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLCK1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:27:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54300 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXLCK1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:27:17 -0500
Date: Mon, 3 Dec 2007 11:27:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203102715.GC28560@one.firstfloor.org>
References: <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203111520.33ed2139@astralstorm.puszkin.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly broken.

What should it do when the NFS server doesn't answer anymore or 
when the network to the SAN RAID array located a few hundred KM away develops 
some hickup?  Or just the SCSI driver decides to do lengthy error 
recovery  -- you could argue that is broken if it takes longer 
than 2 minutes, but in practice these things are hard to test
and to fix.

> Yes, that's exactly why the patch is needed - to find the bugs and fix

The way to find that would be to use source auditing, not break
perfectly fine error handling paths. Especially since this at least
traditionally hasn't been considered a bug, but a fundamental design
parameter of network/block/etc. file systems 

> CIFS and similar have to be fixed - it tends to lock the app
> using it, in unkillable state.

Actually that's not true. You can umount -f and then kill for at least
NFS and CIFS. Not sure it is true for the other network file systems
though.

You could in theory do TASK_KILLABLE for all block devices too (not 
a bad thing; I would love to have it). 

But it would be equivalent in work (has to patch all the same places with 
similar code) to Suparna's big old fs AIO retry
patchkit that never went forward because everyone was too worried
about excessive code impact. Maybe that has changed, maybe not ... 

And even then you would need to check all possible error handling
paths (scsi_error and low level drivers at least) that they all 
finish in less than two minutes.

> > > wild guesses. Only one way to get the real false positive percentage.
> > 
> > Yes let's break things first instead of looking at the implications closely.
> 
> Throwing _rare_ stack traces is not breakage. 120s task_uninterruptible

Sorry that's total bogus. Throwing a stack trace is the kernel
equivalent of sending S.O.S. and worrying the user significantly,
taxing reporting resources etc.  and in the interest of saving
everybody trouble it should only do that when it is really
sure it is truly broken. 

> in the usual case (no errors) is already broken - there are no sane
> loads that can invoke that IMO.

You are wrong on that.

-Andi

