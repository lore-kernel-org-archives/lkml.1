Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0BMOqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 09:46:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:48807 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0BMOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 09:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FqOkFMVMzC6iQXJrkYk8ynjG2YCUvKZNZsfCi5h/CVIvmWuGUTvkZuMtJchKB8RSoU
         zksSc/kBqT8drUsZtqcM0S7c5Cp2Dlj+b+e/SEAnON+aSqy7fcVzNpJlG1tdwrDGKOk1
         hJl+Eylm0Jy7KspT1woZSRLUwKM4MKxU7TvUU=
Message-ID: <4B76BD0B.2010307@gmail.com>
Date: Sat, 13 Feb 2010 15:54:03 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] iop-adma: redundant/wrong tests in iop_*_count()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we reach the loop, len is at least 1, we only stay in the loop when
len is at least MAX_BYTE_COUNT + 1, MAX_BYTE_COUNT is subtracted in each
iteration. So when we leave the loop, or didn't take it, len is at least 1.
Testing whether len is non-zero appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or are the tests off by one? Then we'll need a different patch...

diff --git a/arch/arm/include/asm/hardware/iop3xx-adma.h b/arch/arm/include/asm/hardware/iop3xx-adma.h
index 1a8c727..9b28f12 100644
--- a/arch/arm/include/asm/hardware/iop3xx-adma.h
+++ b/arch/arm/include/asm/hardware/iop3xx-adma.h
@@ -366,8 +366,7 @@ static inline int iop_chan_xor_slot_count(size_t len, int src_cnt,
 		slot_cnt += *slots_per_op;
 	}
 
-	if (len)
-		slot_cnt += *slots_per_op;
+	slot_cnt += *slots_per_op;
 
 	return slot_cnt;
 }
@@ -389,8 +388,7 @@ static inline int iop_chan_zero_sum_slot_count(size_t len, int src_cnt,
 		slot_cnt += *slots_per_op;
 	}
 
-	if (len)
-		slot_cnt += *slots_per_op;
+	slot_cnt += *slots_per_op;
 
 	return slot_cnt;
 }
@@ -737,10 +735,8 @@ iop_desc_set_zero_sum_byte_count(struct iop_adma_desc_slot *desc, u32 len)
 			i += slots_per_op;
 		} while (len > IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT);
 
-		if (len) {
-			iter = iop_hw_desc_slot_idx(hw_desc, i);
-			iter->byte_count = len;
-		}
+		iter = iop_hw_desc_slot_idx(hw_desc, i);
+		iter->byte_count = len;
 	}
 }
 
