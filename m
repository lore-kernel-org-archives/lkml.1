Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYHaDDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYHaDDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 23:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYHaDCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 23:02:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbYHaDCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 23:02:50 -0400
Date: Sat, 30 Aug 2008 20:00:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jordan Crouse <jordan.crouse@amd.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808301750w6655bbek557e6a23b8036654@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808301949100.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>  <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>  <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
  <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>  <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>  <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>  <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>
  <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>  <86802c440808301727k3e86c816j323eca0fb5e3f4fc@mail.gmail.com> <86802c440808301750w6655bbek557e6a23b8036654@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Yinghai Lu wrote:
> >
> >                /* Don't touch classless devices or host bridges or ioapics.  */
> >                if (class == PCI_CLASS_NOT_DEFINED ||
> >                    class == PCI_CLASS_BRIDGE_HOST)
> >                        continue;
> >
> >
> > it skips the host bridge...
> 
> what's story for not touching host bridges?

Ahh. Exactly because of things like this. The hist bridge BAR's are often 
special.

That code comes from almost four years ago, the commit message was:

  Author: Maciej W. Rozycki <macro@mips.com>
  Date:   Thu Dec 16 21:44:31 2004 -0800

    [PATCH] PCI: Don't touch BARs of host bridges
    
     BARs of host bridges often have special meaning and AFAIK are best left
    to be setup by the firmware or system-specific startup code and kept
    intact by the generic resource handler.  For example a couple of host
    bridges used for MIPS processors interpret BARs as target-mode decoders
    for accessing host memory by PCI masters (which is quite reasonable).
    For them it's desirable to keep their decoded address range overlapping
    with the host RAM for simplicity if nothing else (I can imagine running
    out of address space with lots of memory and 32-bit PCI with no DAC
    support in the participating devices).
    
     This is already the case with the i386 and ppc platform-specific PCI
    resource allocators.  Please consider the following change for the generic
    allocator.  Currently we have a pile of hacks implemented for host bridges
    to be left untouched and I'd be pleased to remove them.
    
    From: "Maciej W. Rozycki" <macro@mips.com>
    Signed-off-by: Greg Kroah-Hartman <greg@kroah.com>

and we've had other things where host bridges are special (ie iirc, if you 
turn off PCI_COMMAND_MEM from a host bridge, it stops access to real RAM 
from the CPU for some bridges - so you must never turn those things off or 
you get a dead system).

(But at least Intel host bridges will just ignore writes to the CMD 
register, I think - you cannot turn MEM off).

			Linus
