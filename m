Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbYBTWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbYBTWXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYBTWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:23:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYBTWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:23:06 -0500
Date: Wed, 20 Feb 2008 14:22:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802201344.11643.jesse.barnes@intel.com>
Message-ID: <alpine.LFD.1.00.0802201355590.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Feb 2008, Jesse Barnes wrote:
> 
> Really, in the simple s3 case we still need early/late stuff?

Absolutely. 

Two big reasons:

 - debuggability

   I know we don't do this correctly right now, but I want to be able to 
   at least feel like we can some day actually do printk's etc through 99% 
   of the suspend/resume cycle. It's a *huge* thing for debugging problems 
   that happen in the wild, and one of the biggest issues is that we 
   currently usualyl just get a "the machine died" message when suspend or 
   resume doesn't work.

   Yes, doing printk's to the Intel management flash stuff can help a lot 
   here, and I want that too, but I'd really like to shut down consoles 
   individually rather than having the "big hammer" approach that shuts 
   them up entirely over the whole suspend/resume sequence (or not at all, 
   if you use "no_console_suspend").

   And I'd *really* like to do things like VGA-console shutdown in the 
   late phase (and resume early).

 - it's actually likely *much* simpler for some devices. 

   Simple devices (and that includes things like PCI bridges etc, but 
   also potentially USB host controllers etc) are things that can often be 
   trivially suspended - all the complexity is really not in the 
   controller itself, but beyond, in the bus that it actually drives.

   And the late-suspend/early-resume means that you don't have to worry 
   about things like interrupts happening while you're suspended. Yes, 
   putting the device into D3 will disable interrupts from that device too 
   (unless there are bugs), *BUT* you may be sharing an interrupt line, 
   and interrupts may be posted and delayed, so an earlier interrupt may 
   well be pending etc.

   suspending late and resuming early just avoids those issues entirely.

Sometimes these things interact. For example, firewire is certainly not 
trivial to suspend as a "subsystem" thing (ie all the devices behind the 
firewire bridge need to do magic things, like spinning down etc that 
obviously can not happen in the final "late" phase), but the firewire 
controller itself is likely trivial to suspend/resume and can easily be 
handled in the late/early routines. And guess what? It's also exactly what 
you want to happen in case you end up using the firewire RDMA as a debug 
aid.

IOW, you want that firewire controller (and the PCI bridges) working 
really early, so that if a problem does happen when you resume some more 
complex device (say, one of the graphics chips that need X to really come 
alive), you can use the firewire rdma to read out the kernel log buffer 
from memory.

> Well, it seems like we'll have to fix drivers in either case, and isn't a 
> kexec approach fundamentally more sound and simple, design-wise?  Rafael 
> pointed out some problems with properly setting wakeup states, but I think 
> that could be overcome...

I don't personally mind kexec at all, but on the other hand, I don't care 
about suspend-to-disk in the first place. I do know that some people 
really don't want it, and I suspect that they have valid reasons. Ranging 
from memory use to simply just performance. 

		Linus
