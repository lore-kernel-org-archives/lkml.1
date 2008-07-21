Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYGUO6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYGUO6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYGUO6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:58:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34870 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYGUO6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:58:32 -0400
Date: Mon, 21 Jul 2008 17:58:26 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Tan Li <li.tan@intel.com>, Jerone Young <jyoung5@us.ibm.com>,
       Hollis Blanchard <hollisb@us.ibm.com>, Avi Kivity <avi@qumranet.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] KVM: fix userspace ABI breakage
Message-ID: <20080721145826.GA14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following part of commit 9ef621d3be56e1188300476a8102ff54f7b6793f 
(KVM: Support mixed endian machines) changed on the size of a struct 
that is exported to userspace:

include/linux/kvm.h:

@@ -318,14 +318,14 @@ struct kvm_trace_rec {
 	__u32 vcpu_id;
 	union {
 		struct {
-			__u32 cycle_lo, cycle_hi;
+			__u64 cycle_u64;
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} cycle;
 		struct {
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} nocycle;
 	} u;
-};
+} __attribute__((packed));
 

Packing a struct was the correct idea, but it packed the wrong struct.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
857d4ddbb62bc61e44b8870cda8ea1c38c6e1905 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0ea064c..ad11cfe 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -320,12 +320,12 @@ struct kvm_trace_rec {
 		struct {
 			__u64 cycle_u64;
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
-		} cycle;
+		} __attribute__((packed)) cycle;
 		struct {
 			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
 		} nocycle;
 	} u;
-} __attribute__((packed));
+};
 
 #define KVMIO 0xAE
 

