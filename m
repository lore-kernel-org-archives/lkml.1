Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbYBFXYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbYBFXYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYBFXYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:24:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:8743 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbYBFXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:24:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=utYGwtTOEN8GErEMIfoi/w1FRQ5U+uDOsp/RXyqbddV8Nz3g/HgaIomTmC4qM8Hf8xQ0B9/FUD86CJdJ68Hcy0txCrvrQooBSnBfan9ykknJN2aje5VAJgOyZJwduAX/s+UUxCPn+1FNouOwKbAE8Y8uBpoo/k+S14zasOAY1gY=
Date: Thu, 7 Feb 2008 01:21:34 +0200
To: Rusty Russel <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [Lguest/x86]: Clash with ioremap_nocache() + _PAGE_PWT
Message-ID: <20080206232134.GB6450@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Beginning from commit 4138cc3418f5, ioremap_nocache() sets the _PAGE_PWT
flag. 

Lguest doesn't accept a guest pte with a _PWT flag and reports a
"bad page table entry" in that case. 

I've removed check from lguest code and everything worked fine. 
Is this safe from the Lguest side ?

Mentioned commit [*]:

commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5
Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
Date:   Wed Jan 30 13:33:43 2008 +0100

    x86: set strong uncacheable where UC is really desired
    
    Also use _PAGE_PWT for all the mappings which need uncache mapping.
    Instead of existing PAT2 which is UC- (and can be overwritten by MTRRs),
    we now use PAT3 which is strong uncacheable.
    
    This makes it consistent with pgprot_noncached()

diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
index 0b27831..ef0f6a4 100644
--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(__ioremap);
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
 	unsigned long last_addr;
-	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD);
+	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD | _PAGE_PWT);
 	if (!p) 
 		return p; 

Thanks,

[*]: latest pull calls set_memory_uc() which also sets the _PWT flag.

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
