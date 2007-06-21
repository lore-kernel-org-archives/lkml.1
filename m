Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXFURwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXFURwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759640AbXFURw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:52:28 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:11180 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758361AbXFURw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:52:27 -0400
X-BigFish: VP
X-FB-SS: 0,0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Thu, 21 Jun 2007 19:51:22 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] SVM: reliably detect if SVM was disabled by BIOS
Message-ID: <20070621175122.GE25896@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Jun 2007 17:51:32.0997 (UTC)
 FILETIME=[CDF00B50:01C7B42C]
X-WSS-ID: 6A646548R0G895588-01-01
Content-Type: multipart/mixed;
 boundary=z6Eq5LdranGa6ru8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds an implementation to the svm is_disabled function to
detect reliably if the BIOS disabled the SVM feature in the CPU. This
fixes the issues with kernel panics when loading the kvm-amd module on
machines where SVM is available but disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--z6Eq5LdranGa6ru8
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=svm-detect-svm-disable.patch
Content-Transfer-Encoding: 7bit

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index fa17d6d..54aa83a 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1727,6 +1727,12 @@ static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
 
 static int is_disabled(void)
 {
+	uint64_t vm_cr;
+
+	rdmsrl(MSR_VM_CR, vm_cr);
+	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE))
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/kvm/svm.h b/drivers/kvm/svm.h
index 5e93814..005a9c5 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -175,8 +175,11 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CPUID_FUNC 0x8000000a
 
 #define MSR_EFER_SVME_MASK (1ULL << 12)
+#define MSR_VM_CR       0xc0010114ULL
 #define MSR_VM_HSAVE_PA 0xc0010117ULL
 
+#define SVM_VM_CR_SVM_DISABLE 4
+
 #define SVM_SELECTOR_S_SHIFT 4
 #define SVM_SELECTOR_DPL_SHIFT 5
 #define SVM_SELECTOR_P_SHIFT 7

--z6Eq5LdranGa6ru8--


