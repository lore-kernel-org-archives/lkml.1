Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZLRPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZLRPqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZLRPqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:46:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbZLRPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:46:01 -0500
Date: Fri, 18 Dec 2009 07:45:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Hounschell <markh@compro.net>
cc: Mark Hounschell <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org, fdutils@fdutils.linux.lu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B2B9F9F.7040802@compro.net>
Message-ID: <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu>
 <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff!
 .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu> <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain> <4B2AAC87.5000703@knaff.lu> <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>
 <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com> <4B2B5F86.1090403@cfl.rr.com> <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain> <4B2B9F9F.7040802@compro.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Mark Hounschell wrote:
> 
> Yep, thanks. I'm past that now. But haven't done a bisect [good|bad] on the
> results of that one yet. Did you see Alain's email response to my bisect
> progress report to him?
> 
> I'm still at a loss as to how to proceed?

Ahh, the HPET issue.

That one is actually very interesting information, because we've had 
problems with HPET before. But what I would suggest is to try to continue 
to bisect with HPET enabled (to see the problem), and the commit that you 
couldn't even boot with HPET enabled you should not count as good or bad 
because you just don't know.

You can do "git bisect skip" to make git know that some particular commit 
is not a commit you can test, and you can also move away from a whole 
problematic region to another area by doing

	git bisect visualize

to bring up a graphical gitk view of what all you have left to bisect, 
pick a good point (still _reasonably_ close to the middle) there, and do

	git reset --hard <the-point-you-want-to-test>

and try that kernel instead of the one git bisect suggested.

But this floppy DMA inconsistency being somehow HPET-related is 
interestign in itself. One thing that HPET does si to obviously change how 
we read the time - and what that can cause (totally indirectly) is that 
now we don't touch the southbridge with IO accesses nearly as much, 
because instead of going to the old 8253 PIT will touch the same legacy 
chip support that implements the floppy controller itself.

So it's entirely possible that the reason a non-HPET setup doesn't show 
this is that the accesses to the i8253 PIT part will "synchronize" the old 
floppy controller too, and hide some issue.

But still, I assume you had HPET enabled in 2.6.27, so it would be 
interesting to see exactly when the problem starts. 

		Linus
