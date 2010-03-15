Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab0COBCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:02:49 -0400
Received: from mail2.shareable.org ([80.68.89.115]:41479 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934806Ab0COBCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:02:47 -0400
Date: Mon, 15 Mar 2010 01:02:39 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dave b <db.pub.mail@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100315010238.GJ6491@shareable.org>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> <19346.6765.457769.167118@pilspetsen.it.uu.se> <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com> <20100311133353.GC25011@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311133353.GC25011@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Sat, Mar 06, 2010 at 09:24:49PM +1100, dave b wrote:
> > I had already reported it to debian -
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=572653
> > 
> > I have cc'ed linux-arm-kernel into this email.
> 
> I think most of the points have already been convered, but just for
> completeness,
> 
> What is the history of the hardware you're running these builds on?
> Has it proven itself on previous kernel versions running much the same
> tests?
> 
> Another point to consider: how are you running the compiler - is it
> over NFS from a PC?
> 
> The reason I ask is that you can suffer from very weird corruption
> issues - I have a nice illustration of one which takes a copy of 1GB
> worth of data each day, and every once in a while, bytes 8-15 of a
> naturally aligned 16 byte block in the data become corrupted somewhere
> between the network and disk.  The probability of corruption happening
> is around 0.0000001%, but it still happens... and that makes it
> extremely difficult to track down.

We had annoying corruption in some totally different hardware a few
years ago, but not quite as rare as that.

It was only on ext3 filesystems, not vfat as was supplied with the
SDK.  It turned out that the chip's IDE driver started DMA like this:

    1. Write to DMA address and count registers.
    2. Flush D-cache.
    3. Write start DMA command to DMA controller.

We found step 1 preloaded the first 128 bytes into a chip FIFO
(undocumented of course), although the DMA didn't start until step 3.
Swapping steps 1 and 2 fixed it.

The chip supplier hadn't encountered corruption because the code path
from vfat down always had the side effect of flushing those cachelines.

With the cache handling complexity that some ARMs now seem to require,
I wonder if you're seeing a similarly missed cache flush?  Adding
cache flushes at strategic points throughout the kernel was very
helpful in narrowing down the one we saw.

-- Jamie
