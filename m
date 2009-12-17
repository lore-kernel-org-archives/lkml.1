Return-Path: <linux-kernel-owner+w=401wt.eu-S936531AbZLQE33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936531AbZLQE33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936347AbZLQE24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:28:56 -0500
Received: from kroah.org ([198.145.64.141]:55727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935696AbZLQEEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.138219109@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [087/151] xen: correctly restore pfn_to_mfn_list_list after resume
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit fa24ba62ea2869308ffc9f0b286ac9650b4ca6cb upstream.

pvops kernels >= 2.6.30 can currently only be saved and restored once. The
second attempt to save results in:

    ERROR Internal error: Frame# in pfn-to-mfn frame list is not in pseudophys
    ERROR Internal error: entry 0: p2m_frame_list[0] is 0xf2c2c2c2, max 0x120000
    ERROR Internal error: Failed to map/save the p2m frame list

I finally narrowed it down to:

    commit cdaead6b4e657f960d6d6f9f380e7dfeedc6a09b
        Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
        Date:   Fri Feb 27 15:34:59 2009 -0800

            xen: split construction of p2m mfn tables from registration

            Build the p2m_mfn_list_list early with the rest of the p2m table, but
            register it later when the real shared_info structure is in place.

            Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The unforeseen side-effect of this change was to cause the mfn list list to not
be rebuilt on resume. Prior to this change it would have been rebuilt via
xen_post_suspend() -> xen_setup_shared_info() -> xen_setup_mfn_list_list().

Fix by explicitly calling xen_build_mfn_list_list() from xen_post_suspend().

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c     |    2 +-
 arch/x86/xen/suspend.c |    2 ++
 arch/x86/xen/xen-ops.h |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -185,7 +185,7 @@ static inline unsigned p2m_index(unsigne
 }
 
 /* Build the parallel p2m_top_mfn structures */
-static void __init xen_build_mfn_list_list(void)
+void xen_build_mfn_list_list(void)
 {
 	unsigned pfn, idx;
 
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -27,6 +27,8 @@ void xen_pre_suspend(void)
 
 void xen_post_suspend(int suspend_cancelled)
 {
+	xen_build_mfn_list_list();
+
 	xen_setup_shared_info();
 
 	if (suspend_cancelled) {
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -25,6 +25,7 @@ extern struct shared_info *HYPERVISOR_sh
 
 void xen_setup_mfn_list_list(void);
 void xen_setup_shared_info(void);
+void xen_build_mfn_list_list(void);
 void xen_setup_machphys_mapping(void);
 pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_ident_map_ISA(void);


