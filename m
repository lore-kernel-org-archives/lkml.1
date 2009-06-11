Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZFKQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZFKQtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZFKQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:49:08 -0400
Received: from fmailhost06.isp.att.net ([207.115.11.56]:60556 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbZFKQtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:49:08 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A313581.3050405@lwfinger.net>
Date: Thu, 11 Jun 2009 11:49:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906110941520.29827@gentwo.org>  <1244728824.17483.51.camel@penberg-laptop>  <alpine.DEB.1.10.0906111021340.29827@gentwo.org>  <1244733119.17483.56.camel@penberg-laptop>  <alpine.DEB.1.10.0906111118350.14020@gentwo.org> <1244734086.17483.59.camel@penberg-laptop> <alpine.DEB.1.10.0906111140080.24376@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0906111140080.24376@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 11 Jun 2009, Pekka Enberg wrote:
> 
>> My main point is that a lot of _testers_ will probably enable all SLUB
>> debugging by default because we encourage them to and it's pretty bad
>> that we end up causing order 1 allocations and oom conditions.
> 
> Other test methods (like PAGE_ALLOC debugging) also have significant side
> effects.
> 
>> So I still think we need to fix _at minimum_ the kmalloc-4096 case
>> (assuming Larry won't hit the same problem still). I see you're not
>> happy with my patch so any suggestions how to handle that?
> 
> Add a warning to Kconfig that the higher order page allocations may
> increase with debugging on for caches with object sizes near or equal to
> PAGE_SIZE?
> 
> Its good to run with full debugging on for even the 4k sized caches.
> Otherwise we wont be catching overruns there. But the debugging can cause
> some side effects.

This is obviously an extreme corner case. Both Ubuntu and openSUSE
distribute kernels with SLAB enabled, thus the bulk of users will
never get into this situation. In addition, I'm not aware of any other
testers that have reported this condition.

If the Kconfig warning is too strong, then even the testers might not
turn SLUB debugging on, and you lose people like me. Having a printk
that indicates that debugging was turned off for a particular request
would have been useful for my current test as we would then know that
the fix might have saved an oom condition, but the total number of
such printks should be limited as I wouldn't want my logs polluted too
much.

Is it easy to test the number of available O(1) fragments when
debugging would increase the minimum from 0 to 1, and only turn off
debugging if the available number is small?

After 23 hours of getting my system to a "steady state" condition, I
am currently running the following:

1. Two concurrent -j8 kernel builds with the sources on an NFS mounted
volume with b43 as the network device.
2. A simultaneous flood ping over the network.
3. A dump of the DMA32 line of /proc/buddyinfo every 5 seconds. The
number of O(1) fragments has seldom gotten below 1000.

Larry
