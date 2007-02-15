Return-Path: <linux-kernel-owner+w=401wt.eu-S1161051AbXBOUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051AbXBOUN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161136AbXBOUN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:13:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXBOUN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:13:27 -0500
Date: Thu, 15 Feb 2007 12:07:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
 <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
 <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Linus Torvalds wrote:
> 
> So I think that a good implementation just does everything up-front, and 
> doesn't _need_ a user buffer that is live over longer periods, except for 
> the actual results. Exactly because the whole alloc/teardown is nasty.

Btw, this doesn't necessarily mean "not supporting multiple atoms at all".

I think the batching of async things is potentially a great idea. I think 
it's quite workable for "open+fstat" kind of things, and I agree that it 
can solve other things too (the "socket+bind+connect+sendmsg+rcv" kind of 
complex setup things).

But I suspect that if we just said:
 - we limit these atom sequences to just linear sequences of max "n" ops
 - we read them all in in a single go at startup

we actually avoid several nasty issues. Not just the memory allocation 
issue in user space (now it's perfectly ok to build up a sequence of ops 
in temporary memory and throw it away once it's been submitted), but also 
issues like the 32-bit vs 64-bit compatibility stuff (the compat handlers 
would just convert it when they do the initial copying, and then the 
actual run-time wouldn't care about user-level pointers having different 
sizes etc).

Would it make the interface less cool? Yeah. Would it limit it to just a 
few linked system calls (to avoid memory allocation issues in the kernel)? 
Yes again. But it would simplify a lot of the interface issues.

It would _also_ allow the "sys_aio_read()" function to build up its 
*own* set of atoms in kernel space to actually do the read, and there 
would be no impact of the actual run-time wanting to read stuff from user 
space. Again - it's actually the same issue as with the compat system 
call: by making the interfaces do things up-front rather than dynamically, 
it becomes more static, but also easier to do interface translations. You 
can translate into any arbitrary internal format _once_, and be done with 
it.

I dunno. 

		Linus
