Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXLTUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXLTUE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbXLTUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:04:16 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33884 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXLTUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:04:15 -0500
Date: Thu, 20 Dec 2007 13:04:14 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220200413.GI29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AC48D.6000103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AC48D.6000103@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 02:37:49PM -0500, Tony Camuso wrote:
> Matthew Wilcox wrote:
> 
> >Bad deduction.  What's happening is that the write to the BAR is causing
> >it to overlap the decode for mmconfig space.  So the mmconfig write to
> >set the BAR back never gets through.
> >
> >I have a different idea to fix this problem.  Instead of writing
> >0xffffffff, we could look for an unused bit of space in the E820 map and
> >write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
> >overlap, and we could find its size using MMCONFIG.
> >
> Let me see if I understand this correctly.
> 
> Writing this BAR with 0xffffffff causes it to decode all further mmconfig
> references based at addr 0xfxxxxxxx as its own?
> 
> If I've got that right, then why don't any of the other BARs do that? Is
> it because this one's a 64-bit BAR?

Here's how BARs work ... when you write 0xffffffff to the BAR, it
ignores all the set bits that are less than the size of the BAR.  So,
assuming this is a 256MB BAR (like my G33 is), what ends up written to
this BAR is 0xf0000000.  Now, because this is graphics, apparently it's
special and embedded in the chipset, even though it looks like it's a
PCI device.  So it actually gets priority over MMCONFIG which is also
mapped to 0xf0000000.

For your case of a 64-bit BAR, you could write 0xffffffff to the high
32-bits first, then write to the low 32-bits, then reset the low, then
high bits, and you'd avoid the problem.  But the G33 has a 32-bit BAR
with the same problem, so it won't work for that case.

BARs that are behind bridges don't have this problem (they can't decode
memory accesses that aren't forwarded to them).  BARs on devices which
have memory IO disabled also don't have theis problem, but disabling
devices has its problems (as does probing BARs for active devices anyway
...).

> AFIK, there are no devices out there that require 32-bits of address
> space, so using 0xdfffffff in the low register would certainly work.

The question is how large can 32-bit BARs get.  As we've seen, 256MB
exist, and are causing pain.  I can't imagine any PCI device
manufacturer thinks they can allocate 2GB of the low space, but we could
potentially mis-size a large BAR by not using 0xffffffff.

> Does anybody see that change as being within the purview of the patch-set
> I am proposing? Or is that another patch for another time?

I'm really not clear on the purpose of your patchset.  Was it all to
address this one problem?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
