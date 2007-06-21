Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXFUF1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXFUF1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXFUF1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:27:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXFUF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:27:07 -0400
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0706201649060.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
	 <1182381667.2701.7.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.98.0706201649060.3593@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 20 Jun 2007 22:23:21 -0700
Message-Id: <1182403401.2863.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 16:50 -0700, Linus Torvalds wrote:
> 
> On Wed, 20 Jun 2007, Arjan van de Ven wrote:
> > 
> > the real fix would be something like this instead:
> 
> If people can test this, and confirm it works, please send a patch that 
> not only does this ad undoes the Kconfig language.  It looks like the 
> right thing to do, but I won't touch it without somebody who actually 
> tested these combinarions sending in a patch.

Hi,

I have tested this on x86_64, and without the config language, the
original oopses, while with the patch below it works fine (as expected).
I've not been able to test the i386 one (no 32 bit testboxes since 2
years) but the change is even simpler there, just an ifdef around the
entire kernel text marking.



Do not mark the kernel text read only if KPROBES is in the kernel;
kprobes needs to hot-patch the kernel text to insert it's
instrumentation. In this case, only mark the .rodata segment as read
only.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

--- linux-2.6.22-rc5/arch/i386/Kconfig.debug.org	2007-06-20 22:20:30.000000000 -0700
+++ linux-2.6.22-rc5/arch/i386/Kconfig.debug	2007-06-20 22:20:55.000000000 -0700
@@ -49,7 +49,6 @@ config DEBUG_PAGEALLOC
 config DEBUG_RODATA
 	bool "Write protect kernel read-only data structures"
 	depends on DEBUG_KERNEL
-	depends on !KPROBES # temporary for 2.6.22
 	help
 	  Mark the kernel read-only data as write-protected in the pagetables,
 	  in order to catch accidental (and incorrect) writes to such const
--- linux-2.6.22-rc5/arch/x86_64/Kconfig.debug.org	2007-06-20 22:20:28.000000000 -0700
+++ linux-2.6.22-rc5/arch/x86_64/Kconfig.debug	2007-06-20 22:20:44.000000000 -0700
@@ -9,7 +9,6 @@ source "lib/Kconfig.debug"
 config DEBUG_RODATA
        bool "Write protect kernel read-only data structures"
        depends on DEBUG_KERNEL
-       depends on !KPROBES # temporary for 2.6.22
        help
 	 Mark the kernel read-only data as write-protected in the pagetables,
 	 in order to catch accidental (and incorrect) writes to such const data.
--- linux-2.6.22-rc5/arch/i386/mm/init.c.org	2007-06-20 22:18:40.000000000 -0700
+++ linux-2.6.22-rc5/arch/i386/mm/init.c	2007-06-20 22:19:45.000000000 -0700
@@ -799,6 +799,7 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
+#ifndef CONFIG_KPROBES
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
 	if (num_possible_cpus() <= 1)
@@ -808,7 +809,7 @@ void mark_rodata_ro(void)
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
 	}
-
+#endif
 	start += size;
 	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
--- linux-2.6.22-rc5/arch/x86_64/mm/init.c.org	2007-06-20 21:44:15.000000000 -0700
+++ linux-2.6.22-rc5/arch/x86_64/mm/init.c	2007-06-20 22:17:45.000000000 -0700
@@ -605,6 +605,11 @@ void mark_rodata_ro(void)
 	if (num_possible_cpus() > 1)
 		start = (unsigned long)_etext;
 #endif
+
+#ifdef CONFIG_KPROBES
+	start = (unsigned long)__start_rodata;
+#endif
+	
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
 	end &= PAGE_MASK;

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

