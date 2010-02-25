Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab0BYRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:16:12 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52019
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932947Ab0BYRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:16:07 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYEQMD-02-N9L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] KVM: SVM: Move msrpm offset calculation to seperate function
Date: Thu, 25 Feb 2010 18:15:45 +0100
Message-ID: <1267118149-15737-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Feb 2010 17:15:52.0349 (UTC) FILETIME=[2ED614D0:01CAB63E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
index df6f491..d8d4e35 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -198,6 +198,28 @@ static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 #define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
+#define MSR_INVALID	0xffffffff
+
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
 
 #define MAX_INST_SIZE 15
 
@@ -417,23 +439,22 @@ err_1:
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
+
+	BUG_ON(offset == MSR_INVALID);
+
+	tmp = msrpm[offset];
+
+	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+
+	msrpm[offset] = tmp;
 }
 
 static void svm_vcpu_init_msrpm(u32 *msrpm)
-- 
1.7.0


