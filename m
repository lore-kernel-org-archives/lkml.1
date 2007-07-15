Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXGOXIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXGOXIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXGOXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:08:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXGOXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:08:28 -0400
Message-ID: <469AA8D4.2070206@zytor.com>
Date: Sun, 15 Jul 2007 16:08:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jonathan Campbell <jon@nerdgrounds.com>
CC: linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com>
In-Reply-To: <469A8AED.7070207@nerdgrounds.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell wrote:
> I wrote a set of patches out of concern that even if you compile a 386
> kernel a lot of code irrelevent to legacy machines still remains. Things
> like the Pentium TSC register, DMI information, ESCD parsing, and the
> use of CPUID do not apply to these machines, but looking at System.map
> you can see they're still there.
> 
> Already with these patches I can compile a zImage kernel that is 450kb
> large (890kb decompressed) with a small initramfs payload, floppy and
> kernel module support, FPU emulation, that can successfully boot on an
> ancient 386 laptop with only 1MB of extended memory. Eventually what I'd
> like to have is the ability to compile a pure 386 kernel with all
> non-386 functions removed (and perhaps the same for 486 machines).
> 
> These patches were written against the vanilla 2.6.21.1 kernel. They
> will have no effect UNLESS you make menuconfig and explicitly enable
> them there.

These should all probably depend on EMBEDDED (which is the "allow
features to be disabled which would be dangerous for most people".)

CONFIG_X86_TSC, however, would be cleaner implemented by something like:

#ifdef CONFIG_X86_TSC
int disable_tsc;
#else
#define disable_tsc 1
#endif

... then gcc will optimize out the rest of the code.

The CPUID stuff hacks up the code quite a bt which makes it hard to
read.  Can you abstract any of that code so it doesn't get so ugly?

Stuff like:

+#ifndef CONFIG_X86_DONT_CPUID
 	if (cpu_has_fxsr) {
 		/*
 		 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
@@ -1177,6 +1178,7 @@
 		set_in_cr4(X86_CR4_OSXMMEXCPT);
 		printk("done.\n");
 	}
+#endif

... is much better handled by forcing the value of the cpu_has_* macros
to zero, in which case gcc optimizes out the if clause.  The current git
HEAD has handling of constant cpu_* going the other way, but it should
be easy enough to extend.

	-hpa
