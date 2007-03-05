Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXCEEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXCEEml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXCEEmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:42:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57928
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbXCEEmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:42:39 -0500
Date: Sun, 04 Mar 2007 20:42:38 -0800 (PST)
Message-Id: <20070304.204238.79050191.davem@davemloft.net>
To: bunk@stusta.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vonbrand@inf.utfsm.cl,
       davem@sunset.davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [6/6] 2.6.21-rc2: known regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305022602.GL3441@stusta.de>
References: <20070305015045.GK3441@stusta.de>
	<20070304.180725.126592830.davem@davemloft.net>
	<20070305022602.GL3441@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 5 Mar 2007 03:26:02 +0100

> On Sun, Mar 04, 2007 at 06:07:25PM -0800, David Miller wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> > Date: Mon, 5 Mar 2007 02:50:45 +0100
> > 
> > > Subject    : sparc64 compile error due to GENERIC_ISA_DMA removal
> > > References : http://bugzilla.kernel.org/show_bug.cgi?id=8097
> > > Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> > > Caused-By  : David S. Miller <davem@sunset.davemloft.net>
> > >              commit 1b51d3a08b6c80a1e47d4c579c41abbe56cd3c44
> > > Status     : unknown
> > 
> > Fixed in current GIT.
> > 
> > commit 74bd7d093b8e87f35eaf3b14459b96a0e20d1d10
> > Author: David S. Miller <davem@sunset.davemloft.net>
> > Date:   Wed Feb 28 13:09:34 2007 -0800
> > 
> >     [SPARC64]: Fix parport_pc build.
> >     
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Horst's problem is with the floppy driver and 
> claim_dma_lock/release_dma_lock in include/asm-sparc64/dma.h .

Here is the fix I will send to Linus for this, thanks:

commit 08414aa2516da65ae7a522c6834b8ea576f38c4b
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Sun Mar 4 20:36:18 2007 -0800

    [SPARC64]: Fix floppy build failure.
    
    Just define a local {claim,release}_dma_lock() implementation
    for the floppy driver to use so we don't need to define and
    export to modules the silly dma_spin_lock.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-sparc64/dma.h b/include/asm-sparc64/dma.h
index 1bf4f7a..a9fd061 100644
--- a/include/asm-sparc64/dma.h
+++ b/include/asm-sparc64/dma.h
@@ -15,17 +15,6 @@
 #include <asm/delay.h>
 #include <asm/oplib.h>
 
-extern spinlock_t  dma_spin_lock;
-
-#define claim_dma_lock() \
-({	unsigned long flags; \
-	spin_lock_irqsave(&dma_spin_lock, flags); \
-	flags; \
-})
-
-#define release_dma_lock(__flags) \
-	spin_unlock_irqrestore(&dma_spin_lock, __flags);
-
 /* These are irrelevant for Sparc DMA, but we leave it in so that
  * things can compile.
  */
diff --git a/include/asm-sparc64/floppy.h b/include/asm-sparc64/floppy.h
index dbe033e..331013a 100644
--- a/include/asm-sparc64/floppy.h
+++ b/include/asm-sparc64/floppy.h
@@ -854,4 +854,15 @@ static unsigned long __init sun_floppy_init(void)
 
 #define EXTRA_FLOPPY_PARAMS
 
+static DEFINE_SPINLOCK(dma_spin_lock);
+
+#define claim_dma_lock() \
+({	unsigned long flags; \
+	spin_lock_irqsave(&dma_spin_lock, flags); \
+	flags; \
+})
+
+#define release_dma_lock(__flags) \
+	spin_unlock_irqrestore(&dma_spin_lock, __flags);
+
 #endif /* !(__ASM_SPARC64_FLOPPY_H) */
