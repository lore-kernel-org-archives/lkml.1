Return-Path: <linux-kernel-owner+w=401wt.eu-S964953AbXBLPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbXBLPFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964957AbXBLPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:05:46 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:46091
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964953AbXBLPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:05:45 -0500
Message-Id: <45D090A0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 15:06:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: broken CONFIG_COMPAT_VDSO on i386
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After updating several machines to 2.6.20, I can't boot  anymore the single
one of them that supports the NX bit and is configured as a 32-bit system.

My understanding is that the VDSO changes in 2.6.20-rc7 were not fully
cooked, in that with that config option enabled VDSO_SYM(x) now equals
x, meaning that an address in the fixmap area is now being passed to
apps via AT_SYSINFO. However, the page is mapped with PAGE_READONLY
rather than PAGE_READONLY_EXEC.

I'm not certain whether having app code go through the fixmap area is
intended, but in case it is here is the simple patch that makes things work
again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/arch/i386/kernel/sysenter.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20/arch/i386/kernel/sysenter.c	2007-02-12 16:01:29.000000000 +0100
@@ -77,7 +77,7 @@ int __init sysenter_setup(void)
 	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 
 #ifdef CONFIG_COMPAT_VDSO
-	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY);
+	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY_EXEC);
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
 #endif
 


