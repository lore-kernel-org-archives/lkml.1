Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbXFQQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbXFQQwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXFQQwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:52:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32351 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXFQQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DgWa2/K+TPiGL5tq4Raw3CZV1GgtrCPTaNfbxN6E2k1bO0tN71vrgMHgyefDODcqy1LrB8PsRTo9+k0Mj5NjrNBNWKq4rh3s1vQi/mFm3AR71sWraWQPk4OCbI4/QUNAZaGBYXYNumnCr6Y4n7wCH82kD9Z7Y5oPReFF0cb4XCA=
Date: Sun, 17 Jun 2007 18:52:44 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kvm: avoid useless memory write when possible
Message-ID: <20070617165244.GB23885@dreamland.darkstar.lan>
Mail-Followup-To: Avi Kivity <avi@qumranet.com>,
	kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4675523C.9020703@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to normal memory and the memory area is unchanged the write
can be safely skipped, avoiding the costly kvm_mmu_pte_write.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

---

 drivers/kvm/kvm_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 633c2ed..9b7b0b9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1139,8 +1139,10 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return 0;
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
-	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
-	memcpy(virt + offset_in_page(gpa), val, bytes);
+	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
+		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
+		memcpy(virt + offset_in_page(gpa), val, bytes);
+	}
 	kunmap_atomic(virt, KM_USER0);
 	return 1;
 }


Luca
-- 
Se non puoi convincerli, confondili.
