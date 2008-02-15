Return-Path: <linux-kernel-owner+w=401wt.eu-S1763802AbYBOAlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763802AbYBOAlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYBOAlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:41:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYBOAlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:41:19 -0500
Date: Thu, 14 Feb 2008 16:40:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802141713.23461.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802141620380.6110@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <alpine.LFD.1.00.0802141456370.6110@woody.linux-foundation.org> <alpine.LFD.1.00.0802141503470.6110@woody.linux-foundation.org> <200802141713.23461.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
>
> That makes sense, but ...  there are BIOSes that actually list nested
> resources, e.g., http://bugzilla.kernel.org/show_bug.cgi?id=9514#c29 :
> 
>   [000000290 - 000000294]  Motherboard resources
>   [000000290 - 00000029F]  Motherboard resources

Heh. 

Not that I can really see us ever being confused by this in practice. 
Sure, we'd skip the second resource (because it's busy), but that's what 
we used to do before anyway, wasn't it? And even if we do, there's very 
little reason we'd ever actually try to reserve that 294-29f range.

In practice, the only resources we actually tend to end up really 
allocating tends to be things like Cardbus (or a whole PCI bus either due 
to hotplug or due to the BIOS not bothering), which tend want a big window 
for the bus window, so the "off-by-one" kinds of things wouldn't really 
worry me. Very seldom do we actually have small resources to worry about 
on a PC platform, since they all tend to be pre-allocated by the BIOS 
anyway.

That said, if we really want to handle this, we could certainly add a 
whole new ioresource flag bit that says "allow inserting resources into 
this", and we could set that bit not just for the PnP reservations 
themselves, but in PCI bus resources too.

Basically, there are two different ways of inserting a resource:

 - the "register this subresource" thing that "request_resource()" does, 
   which just works on the one given resource and honors the BUSY bit.

 - the "insert this resource into the tree" (insert_resource()) that 
   starts from the root and tries to find the right location. It honors 
   the BUSY bit too, but we could extend it to _only_ extend into 
   resources that allow it.

Here's the trivial patch to add the infrastructure for this, but I did 
*not* do the required "mark PCI bus resources as IORESOURCE_INSERT" etc 
(nor obviously the markers to make PnP resources themselves be marked as 
"insert").

But if you want to play around with it, I think this is at least 
*conceptually* a sane idea. Another way to see it is that a resource with 
the IORESOURCE_INSERT bit is "subdivisible", and then it's very obvious 
that a normal PCI device resource should not have it set: it is a "leaf" 
resources that can not be split up.

So the only way to populate "leaf" resources is by explicitly specifying 
them and doing a "request_resource()" on the resource, while the non-leaf 
IORESOURCE_INSERT resources can be populated from below with 
ioresrouce_insert().

Is this over-designed? I dunno. The _implementation_ on a resource level 
is certainly trivial.

Oh, and if it wasn't obvious: the patch is untested. It compiles. That's 
all I'm going to say about it, especially since without marking any 
resources with the new IORESOURCE_INSERT bit, the only thing you can do 
with "insert_resource()" is to insert into the root level (because we 
don't check the level we are passing into)

		Linus

---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 605d237..0a56410 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -45,6 +45,7 @@ struct resource_list {
 #define IORESOURCE_RANGELENGTH	0x00008000
 #define IORESOURCE_SHADOWABLE	0x00010000
 #define IORESOURCE_BUS_HAS_VGA	0x00080000
+#define IORESOURCE_INSERT	0x00100000	/* Allow insert_resource() */
 
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
diff --git a/kernel/resource.c b/kernel/resource.c
index 82aea81..d6da786 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -397,6 +397,8 @@ int insert_resource(struct resource *parent, struct resource *new)
 		result = -EBUSY;
 		if (first == parent)
 			goto out;
+		if (!(first->flags & IORESOURCE_INSERT))
+			goto out;
 
 		if ((first->start > new->start) || (first->end < new->end))
 			break;
