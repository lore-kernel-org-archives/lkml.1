Return-Path: <linux-kernel-owner+w=401wt.eu-S1750950AbXE3Epd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbXE3Epd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXE3EpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:45:19 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXE3EpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:45:18 -0400
Date: Tue, 29 May 2007 21:45:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
In-Reply-To: <465CF794.1070406@shaw.ca>
Message-ID: <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
References: <465CF794.1070406@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Robert Hancock wrote:
>
> This path adds validation of the MMCONFIG table against the ACPI reserved
> motherboard resources.

Please fix the formatting of your code.

"for" and "if" are not functions, and they have a space before the 
parenthesis.

And pretty much every single conditional in this patch is spread out over 
two or more lines and has at least three different indentations. There's 
something wrong here. Code can't look this bad and still be fine. Some of 
this looks like random whitespace noise:

+               if(is_acpi_reserved(cfg->address,
+                                   cfg->address + size - 1))
+                       printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
+                               "in ACPI motherboard resources\n",
+                               cfg->address);
+               else {

That's just horrid. Please try to make the code _look_ nicer.

For example, just making "is_acpi_reserved()" take a start/len thing 
instead, would allow you to at least do

	if (is_acpi_reserved(cfg->address, size)) {
		printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
			"in ACPI motherboard resources\n",
			cfg->address);
	} else {
		...

(and has the braces rigth too - don't pair an unbraced "if ()" with a 
braced "else" statement), and that together with making the body of the 
for-loop a separate function would possibly make that code read a lot 
better.

Same goes for this thing:

+                       if((pci_probe & PCI_PROBE_CONF1) &&
+                          e820_all_mapped(cfg->address,
+                                          cfg->address + size - 1,
+                                          E820_RESERVED))
+                               printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved in E820\n",
+                                       cfg->address);
+                       else
+                               goto reject;

there really is *not* a highly coveted prize for having the most different 
indentation in the fewest possible lines of code!

Yeah, I realize that maybe this is nit-picking, but trying to read this 
patch really does make you go blind. It violates so many coding standards 
that it's almost impossible to read the code itself. It's made worse by 
the fact that you then also used Thunderbird to send the patch, and had it 
set for

	Content-type: text/plain; charset=ISO-8859-1; format=flowed

where that "format=flowed" means that basically no mail-client will be 
able to read it sanely (because a lot of them will re-flow the text), and 
you have to save it to a file before you can even comment on it.

Gaah. See

	http://mbligh.org/linuxdocs/Email/Clients/Thunderbird

where the most important sentence is "Thunderbird is written by aged whore 
monkeys stoned on crack". But it also talks about how to disable that 
idiotic format=flowed for patches, and how to make sure it's not wrapping.

But as mentioned, your patch itself had some whitespace issues even aside 
from the regular Thunderbird breakage.

		Linus
