Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZEHFgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZEHFgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZEHFfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:35:52 -0400
Received: from gw.goop.org ([64.81.55.164]:44879 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZEHFfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:35:51 -0400
Message-ID: <4A03C4B6.5070308@goop.org>
Date: Thu, 07 May 2009 22:35:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [BISECTED REGRESSION] Xen: OOPSes on heavy block IO on 2.6.30-master
References: <3e8340490905072118s6d7a4127tff932317213febb4@mail.gmail.com>
In-Reply-To: <3e8340490905072118s6d7a4127tff932317213febb4@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> I've bisected this problem down to the following commit;
> unfortunately, there were some rather hairy interdependencies after
> that point, so I wasn't able to test reverting it on top of master:
> commit 93dbda7cbcd70a0bd1a99f39f44a9ccde8ab9040
> Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date:   Thu Feb 26 17:35:44 2009 -0800
>   

Thanks for going to the trouble of bisecting this, but I'd just fixed 
this bug :/

The patch below should fix it.

Thanks again,
    J

>From f26499cadfd057e4377e92ba680e16fa7bdf9422 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 5 May 2009 13:08:42 -0700
Subject: [PATCH] xen/i386: reserve Xen pagetables

The Xen pagetables are no longer implicitly reserved as part of the other
i386_start_kernel reservations, so make sure we explicitly reserve them.
This prevents them from being released into the general kernel free page
pool and reused.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0e13477..801d042 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1799,6 +1799,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */


