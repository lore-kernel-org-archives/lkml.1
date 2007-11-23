Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXKWBHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXKWBHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXKWBHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:07:31 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56479 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWBHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:07:30 -0500
Date: Thu, 22 Nov 2007 19:07:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Use of mutex in interrupt context flawed/impossible, need advice.
In-reply-to: <fa.DDwTo7jhtvU2nkv268RloCrwiwc@ifi.uio.no>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <474627CC.10201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.DDwTo7jhtvU2nkv268RloCrwiwc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Hello,
> 
> 
> I'm converting an out-of-tree (*1) driver from binary semaphore to mutex.
> 
> Userspace updates a look-up-table using write(). The driver tries to
> write this LUT to the FPGA in the (video frame) interrupt handler. It
> is important that the LUT is consistent and thus changed atomically.
> Note that it is not important that the LUT is updated each interrupt.
> 
> The current approach is to try-down()ing a binary semaphore in
> interrupt context, and write the LUT to the FPGA if the semaphore was
> down()ed, do nothing else.
> The write() down()s the semaphore as well before updating the
> in-driver-copy of the LUT, then up()s it again.
> 
> I understand this design is not clean (*2), and not even possible with
> mutexes, as mutex_trylock() is not interrupt safe.
> 
> My current approach would be to have userspace write into a shadow
> copy, and use a spinlock to update the live copy. The interrupt then
> would try a spinlock.

Unless this update into the FPGA takes a significant amount of time, I 
wouldn't bother with that complexity - just do spin_lock_irq/irqsave on 
that spinlock.

Using a trylock for this rather sucks since the behavior is entirely 
non-deterministic. It could take a really long time in some cases for 
the trylock to ever succeed.

> 
> My feeling is that we have a  valid use of mutex_trylock() in
> interrupt context; "i.e. update LUT if we can do so consistently and
> in time, or not at all".
> 
> I would like to know why this is not so, and if someone has a cleaner
> proposal than the "try spinlock" approach?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

