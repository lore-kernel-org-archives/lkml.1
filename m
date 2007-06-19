Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXFSUl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXFSUl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXFSUlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:41:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326AbXFSUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=din6O+qYyUPkQwzYQ0cX3HKW3fZgM+Qvv+9nwehz5sbMzLOYf2i/tEE2Z5HSOuNX6VZlgzgtsI+R3cdv2hl19jAKgraqQj6RUFVYyzu4i3NHO5YmPJiD5Mn0+TwjbrjH00P2L+nlhJPq4T88Y+ZOnUZ6md3hO66vPxi/Vdxrpqg=
Date: Tue, 19 Jun 2007 22:41:38 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: kvm-devel@lists.sourceforge.net
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kvm: avoid useless memory write when possible
Message-ID: <20070619204138.GB18800@dreamland.darkstar.lan>
References: <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan> <4673949B.1070505@qumranet.com> <20070617151452.GA21971@dreamland.darkstar.lan> <4675523C.9020703@qumranet.com> <20070617165201.GA23885@dreamland.darkstar.lan> <46765954.60102@qumranet.com> <46766D57.8040206@qumranet.com> <20070619202524.GA17672@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619202524.GA17672@dreamland.darkstar.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to normal memory and the memory area is unchanged the write
can be safely skipped, avoiding the costly kvm_mmu_pte_write.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

---
 Tested with Fedora7, Solaris10 and WinXP on a 32 bit host with Intel
 CPU.

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
Regole per la felicit?:
1. Sii soddisfatto di quello che hai.
2. Assicurati di avere tutto.
