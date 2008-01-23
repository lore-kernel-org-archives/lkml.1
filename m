Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYAWP7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYAWP7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYAWP7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:59:20 -0500
Received: from mail0.scram.de ([78.47.204.202]:37737 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbYAWP7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:59:18 -0500
X-Spam-Score: -4.182
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4797644A.7060201@scram.de>
Date: Wed, 23 Jan 2008 16:59:06 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 1/8] [POWERPC] Remove unused m8xx_cpm_hostalloc/free/dump()
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m8xx_cpm_hostalloc is still defined in commproc.c, but no users are left
in the kernel tree. m8xx_cpm_hostfree and m8xx_cpm_hostdump are only
defined in the headers. Remove this dead code.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
  arch/powerpc/sysdev/commproc.c |   37 -------------------------------------
  arch/ppc/8xx_io/commproc.c     |   38 --------------------------------------
  include/asm-powerpc/commproc.h |    4 ----
  include/asm-ppc/commproc.h     |    4 ----
  4 files changed, 0 insertions(+), 83 deletions(-)

diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index 621bc6c..818d4b0 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -48,8 +48,6 @@
  #ifndef CONFIG_PPC_CPM_NEW_BINDING
  static void m8xx_cpm_dpinit(void);
  #endif
-static uint host_buffer; /* One page of host buffer */
-static uint host_end;    /* end + 1 */
  cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
  immap_t __iomem *mpc8xx_immr;
  static cpic8xx_t __iomem *cpic_reg;
@@ -268,41 +266,6 @@ out:
  }
  EXPORT_SYMBOL(cpm_command);

-/* We used to do this earlier, but have to postpone as long as possible
- * to ensure the kernel VM is now running.
- */
-static void
-alloc_host_memory(void)
-{
-	dma_addr_t	physaddr;
-
-	/* Set the host page for allocation.
-	*/
-	host_buffer = (uint)dma_alloc_coherent(NULL, PAGE_SIZE, &physaddr,
-			GFP_KERNEL);
-	host_end = host_buffer + PAGE_SIZE;
-}
-
-/* We also own one page of host buffer space for the allocation of
- * UART "fifos" and the like.
- */
-uint
-m8xx_cpm_hostalloc(uint size)
-{
-	uint	retloc;
-
-	if (host_buffer == 0)
-		alloc_host_memory();
-
-	if ((host_buffer + size) >= host_end)
-		return(0);
-
-	retloc = host_buffer;
-	host_buffer += size;
-
-	return(retloc);
-}
-
  /* Set a baud rate generator.  This needs lots of work.  There are
   * four BRGs, any of which can be wired to any channel.
   * The internal baud rate clock is the system clock divided by 16.
diff --git a/arch/ppc/8xx_io/commproc.c b/arch/ppc/8xx_io/commproc.c
index 9da880b..3f93af8 100644
--- a/arch/ppc/8xx_io/commproc.c
+++ b/arch/ppc/8xx_io/commproc.c
@@ -55,8 +55,6 @@
  })

  static void m8xx_cpm_dpinit(void);
-static	uint	host_buffer;	/* One page of host buffer */
-static	uint	host_end;	/* end + 1 */
  cpm8xx_t	*cpmp;		/* Pointer to comm processor space */

  /* CPM interrupt vector functions.
@@ -68,7 +66,6 @@ struct	cpm_action {
  static	struct	cpm_action cpm_vecs[CPMVEC_NR];
  static	irqreturn_t cpm_interrupt(int irq, void * dev);
  static	irqreturn_t cpm_error_interrupt(int irq, void *dev);
-static	void	alloc_host_memory(void);
  /* Define a table of names to identify CPM interrupt handlers in
   * /proc/interrupts.
   */
@@ -158,21 +155,6 @@ m8xx_cpm_reset(void)
  	cpmp = (cpm8xx_t *)commproc;
  }

-/* We used to do this earlier, but have to postpone as long as possible
- * to ensure the kernel VM is now running.
- */
-static void
-alloc_host_memory(void)
-{
-	dma_addr_t	physaddr;
-
-	/* Set the host page for allocation.
-	*/
-	host_buffer = (uint)dma_alloc_coherent(NULL, PAGE_SIZE, &physaddr,
-			GFP_KERNEL);
-	host_end = host_buffer + PAGE_SIZE;
-}
-
  /* This is called during init_IRQ.  We used to do it above, but this
   * was too early since init_IRQ was not yet called.
   */
@@ -319,26 +301,6 @@ cpm_free_handler(int cpm_vec)
  	cpm_vecs[cpm_vec].dev_id = NULL;
  }

-/* We also own one page of host buffer space for the allocation of
- * UART "fifos" and the like.
- */
-uint
-m8xx_cpm_hostalloc(uint size)
-{
-	uint	retloc;
-
-	if (host_buffer == 0)
-		alloc_host_memory();
-
-	if ((host_buffer + size) >= host_end)
-		return(0);
-
-	retloc = host_buffer;
-	host_buffer += size;
-
-	return(retloc);
-}
-
  /* Set a baud rate generator.  This needs lots of work.  There are
   * four BRGs, any of which can be wired to any channel.
   * The internal baud rate clock is the system clock divided by 16.
diff --git a/include/asm-powerpc/commproc.h b/include/asm-powerpc/commproc.h
index 9e3b864..9757521 100644
--- a/include/asm-powerpc/commproc.h
+++ b/include/asm-powerpc/commproc.h
@@ -87,10 +87,6 @@ extern uint cpm_dpram_phys(u8* addr);

  extern void cpm_setbrg(uint brg, uint rate);

-extern uint m8xx_cpm_hostalloc(uint size);
-extern int  m8xx_cpm_hostfree(uint start);
-extern void m8xx_cpm_hostdump(void);
-
  extern void cpm_load_patch(cpm8xx_t *cp);

  /* Buffer descriptors used by many of the CPM protocols.
diff --git a/include/asm-ppc/commproc.h b/include/asm-ppc/commproc.h
index 462abb1..5418d6d 100644
--- a/include/asm-ppc/commproc.h
+++ b/include/asm-ppc/commproc.h
@@ -75,10 +75,6 @@ extern void *cpm_dpram_addr(unsigned long offset);
  extern uint cpm_dpram_phys(u8* addr);
  extern void cpm_setbrg(uint brg, uint rate);

-extern uint m8xx_cpm_hostalloc(uint size);
-extern int  m8xx_cpm_hostfree(uint start);
-extern void m8xx_cpm_hostdump(void);
-
  extern void cpm_load_patch(volatile immap_t *immr);

  /* Buffer descriptors used by many of the CPM protocols.
-- 
1.5.3.8


