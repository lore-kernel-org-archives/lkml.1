Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238Ab0AZXsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0AZXsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017Ab0AZXsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:48:02 -0500
Received: from kroah.org ([198.145.64.141]:35538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab0AZXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:32 2010
Message-Id: <20100126233932.574738665@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [89/98] KVM: MMU: bail out pagewalk on kvm_read_guest error
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit a6085fbaf65ab09bfb5ec8d902d6d21680fe1895 upstream.

Exit the guest pagetable walk loop if reading gpte failed. Otherwise its
possible to enter an endless loop processing the previous present pte.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/paging_tmpl.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -150,7 +150,9 @@ walk:
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
+		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte)))
+			goto not_present;
+
 		trace_kvm_mmu_paging_element(pte, walker->level);
 
 		if (!is_present_gpte(pte))


