Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXBNV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXBNV1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932639AbXBNV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:27:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXBNV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:27:31 -0500
Date: Wed, 14 Feb 2007 13:26:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070214210251.GA15025@elte.hu>
Message-ID: <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070214210251.GA15025@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Ingo Molnar wrote:
> 
> hm, there must be some misunderstanding here. That mlock is /only/ once 
> per the lifetime of the whole 'head' - i.e. per sys_async_register(). 
> (And you can even forget i ever did it - it's 5 lines of code to turn 
> the completion ring into a swappable entity.)

But the whole point is that the notion of a "register" is wrong in the 
first place. It's wrong because:

 - it assumes we are going to make these complex state machines (which I 
   don't believe for a second that a real program will do)

 - it assumes that we're going to make many async system calls that go 
   together (which breaks the whole notion of having different libraries 
   using this for their own internal reasons - they may not even *know* 
   about other libraries that _also_ do async IO for *their* reasons)

 - it fundamentally is based on a broken notion that everything would use 
   this "AIO atom" in the first place, WHICH WE KNOW IS INCORRECT, since 
   current users use "aio_read()" that simply doesn't have that and 
   doesn't build up any such data structures.

So please answer my questions. The problem wasn't the mlock(), even though 
that was just STUPID. The problem was much deeper. This is not a "prepare 
to do a lot of very boutique linked list operations" problem. This is a 
"people already use 'aio_read()' and want to extend on it" problem.

You didn't at all react to that fundamental issue: you have an overly 
complex and clever thing that doesn't actually *match* what people do.

			Linus
