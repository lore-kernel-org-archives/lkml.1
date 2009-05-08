Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZEHJJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZEHJJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZEHJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:09:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbZEHJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:09:06 -0400
Date: Fri, 8 May 2009 09:07:14 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, bdonlan@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       xen-devel@lists.xensource.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, bdonlan@gmail.com, tglx@linutronix.de,
       xen-devel@lists.xensource.com, mingo@elte.hu
In-Reply-To: <4A032EEC.30509@goop.org>
References: <4A032EEC.30509@goop.org>
Subject: [tip:x86/urgent] x86: xen, i386: reserve Xen pagetables
Message-ID: <tip-33df4db04a79660150e1948e3296eeb451ac121b@git.kernel.org>
Git-Commit-ID: 33df4db04a79660150e1948e3296eeb451ac121b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 09:07:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33df4db04a79660150e1948e3296eeb451ac121b
Gitweb:     http://git.kernel.org/tip/33df4db04a79660150e1948e3296eeb451ac121b
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Thu, 7 May 2009 11:56:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 10:49:11 +0200

x86: xen, i386: reserve Xen pagetables

The Xen pagetables are no longer implicitly reserved as part of the other
i386_start_kernel reservations, so make sure we explicitly reserve them.
This prevents them from being released into the general kernel free page
pool and reused.

[ Impact: fix Xen guest crash ]

Also-Bisected-by: Bryan Donlan <bdonlan@gmail.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4A032EEC.30509@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/xen/mmu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9842b12..e25a78e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1794,6 +1794,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
