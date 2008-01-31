Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbYAaTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbYAaTCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbYAaTBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:01:54 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:61389 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199AbYAaTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:01:53 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       H Peter Anvin <hpa@zytor.com>
In-Reply-To: <de52cce203cd6edeed0d.1201296193@localhost>
References: <de52cce203cd6edeed0d.1201296193@localhost>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 19:01:36 +0000
Message-Id: <1201806096.20036.43.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 04 of 11] x86: fix early_ioremap pagetable ops
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 13:23 -0800, Jeremy Fitzhardinge wrote:
> Put appropriate pagetable update hooks in so that paravirt knows
> what's going on in there.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/mm/ioremap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -18,6 +18,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
> +#include <asm/pgalloc.h>
>  
>  #ifdef CONFIG_X86_64
>  
> @@ -265,7 +266,7 @@ void __init early_ioremap_init(void)
>  
>  	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
>  	memset(bm_pte, 0, sizeof(bm_pte));
> -	set_pmd(pmd, __pmd(__pa(bm_pte) | _PAGE_TABLE));
> +	pmd_populate_kernel(&init_mm, pmd, bm_pte);
>  
>  	/*
>  	 * The boot-ioremap range spans multiple pmds, for which
> @@ -295,6 +296,7 @@ void __init early_ioremap_clear(void)
>  
>  	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
>  	pmd_clear(pmd);
> +	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
>  	__flush_tlb_all();
>  }

This seems to have ended up in f6df72e71eba621b2f5c49b3a763116fac748f6e
as:
+	paravirt_release_pt(__pa(pmd) >> PAGE_SHIFT);

and the pmd_populate_kernel hunk is missing altogether.

---
>From bfa2a08064a269dd7906ed5f60e436360e1360e7 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Thu, 31 Jan 2008 18:56:06 +0000
Subject: [PATCH] x86: fix early_ioremap pagetable ops for paravirt.

Some important parts of f6df72e71eba621b2f5c49b3a763116fac748f6e got dropped
along the way, reintroduce them.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
---
 arch/x86/mm/ioremap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ed4208e..93d931e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -302,7 +302,7 @@ void __init early_ioremap_init(void)
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
-	set_pmd(pmd, __pmd(__pa(bm_pte) | _PAGE_TABLE));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
@@ -332,7 +332,7 @@ void __init early_ioremap_clear(void)
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	pmd_clear(pmd);
-	paravirt_release_pt(__pa(pmd) >> PAGE_SHIFT);
+	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
 	__flush_tlb_all();
 }
 
-- 
1.5.3.8



-- 
Ian Campbell

This fortune would be seven words long if it were six words shorter.

