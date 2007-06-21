Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbXFUJUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbXFUJUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXFUJT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:19:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:55195 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXFUJT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:19:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Alternative fix for kprobes&DEBUG_RODATA was Re: [1/2] 2.6.22-rc5: known regressions with patches
Date: Thu, 21 Jun 2007 11:19:06 +0200
User-Agent: KMail/1.9.6
Cc: Dave Jones <davej@redhat.com>, Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <467543FA.60905@googlemail.com> <20070620230751.GA15092@redhat.com> <alpine.LFD.0.98.0706201647350.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706201647350.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211119.07754.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007 01:48:43 Linus Torvalds wrote:
> 
> On Wed, 20 Jun 2007, Dave Jones wrote:
> > 
> > Surely the fundamental disagreement is only due to DEBUG_RODATA
> > covering write-protection of both .text, and .rodata  ?
> 
> I agree that we could well split DEBUG_RODATA into something more 
> fine-grained, and for example have it _only_ protect that .rodata thing 
> when Kprobes are enabled, and both .text _and_ .rodata when Kprobes are 
> not.
> 
> That would make lots of sense.

Ok, here's a patch to do this. With that 55181000cd60334fe920c65ffbcdfe0e3f1de406
should be reverted because it isn't needed anymore.

I still think in .23 it should be fixed properly, by either using c_p_a()
as needed in the kprobes/alternatives code (Prasanna already had a patch) 
or perhaps better just doing a temporal ioremap() there.

-Andi

---

Disable kernel text protection when kprobes are enabled

To be done better in .23

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -600,6 +600,10 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
+#ifdef CONFIG_KPROBES
+	/* Kprobes code doesn't know yet how to unprotect. Temporary fix. */
+	start = (unsigned long)_etext;
+#endif
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
 	if (num_possible_cpus() > 1)
Index: linux/arch/i386/mm/init.c
===================================================================
--- linux.orig/arch/i386/mm/init.c
+++ linux/arch/i386/mm/init.c
@@ -798,12 +798,16 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
+	int notext = 0;
 
+#ifdef CONFIG_KPROBES
+	notext = 1;
+#endif
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() <= 1)
+	notext = (num_possible_cpus() > 1);
 #endif
-	{
+	if (!notext) {
 		change_page_attr(virt_to_page(start),
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);

