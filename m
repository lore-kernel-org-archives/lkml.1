Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab0CAOfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:35:22 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:35342
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349Ab0CAOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:35:13 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLXTY-01-AWA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] KVM: SVM: Move msrpm offset calculation to seperate function
Date: Mon, 1 Mar 2010 15:34:35 +0100
Message-ID: <1267454080-2513-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 14:34:46.0168 (UTC) FILETIME=[56FEE980:01CAB94C]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The algorithm to find the offset in the msrpm for a given
msr is needed at other places too. Move that logic to its
own function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   53 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9dfbbae..c0c01a8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -116,6 +116,8 @@ struct vcpu_svm {
 	unsigned long int3_rip;
 };
 
+#define MSR_INVALID			0xffffffffU
+
 /* enable NPT for AMD64 and X86 with PAE */
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
@@ -199,6 +201,27 @@ static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
 
+static u32 svm_msrpm_offset(u32 msr)
+{
+	u32 offset;
+	int i;
+
+	for (i = 0; i < NUM_MSR_MAPS; i++) {
+		if (msr < msrpm_ranges[i] ||
+		    msr >= msrpm_ranges[i] + MSRS_IN_RANGE)
+			continue;
+
+		offset  = (msr - msrpm_ranges[i]) / 4; /* 4 msrs per u8 */
+		offset += (i * MSRS_RANGE_SIZE);       /* add range offset */
+
+		/* Now we have the u8 offset - but need the u32 offset */
+		return offset / 4;
+	}
+
+	/* MSR not in any range */
+	return MSR_INVALID;
+}
+
 #define MAX_INST_SIZE 15
 
 static inline u32 svm_has(u32 feat)
@@ -417,23 +440,21 @@ err_1:
 static void set_msr_interception(u32 *msrpm, unsigned msr,
 				 int read, int write)
 {
-	int i;
+	u8 bit_read, bit_write;
+	unsigned long tmp;
+	u32 offset;
 
-	for (i = 0; i < NUM_MSR_MAPS; i++) {
-		if (msr >= msrpm_ranges[i] &&
-		    msr < msrpm_ranges[i] + MSRS_IN_RANGE) {
-			u32 msr_offset = (i * MSRS_IN_RANGE + msr -
-					  msrpm_ranges[i]) * 2;
-
-			u32 *base = msrpm + (msr_offset / 32);
-			u32 msr_shift = msr_offset % 32;
-			u32 mask = ((write) ? 0 : 2) | ((read) ? 0 : 1);
-			*base = (*base & ~(0x3 << msr_shift)) |
-				(mask << msr_shift);
-			return;
-		}
-	}
-	BUG();
+	offset    = svm_msrpm_offset(msr);
+	bit_read  = 2 * (msr & 0x0f);
+	bit_write = 2 * (msr & 0x0f) + 1;
+	tmp       = msrpm[offset];
+
+	BUG_ON(offset == MSR_INVALID);
+
+	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+
+	msrpm[offset] = tmp;
 }
 
 static void svm_vcpu_init_msrpm(u32 *msrpm)
-- 
1.7.0


