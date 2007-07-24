Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXGXRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXGXRkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbXGXRkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:40:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57424 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbXGXRkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:40:08 -0400
Message-ID: <46A63964.7000900@garzik.org>
Date: Tue, 24 Jul 2007 13:39:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory addresses
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>  <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in>  <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org> <1185270544.5439.252.camel@localhost.localdomain> <alpine.LFD.0.999.0707241017440.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241017440.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> And before we remove that "volatile", we'd better make damn sure that 
> there isn't any driver that does
> 
> 	/* Wait for the command queue to be cleared by DMA */
> 	while (test_bit(...))
> 		;
> 
> or similar.
> 
> Yes, it's annoying, but this is a scary and subtle area. And we sadly 
> _have_ had code that does things like that.


I certainly cannot speak for all the grotty drivers out there, but I've 
never ever seen anything like the above.  I would consider anyone using 
kernel bit operations on DMA memory to be more than a little crazy.  But 
that's just me :)

Usually you will see

	while (1) {
		rmb();
		if (software_index == hardware_index_in_DMA_memory)
			break;
		
		... handle a unit of work ...
	}

Though ISTR being told that even rmb() was not sufficient in all cases 
[nonetheless, that's what I use in net and SATA drivers and email 
recommendations, and people seem happy]

	Jeff


