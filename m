Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYCBQPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYCBQPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCBQPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:15:22 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:47762 "EHLO smpt2.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbYCBQPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:15:21 -0500
X-Greylist: delayed 1468 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 11:15:20 EST
Date: Sun, 2 Mar 2008 16:53:48 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Message-ID: <20080302155348.GA74305@gandalf.sssup.it>
Mail-Followup-To: Arjan van de Ven <arjan@linux.intel.com>,
	Gabriel C <nix.or.die@googlemail.com>,
	Laurent Riffard <laurent.riffard@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Stuart Bennett <sb476@cam.ac.uk>,
	Len Brown <lenb@kernel.org>, tglx@linutronix.de, mingo@redhat.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C344E5.5050205@linux.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'd relevant maintainers]

Hi,

> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, Feb 25, 2008 02:44:53PM -0800
>
> Gabriel C wrote:
...
> >With your patch from 
> >http://marc.info/?l=linux-kernel&m=120336371506283&w=2 I don't have a 
> >warning anymore.
> >
> 
> that is ... odd since it's the same in theory, just with some added 
> printk's ;-(

the same here on 2.6.25-rc3, with the innocent ibmphp_access_ebda()
that fires the WARN_ON() in __ioremap() asking for the pfn 0, even
after the page_is_ram() change.  With your patch the warning
disappears.

I think this is because the pfn checked by the original code (before
your patch) is the one after the last iteration, while your patch
checks for each pfn that is going to be mapped.  The latter should
be the intended behavior.  If I've understood the problem, the
(trivial) patch below should fix it.

Also, note that if last_addr is at the beginning of a page we can
__ioremap() normal RAM (in fact we only emit the warning with the
old code, instead of returning NULL.)  Is that possible/intended
behavior?  If not the loop should do one more iteration.


__ioremap() emits a warning if the pfn after the last one it's going
to map is of normal ram.  Correct this and emit the warning (once)
only if one of the asked pages is.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ac3c959..6f7b158 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -109,7 +109,7 @@ static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, last_addr, vaddr, is_ram = 0;
 	struct vm_struct *area;
 	pgprot_t prot;
 
@@ -132,9 +132,10 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 		if (page_is_ram(pfn) && pfn_valid(pfn) &&
 		    !PageReserved(pfn_to_page(pfn)))
 			return NULL;
+		is_ram |= page_is_ram(pfn);
 	}
 
-	WARN_ON_ONCE(page_is_ram(pfn));
+	WARN_ON_ONCE(is_ram);
 
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
