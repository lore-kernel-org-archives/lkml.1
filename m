Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbZD3Rjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbZD3Rjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764700AbZD3RIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:35 -0400
Received: from kroah.org ([198.145.64.141]:56846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764582AbZD3RIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.704564477@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 70/88] KVM: MMU: handle large host sptes on invlpg/resync
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-handle-large-host-sptes-on-invlpg-resync.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------


(cherry picked from 87917239204d67a316cb89751750f86c9ed3640b)

The invlpg and sync walkers lack knowledge of large host sptes,
descending to non-existant pagetable level.

Stop at directory level in such case.

Fixes SMP Windows XP with hugepages.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c         |    2 +-
 arch/x86/kvm/paging_tmpl.h |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -981,7 +981,7 @@ static int mmu_unsync_walk(struct kvm_mm
 	for_each_unsync_children(sp->unsync_child_bitmap, i) {
 		u64 ent = sp->spt[i];
 
-		if (is_shadow_present_pte(ent)) {
+		if (is_shadow_present_pte(ent) && !is_large_pte(ent)) {
 			struct kvm_mmu_page *child;
 			child = page_header(ent & PT64_BASE_ADDR_MASK);
 
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -467,9 +467,13 @@ static int FNAME(shadow_invlpg_entry)(st
 				      u64 *sptep, int level)
 {
 
-	if (level == PT_PAGE_TABLE_LEVEL) {
-		if (is_shadow_present_pte(*sptep))
+	if (level == PT_PAGE_TABLE_LEVEL ||
+	    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
+		if (is_shadow_present_pte(*sptep)) {
 			rmap_remove(vcpu->kvm, sptep);
+			if (is_large_pte(*sptep))
+				--vcpu->kvm->stat.lpages;
+		}
 		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 		return 1;
 	}


