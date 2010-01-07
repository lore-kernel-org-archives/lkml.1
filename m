Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084Ab0AGPxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0AGPxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859Ab0AGPxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:53:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59622 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0AGPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RZiCsAVaRGht7AZUHB/5WIRc3QqTHAm0s10Fyi1IIjLrJCFnKVK/rI8nruzuC6Ffn7
         6uVibhFkD2O2+SQr6YNzSXqRiNEXNKp5Dk6+mV6nvXKoqtbZBWERryHD7YfJreuE1Hv4
         HxZBfCej2HGejD3uJbgyQ+JjzP1PBropx0KJM=
Message-ID: <4B460441.6090602@gmail.com>
Date: Thu, 07 Jan 2010 16:56:49 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: don't treat NULL parent_pte as multimapped in mmu_parent_walk()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a kvm_mmu_page is not multimapped but parent_pte is NULL
don't treat it as multimapped and dereference it.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This wasn't tested and maybe I misunderstood so please review.

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4c3e5b2..eb17287 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1031,10 +1031,12 @@ static void mmu_parent_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	struct kvm_mmu_page *parent_sp;
 	int i;
 
-	if (!sp->multimapped && sp->parent_pte) {
-		parent_sp = page_header(__pa(sp->parent_pte));
-		fn(vcpu, parent_sp);
-		mmu_parent_walk(vcpu, parent_sp, fn);
+	if (!sp->multimapped) {
+		if (sp->parent_pte) {
+			parent_sp = page_header(__pa(sp->parent_pte));
+			fn(vcpu, parent_sp);
+			mmu_parent_walk(vcpu, parent_sp, fn);
+		}
 		return;
 	}
 	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)

