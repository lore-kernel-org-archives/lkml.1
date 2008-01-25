Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYAYJRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYAYJRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYAYJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:17:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYAYJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:17:11 -0500
Date: Fri, 25 Jan 2008 10:16:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
Message-ID: <20080125091655.GD23708@elte.hu>
References: <1201240501.15972.46.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201240501.15972.46.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch fixes some bugs of making EFI runtime code executable.
> 
> - Use change_page_attr in i386 too. Because the runtime code may be
>   mapped not through ioremap.
> 
> - If there is no _PAGE_NX in __supported_pte_mask, the change_page_attr
>   is not called.
> 
> - Make efi_ioremap map pages as PAGE_KERNEL_EXEC, because EFI runtime
>   code may be mapped through efi_ioremap.

thanks, applied.

note that here:

> -		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> -				   offset);
> +		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> +			     offset, PAGE_KERNEL_EXEC);

you've changed it from nocache-noexec to cached-exec. I suspect that's 
what we want - except if an early EFI area can be non-prefetchable 
device memory. Can that ever happen? Would you like to have 
PAGE_KERNEL_NOCACHE_EXEC perhaps? I implemented that yesterday but did 
not commit it yet. (see the patch below)

	Ingo

----------------->
Subject: x86: add PAGE_KERNEL_EXEC_NOCACHE
From: Ingo Molnar <mingo@elte.hu>

add PAGE_KERNEL_EXEC_NOCACHE.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-x86.q/include/asm-x86/pgtable.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable.h
+++ linux-x86.q/include/asm-x86/pgtable.h
@@ -79,6 +79,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KE
 
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
+#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
@@ -96,6 +97,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KE
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		MAKE_GLOBAL(__PAGE_KERNEL_VSYSCALL)
