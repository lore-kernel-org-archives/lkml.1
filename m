Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZDXOm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZDXOm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZDXOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:42:50 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:36945 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZDXOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:42:49 -0400
Date: Fri, 24 Apr 2009 18:42:46 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: titan and marvel build fixes
Message-ID: <20090424144246.GA32087@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These platforms got broken after u64 => 'long long' conversion.

Apparently that change was compile-tested with 'make allmodconfig',
but it doesn't include systems that depend on !ALPHA_LEGACY_START_ADDRESS.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/err_ev6.c    |    2 +-
 arch/alpha/kernel/err_ev7.c    |    4 ++--
 arch/alpha/kernel/err_impl.h   |   10 +++++-----
 arch/alpha/kernel/err_marvel.c |    2 +-
 arch/alpha/kernel/err_titan.c  |    4 ++--
 arch/alpha/kernel/proto.h      |    5 ++---
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/alpha/kernel/err_ev6.c b/arch/alpha/kernel/err_ev6.c
index 985e5c1..8ca6345 100644
--- a/arch/alpha/kernel/err_ev6.c
+++ b/arch/alpha/kernel/err_ev6.c
@@ -229,7 +229,7 @@ ev6_process_logout_frame(struct el_common *mchk_header, int print)
 }
 
 void
-ev6_machine_check(u64 vector, u64 la_ptr)
+ev6_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 
diff --git a/arch/alpha/kernel/err_ev7.c b/arch/alpha/kernel/err_ev7.c
index 73770c6..d738a67 100644
--- a/arch/alpha/kernel/err_ev7.c
+++ b/arch/alpha/kernel/err_ev7.c
@@ -117,7 +117,7 @@ ev7_collect_logout_frame_subpackets(struct el_subpacket *el_ptr,
 }
 
 void
-ev7_machine_check(u64 vector, u64 la_ptr)
+ev7_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_subpacket *el_ptr = (struct el_subpacket *)la_ptr;
 	char *saved_err_prefix = err_print_prefix;
@@ -246,7 +246,7 @@ ev7_process_pal_subpacket(struct el_subpacket *header)
 
 	switch(header->type) {
 	case EL_TYPE__PAL__LOGOUT_FRAME:
-		printk("%s*** MCHK occurred on LPID %ld (RBOX %llx)\n",
+		printk("%s*** MCHK occurred on LPID %lld (RBOX %llx)\n",
 		       err_print_prefix,
 		       packet->by_type.logout.whami, 
 		       packet->by_type.logout.rbox_whami);
diff --git a/arch/alpha/kernel/err_impl.h b/arch/alpha/kernel/err_impl.h
index 3c12258..0c010ca 100644
--- a/arch/alpha/kernel/err_impl.h
+++ b/arch/alpha/kernel/err_impl.h
@@ -60,26 +60,26 @@ extern struct ev7_lf_subpackets *
 ev7_collect_logout_frame_subpackets(struct el_subpacket *,
 				    struct ev7_lf_subpackets *);
 extern void ev7_register_error_handlers(void);
-extern void ev7_machine_check(u64, u64);
+extern void ev7_machine_check(unsigned long, unsigned long);
 
 /*
  * err_ev6.c
  */
 extern void ev6_register_error_handlers(void);
 extern int ev6_process_logout_frame(struct el_common *, int);
-extern void ev6_machine_check(u64, u64);
+extern void ev6_machine_check(unsigned long, unsigned long);
 
 /*
  * err_marvel.c
  */
-extern void marvel_machine_check(u64, u64);
+extern void marvel_machine_check(unsigned long, unsigned long);
 extern void marvel_register_error_handlers(void);
 
 /*
  * err_titan.c
  */
 extern int titan_process_logout_frame(struct el_common *, int);
-extern void titan_machine_check(u64, u64);
+extern void titan_machine_check(unsigned long, unsigned long);
 extern void titan_register_error_handlers(void);
 extern int privateer_process_logout_frame(struct el_common *, int);
-extern void privateer_machine_check(u64, u64);
+extern void privateer_machine_check(unsigned long, unsigned long);
diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index 6bfd243..52a79df 100644
--- a/arch/alpha/kernel/err_marvel.c
+++ b/arch/alpha/kernel/err_marvel.c
@@ -1042,7 +1042,7 @@ marvel_process_logout_frame(struct ev7_lf_subpackets *lf_subpackets, int print)
 }
 
 void
-marvel_machine_check(u64 vector, u64 la_ptr)
+marvel_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_subpacket *el_ptr = (struct el_subpacket *)la_ptr;
 	int (*process_frame)(struct ev7_lf_subpackets *, int) = NULL;
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index c7e28a8..f7ed97c 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -380,7 +380,7 @@ titan_process_logout_frame(struct el_common *mchk_header, int print)
 }
 
 void
-titan_machine_check(u64 vector, u64 la_ptr)
+titan_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 	struct el_TITAN_sysdata_mcheck *tmchk =
@@ -702,7 +702,7 @@ privateer_process_logout_frame(struct el_common *mchk_header, int print)
 }
 
 void
-privateer_machine_check(u64 vector, u64 la_ptr)
+privateer_machine_check(unsigned long vector, unsigned long la_ptr)
 {
 	struct el_common *mchk_header = (struct el_common *)la_ptr;
 	struct el_TITAN_sysdata_mcheck *tmchk =
diff --git a/arch/alpha/kernel/proto.h b/arch/alpha/kernel/proto.h
index 567f259..3d2627e 100644
--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -36,7 +36,6 @@ extern void cia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern struct pci_ops irongate_pci_ops;
 extern int irongate_pci_clr_err(void);
 extern void irongate_init_arch(void);
-extern void irongate_machine_check(u64, u64);
 #define irongate_pci_tbi ((void *)0)
 
 /* core_lca.c */
@@ -49,7 +48,7 @@ extern void lca_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern struct pci_ops marvel_pci_ops;
 extern void marvel_init_arch(void);
 extern void marvel_kill_arch(int);
-extern void marvel_machine_check(u64, u64);
+extern void marvel_machine_check(unsigned long, unsigned long);
 extern void marvel_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern int marvel_pa_to_nid(unsigned long);
 extern int marvel_cpuid_to_nid(int);
@@ -86,7 +85,7 @@ extern void t2_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern struct pci_ops titan_pci_ops;
 extern void titan_init_arch(void);
 extern void titan_kill_arch(int);
-extern void titan_machine_check(u64, u64);
+extern void titan_machine_check(unsigned long, unsigned long);
 extern void titan_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern struct _alpha_agp_info *titan_agp_info(void);
 
