Return-Path: <linux-kernel-owner+w=401wt.eu-S1765467AbZCaXjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765467AbZCaXjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbZCaXWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:51 -0400
Received: from sous-sol.org ([216.99.217.87]:52976 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764339AbZCaXWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:50 -0400
Message-Id: <20090331231826.243558906@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 45/45] KVM: MMU: Fix another largepage memory leak
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=kvm-mmu-fix-another-largepage-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Joerg Roedel <joerg.roedel@amd.com>

upstream commit: c5bc22424021cabda862727fb3f5098b866f074d

In the paging_fetch function rmap_remove is called after setting a large
pte to non-present. This causes rmap_remove to not drop the reference to
the large page. The result is a memory leak of that page.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -314,9 +314,9 @@ static int FNAME(shadow_walk_entry)(stru
 		return 0;
 
 	if (is_large_pte(*sptep)) {
+		rmap_remove(vcpu->kvm, sptep);
 		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 		kvm_flush_remote_tlbs(vcpu->kvm);
-		rmap_remove(vcpu->kvm, sptep);
 	}
 
 	if (level == PT_DIRECTORY_LEVEL && gw->level == PT_DIRECTORY_LEVEL) {

