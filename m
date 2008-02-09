Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYBINcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYBINcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYBINcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:32:09 -0500
Received: from psionic.psi5.com ([212.112.229.180]:1574 "EHLO
	psionic8.psi5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYBINcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:32:08 -0500
X-Greylist: delayed 2089 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Feb 2008 08:32:08 EST
Date: Sat, 9 Feb 2008 13:57:08 +0100
From: Simon Richter <Simon.Richter@hogyros.de>
To: linux-kernel@vger.kernel.org
Subject: non-blocking behaviour with multiple readers
Message-ID: <20080209125702.GA10739@honey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[please CC me, I'm not subscribed to the list]

I'm writing a driver for a pretty simple USB device, and most of what I
need I can see in similar drivers; right now I'm lifting a lot of code
from drivers/usb/class/usblp.c.

In the read routine, this driver gathers a few locks, then checks
whether data is present and in the non-blocking case returns -EAGAIN,
otherwise waits for data to become available.

In the case of multiple readers, acquiring the locks might however
block, so I'm not sure whether it'd be better to check for non-blocking
first, and acquire the locks with trylock in this case, returning
-EAGAIN in case we fail to acquire any.

The semantic difference seems to be minimal: I believe that it is
acceptable to return -EAGAIN from read even if a previous poll()
suggested that the fd was now readable. Blocking on a non-blocking
read() until other tasks reading from the same fd have left the kernel
seems more like an optimization to me, saving a few syscalls if the
other reader doesn't read all the bytes.

The obvious consistency problem with multiple unsynchronized readers
aside: is that optimization worth a (short) block inside a non-blocking
read?

   Simon
