Return-Path: <linux-kernel-owner+w=401wt.eu-S1764870AbXLRSXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764870AbXLRSXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763185AbXLRSXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:23:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764467AbXLRSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:23:21 -0500
Date: Tue, 18 Dec 2007 10:21:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <47680489.6040809@redhat.com>
Message-ID: <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Chuck Ebbert wrote:
> > 
> > So why do you want them to be close, anyway? 
> 
> Because otherwise some video adapters with 256MB of memory end up with their
> resources allocated above 4GB, and that doesn't work very well.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=425794#c0

That bugzilla entry doesn't even have a dmesg output or anything like 
that. I'd really like to see what the 

The fact is, that patch is not safe. We very much _want_ to make the PCI 
region allocator use a window that is in the *middle* of the gap, and not 
close to either end of the gap, and the code literally tries to make the 
default start of the PCI allocation gap start be about 1/16th of the 
actual gap size in question, so that we don't hit BIOS allocations that 
it didn't tell us about by mistake.

But without dmesg and lspci output to see what the actual allocations are, 
there's no way to even _guess_ at whether there is a correct fix or not, 
just the fix that totally misses the point of having any rounding-up at 
all.

That patch might as well just do

	pci_mem_start = gapstart;

and get rid of all that rounding code entirely, since the patch just 
assumes that it's safe to use memory after gapstart (which is known to not 
be true, and is the whole and only reason for that code in the first 
place: BIOSes *invariably* get resource allocation wrong, and forget to 
tell us about some resource they set up).

Now, it's entirely possible that the only reasonable end result is that we 
do have to avoid rounding up that far, but I definitely want to see what 
the actual resource situation is - that patch is *not* obviously correct, 
and it definitely breaks the whole point of the code. 

The *other* patch in the bugzilla entry seems more correct, in that yes, 
we should make sure that we don't allocate resources over 4G if the 
resource won't fit. That said, I think that patch is wrong too: we should 
just fix pcibios_align_resource() to check that case for MEM resouces (the 
same way it already knows about the magic rules for IO resources).

So I'd suggest just fixing pcibios_align_resource() instead. Something 
like the appended might work (and then you could perhaps quirk it to 
always clear the PCI_BASE_ADDRESS_MEM_TYPE_64 thing for VGA controllers, 
although I really don't think the kernel is the right place to do that, 
and that would be an X server issue!).

NOTE! This patch is an independent issue of the whole "what window do we 
use to allocate new resources, and how do we align it" thing.

			Linus

---
 arch/x86/pci/i386.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 42ba0e2..abc642b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -70,6 +70,20 @@ pcibios_align_resource(void *data, struct resource *res,
 			start = (start + 0x3ff) & ~0x3ff;
 			res->start = start;
 		}
+	} else {
+		u64 max;
+		switch (res->flags & PCI_BASE_ADDRESS_MEM_MASK) {
+		case PCI_BASE_ADDRESS_MEM_TYPE_1M:
+			max = 0xfffff;
+			break;
+		case PCI_BASE_ADDRESS_MEM_TYPE_64:
+			max = -1;
+			break;
+		default:
+			max = 0xffffffff;
+		}
+		if (res->start > max)
+			res->start = res->end;
 	}
 }
 
