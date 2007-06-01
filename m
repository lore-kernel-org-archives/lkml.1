Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXFASQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXFASQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763268AbXFASQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:16:27 -0400
Received: from heineken.digium.com ([216.207.245.2]:47455 "EHLO
	heineken.digium.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763264AbXFASQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:16:26 -0400
X-Greylist: delayed 1756 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 14:16:26 EDT
Mime-Version: 1.0 (Apple Message framework v624)
Content-Transfer-Encoding: 7bit
Message-Id: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
To: linux-kernel <linux-kernel@vger.kernel.org>
From: Matthew Fredrickson <creslin@digium.com>
Subject: Device Driver Etiquette
Date: Fri, 1 Jun 2007 12:47:07 -0500
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I maintain a device driver that has been bitten by the transition to 4K 
stacks.  It is a T1/E1 line interface PCI card driver that is 
maintained outside of the kernel, although is used by a significant 
number of people.  The card has a part for doing echo cancellation, but 
it is accessed through a vendor API which (when we received it) was 
quite stack heavy.  It used the stack for a number of large data 
structures, although I have moved a great deal of them (particularly 
the larger ones) onto the heap instead of the stack.  Although this has 
reduced stack usage to the point where it is usable within 4K stacks, 
on some code paths, it can still use quite a bit of stack space (though 
under 4K) for local variables and a handful of small data structures.  
The problem is that in order to initialize and use the echo canceler, 
there is a firmware load portion which takes a noticeable period of 
time (~5-10 seconds).  That is done through this stack heavy portion of 
the code.

The problem that I am seeing is that while this card is loading its 
firmware, there are other device interrupts that occur, and if enough 
levels of interrupt happen, it overflows the stack.  Oh, the firmware 
load occurs in the context of an ioctl, FWIW.

My solution was to disable interrupts while the firmware was being 
loaded using local_irq_save/local_irq_restore, although that seems to 
be a naughty thing to do, especially given the long period of time it 
takes to load the firmware on the card.

My question is this: is there a way to either work around the problem I 
am seeing with the stack without recompiling the kernel with 8K stack 
size or without disabling irqs for such a long period of time (which I 
think is not a nice thing to do either) OR is it acceptable (although 
not nice) to simply fix it this way, by disabling irqs while it loads 
the firmware?

Thanks,
Matthew Fredrickson
Kernel Developer
Digium, Inc.

