Return-Path: <linux-kernel-owner+w=401wt.eu-S964875AbXBOCpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbXBOCpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964876AbXBOCpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:45:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26086 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbXBOCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:45:23 -0500
In-Reply-To: <20070213142010.GA638@elte.hu>
References: <20070213142010.GA638@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CEF9B4DA-6881-457D-9447-F263A8F81DA2@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Date: Wed, 14 Feb 2007 18:44:10 -0800
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm finally back from my travel and conference hiatus.. you guys have  
been busy! :)

On Feb 13, 2007, at 6:20 AM, Ingo Molnar wrote:

> I'm pleased to announce the first release of the "Syslet" kernel  
> feature
> and kernel subsystem, which provides generic asynchrous system call
> support:
>
>    http://redhat.com/~mingo/syslet-patches/

In general, I really like the look of this.

I think I'm convinced that your strong preference to do this with  
full kernel threads (1:1 task_struct -> thread_info/stack  
relationship) is the right thing to do.  The fibrils fell on the side  
of risking bugs by sharing task_structs amongst stacks executing  
kernel paths.  This, correct me if I'm wrong, falls on the side of  
risking behavioural quirks stemming from task_struct references that  
we happen to have not enabled sharing of yet.

I have strong hopes that we won't actually *care* about the  
behavioural differences we get from having individual task structs  
(which share the important things!) between syscall handlers.  The  
*only* seemingly significant case I've managed to find, the IO  
scheduler priority and context fields, is easy enough to fix up.   
Jens and I have been talking about that.  It's been bugging him for  
other reasons.

So, thanks, nice work.  I'm going to focus on finding out if its  
feasible for The Database to use this instead of the current iocb  
mechanics.  I'm optimistic.

> Syslets are small, simple, lightweight programs (consisting of
> system-calls, 'atoms')

I will admit, though, that I'm not at all convinced that we need  
this.  Adding a system call for addition (just addition?  how far do  
we go?!) sure feels like a warning sign to me that we're heading down  
a slippery slope.  I would rather we started with an obviously  
minimal syscall which just takes an array of calls and args and  
executes them unconditionally.

But its existance doesn't stop the use case I care about.  So it's  
hard to get *too* worked up about it.

> Comments, suggestions, reports are welcome!

For what it's worth, it looks like 'x86-optimized-copy_uatom.patch'  
got some hunks that should have been in 'x86-optimized- 
sys_umem_add.patch'.

- z
