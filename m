Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXCGRo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXCGRo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422826AbXCGRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:30 -0500
Received: from mail.suse.de ([195.135.220.2]:43821 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422820AbXCGRPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:16 -0500
Message-Id: <20070307171338.291234774@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@suse.de>
Subject: [patch 043/101] i386: Fix broken CONFIG_COMPAT_VDSO on i386
Content-Disposition: inline; filename=i386-fix-broken-config_compat_vdso-on-i386.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan Beulich" <jbeulich@novell.com>

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

Cc: Theodore Tso <tytso@mit.edu>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/sysenter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/arch/i386/kernel/sysenter.c
+++ linux-2.6.20.1/arch/i386/kernel/sysenter.c
@@ -77,7 +77,7 @@ int __init sysenter_setup(void)
 	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 
 #ifdef CONFIG_COMPAT_VDSO
-	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY);
+	__set_fixmap(FIX_VDSO, __pa(syscall_page), PAGE_READONLY_EXEC);
 	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
 #endif
 

--
