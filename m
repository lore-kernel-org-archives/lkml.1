Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXLTUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXLTUP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXLTUPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:15:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbXLTUPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:15:10 -0500
Message-ID: <476ACD44.7050607@redhat.com>
Date: Thu, 20 Dec 2007 15:15:00 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AC48D.6000103@redhat.com> <20071220200413.GI29690@parisc-linux.org>
In-Reply-To: <20071220200413.GI29690@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

> Here's how BARs work ... when you write 0xffffffff to the BAR, it
> ignores all the set bits that are less than the size of the BAR.  So,
> assuming this is a 256MB BAR (like my G33 is), what ends up written to
> this BAR is 0xf0000000.  Now, because this is graphics, apparently it's
> special and embedded in the chipset, even though it looks like it's a
> PCI device.  So it actually gets priority over MMCONFIG which is also
> mapped to 0xf0000000.
> 
> For your case of a 64-bit BAR, you could write 0xffffffff to the high
> 32-bits first, then write to the low 32-bits, then reset the low, then
> high bits, and you'd avoid the problem.  But the G33 has a 32-bit BAR
> with the same problem, so it won't work for that case.
> 
> BARs that are behind bridges don't have this problem (they can't decode
> memory accesses that aren't forwarded to them).  BARs on devices which
> have memory IO disabled also don't have theis problem, but disabling
> devices has its problems (as does probing BARs for active devices anyway
> ...).
>
Thanks for the detailed explanation.

 > The question is how large can 32-bit BARs get.  As we've seen, 256MB
 > exist, and are causing pain.  I can't imagine any PCI device
 > manufacturer thinks they can allocate 2GB of the low space, but we could
 > potentially mis-size a large BAR by not using 0xffffffff.
 >

Point well taken. Graphics devices understandably consume a lot of memory
space, and are likely to consume even more in the not-too-distant future.

> I'm really not clear on the purpose of your patchset.  Was it all to
> address this one problem?
> 

No. My patch-set does not address this problem at all, but rather the
larger problem of having mmconfig-unfriendly devices on buses that are
out of reach of the unreachable_devices() routine and bitmap.

This problem is one I encountered during my testing and mentioned in
my preamble as not being fixable by my patch-set.


