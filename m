Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbYHOQdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbYHOQdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbYHOQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:33:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:28351 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbYHOQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N1VniwC8EPSlnPDF+yQtaX7imKzQsHcOKv2h6LYDL9Mub16AA9Q9C3nGAeWlHa966/
         9aZ/TZ52uGb2En0eyLw5wD2unKnKljRHlupBXtTj8AVRbL9R6RcmTVdtKpDFM4U82PB6
         itRlDJmDMQHcdWb3GfgUHXv3X3Xjvlq8r1+w0=
Date: Fri, 15 Aug 2008 18:32:24 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] x86: fix section mismatch warning - spp_getpage()
Message-ID: <20080815163212.GA5408@joi>
References: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com> <20080813111051.GA18660@elte.hu> <20080813140555.GA18523@elte.hu> <20080815123201.GB5285@joi> <20080815135027.GB14103@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815135027.GB14103@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 03:50:27PM +0200, Ingo Molnar wrote:
> 
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > I looked at both implementations of arch_setup_additional_pages and 
> > didn't see any call to native_set_fixmap or function which calls 
> > directly native_set_fixmap... Can you tell me what's the callchain?
> 
> the callchain would be:
> 
> [   20.116039] PM: Adding info for No Bus:vcsa1
> [   20.180039] BUG: unable to handle kernel paging request at c0833e44
> [   20.180039] IP: [<c0833e44>] native_set_fixmap+0x0/0x1d
> [   20.180039] *pde = 36f2a163 *pte = 00833162
> [   20.180039] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   20.180039] Modules linked in:
> [   20.180039]
> [   20.180039] Pid: 1, comm: init Not tainted (2.6.27-rc3-00005-g844342a-dirty #24071)
> [   20.180039] EIP: 0060:[<c0833e44>] EFLAGS: 00010216 CPU: 0
> [   20.180039] EIP is at native_set_fixmap+0x0/0x1d
> [   20.180039] EAX: 00000001 EBX: 00000001 ECX: 00000025 EDX: 3782e000
> [   20.180039] ESI: 00000000 EDI: f671c000 EBP: f7836e68 ESP: f7836e4c
> [   20.180039]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   20.180039] Process init (pid: 1, ti=f7836000 task=f7870000 task.ti=f7836000)
> [   20.180039] Stack: c011d580 f671c034 c018bbea 00000025 00000000 00000988 f6ef2000 f7836f1c
> [   20.180039]        c01b43d6 00000003 00000008 f7836f7c f782fd10 00000003 f78b6100 08048000
> [   20.180039]        00000000 00000001 f67a2500 08050b99 08050b99 00000000 00000000 00000000
> [   20.180039] Call Trace:
> [   20.180039]  [<c011d580>] ? arch_setup_additional_pages+0x8c/0x124
> [   20.180039]  [<c018bbea>] ? try_module_get+0x8/0x2f
> [   20.180039]  [<c01b43d6>] ? load_elf_binary+0xae6/0x1108
> [   20.180039]  [<c0144c6d>] ? lock_release_holdtime+0x43/0x48
> [   20.180039]  [<c018c0c0>] ? search_binary_handler+0x92/0x1e5
> [   20.180039]  [<c01b38f0>] ? load_elf_binary+0x0/0x1108
> [   20.180039]  [<c018d2d7>] ? do_execve+0x14c/0x1d8
> [   20.180039]  [<c0101dd8>] ? sys_execve+0x2e/0x56
> [   20.180039]  [<c01030ca>] ? syscall_call+0x7/0xb
> [   20.180039]  [<c01067c8>] ? kernel_execve+0x1c/0x21
> [   20.180039]  [<c0101286>] ? run_init_process+0x1c/0x1e
> [   20.180039]  [<c0101333>] ? init_post+0xab/0xd4
> [   20.180039]  [<c0103d07>] ? kernel_thread_helper+0x7/0x10
> [   20.180039]  =======================
> [   20.180039] Code:  Bad EIP value.
> 
> 	Ingo

Thanks.
arch_setup_additional_pages -> map_compat_vdso -> __set_fixmap -> native_set_fixmap

How about this one?
---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH v2] x86: fix section mismatch warning - spp_getpage()

WARNING: vmlinux.o(.text+0x17a3e): Section mismatch in reference from the function set_pte_vaddr_pud() to the function .init.text:spp_getpage()
The function set_pte_vaddr_pud() references
the function __init spp_getpage().
This is often because set_pte_vaddr_pud lacks a __init
annotation or the annotation of spp_getpage is wrong.

spp_getpage is called from __init (__init_extra_mapping) and
non __init (set_pte_vaddr_pud) functions, so it can't be __init.
Unfortunately it calls alloc_bootmem_pages which is __init,
but does it only when bootmem allocator is available (after_bootmem == 0).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/init_64.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 129618c..f0923ce 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -88,7 +88,11 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
-static __init void *spp_getpage(void)
+/*
+ * NOTE: This function is marked __ref because it calls __init function
+ * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
+ */
+static __ref void *spp_getpage(void)
 {
 	void *ptr;
 
-- 
1.5.4.5

