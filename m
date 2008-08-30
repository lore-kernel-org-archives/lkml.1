Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYH3DQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYH3DQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYH3DQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:16:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbYH3DQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:16:28 -0400
Date: Fri, 29 Aug 2008 20:15:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808292010260.5010@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com> <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Linus Torvalds wrote:
> 
> and while I still haven't actually tested it, it looks sane and compiles 
> to code that also looks sane.

.. and it even works (apart from a missing '\n' for the expansion report 
;).

I tested it with the appended silly test-case, and it shows

	...
	 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
	 BIOS-e820: 0000000100000000 - 0000000160000000 (usable)
	Expanded resource Kernel dummy due to conflict with Kernel code
	Expanded resource Kernel dummy due to conflict with Kernel data
	last_pfn = 0x160000 max_arch_pfn = 0x3ffffffff
	x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
	...

and /proc/iomem shows

	...
	00100000-9cf64fff : System RAM
	  00200000-006ea27f : Kernel dummy
	    00200000-00561f37 : Kernel code
	    00561f38-006ea27f : Kernel data
	  00777000-007d6cc7 : Kernel bss
	...

so it correctly expanded that "Kernel dummy" resource to cover the 
resources it had clashed with.

And no, it's not perfect. We certainly _could_ split things instead. But I 
hope that odd "e820 resources were bogus" case almost never would actually 
trigger in practice, and the expansion case is not only simpler, it's also 
slightly more robust in the sense that a single big resource is likely to 
fit the things we need than multiple smaller resources that have been 
chopped up.

		Linus

--- dummy test patch for the 'insert-resource-expand-to-fit' thing ---
 arch/x86/kernel/setup.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 362d4e7..6265a38 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -578,6 +578,14 @@ static struct x86_quirks default_x86_quirks __initdata;
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
+static struct resource dummy_resource = {
+	.name	= "Kernel dummy",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -665,6 +673,9 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+	dummy_resource.start = code_resource.end - 1024;
+	dummy_resource.end = data_resource.start + 1024;
+
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
@@ -704,6 +715,8 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	insert_resource_expand_to_fit(&iomem_resource, &dummy_resource);
+
 	if (efi_enabled)
 		efi_init();
 
