Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbYGBVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbYGBVst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYGBVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:48:41 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46829 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYGBVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:48:40 -0400
Date: Wed, 2 Jul 2008 22:48:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>,
       Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix Intel Mac booting with EFI
Message-ID: <Pine.LNX.4.64.0807022239520.24137@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora reports that mem_init()'s zap_low_mappings(), extended to SMP in
61165d7a035f6571c7576e7f51e7230157724c8d x86: fix app crashes after SMP resume
causes 32-bit Intel Mac machines to reboot very early when booting with EFI.

The EFI code appears to manage low mappings for itself when needed; but like
many before it, confuses PSE with PAE.  So it has only been mapping half the
space it needed when PSE but not PAE.  This remained unnoticed until we moved
the SMP zap_low_mappings() before efi_enter_virtual_mode().  Presumably could
have been noticed years ago if anyone ran a UP kernel on such machines?

Reported-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Peter Jones <pjones@redhat.com>
---

 arch/x86/kernel/efi_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 2.6.26-rc8/arch/x86/kernel/efi_32.c	2008-04-17 03:49:44.000000000 +0100
+++ linux/arch/x86/kernel/efi_32.c	2008-07-02 17:02:36.000000000 +0100
@@ -49,13 +49,13 @@ void efi_call_phys_prelog(void)
 	local_irq_save(efi_rt_eflags);
 
 	/*
-	 * If I don't have PSE, I should just duplicate two entries in page
-	 * directory. If I have PSE, I just need to duplicate one entry in
+	 * If I don't have PAE, I should just duplicate two entries in page
+	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
 		    swapper_pg_dir[pgd_index(0)].pgd;
 		swapper_pg_dir[0].pgd =
@@ -93,7 +93,7 @@ void efi_call_phys_epilog(void)
 
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
 		    efi_bak_pg_dir_pointer[0].pgd;
 	} else {
