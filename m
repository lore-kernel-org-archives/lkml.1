Return-Path: <linux-kernel-owner+w=401wt.eu-S937368AbYBWAxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937368AbYBWAxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:53:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935795AbYBWAgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:37 -0500
Received: from mail.suse.de ([195.135.220.2]:45081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935239AbYBWAgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:35 -0500
Date: Fri, 22 Feb 2008 16:31:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 38/38] x86_64: CPA, fix cache attribute inconsistency bug
Message-ID: <20080223003143.GM7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86_64-cpa-fix-cache-attribute-inconsistency-bug.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ingo Molnar <mingo@elte.hu>

(no matching git id as the upstream code is rewritten)

fix CPA cache attribute bug in v2.6.24. When phys_base is nonzero (when 
CONFIG_RELOCATABLE=y) then change_page_attr_addr() miscalculates the 
secondary alias address by -14 MB (depending on the configured offset).

The default 64-bit kernels of Fedora and Ubuntu are affected:

   $ grep RELOCA /boot/config-2.6.23.9-85.fc8
     CONFIG_RELOCATABLE=y

   $ grep RELOC /boot/config-2.6.22-14-generic
     CONFIG_RELOCATABLE=y

and probably on many other distros as well.

the bug affects all pages in the first 40 MB of physical RAM that
are allocated by some subsystem that does ioremap_nocache() on them:

       if (__pa(address) < KERNEL_TEXT_SIZE) {

Hence we might leave page table entries with inconsistent cache
attributes around (pages mapped at both UnCacheable and Write-Back),
and we can also set the wrong kernel text pages to UnCacheable.

the effects of this bug can be random slowdowns and other misbehavior.
If for example AGP allocates its aperture pages into the first 40 MB
of physical RAM, then the -14 MB bug might mark random kernel texto
pages as uncacheable, slowing down a random portion of the 64-bit
kernel until the AGP driver is unloaded.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/pageattr_64.c
+++ b/arch/x86/mm/pageattr_64.c
@@ -207,7 +207,7 @@ int change_page_attr_addr(unsigned long 
 		if (__pa(address) < KERNEL_TEXT_SIZE) {
 			unsigned long addr2;
 			pgprot_t prot2;
-			addr2 = __START_KERNEL_map + __pa(address);
+			addr2 = __START_KERNEL_map + __pa(address) - phys_base;
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
 			err = __change_page_attr(addr2, pfn, prot2,

-- 
