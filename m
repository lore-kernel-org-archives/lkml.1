Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190Ab0ADG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0ADG55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 01:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982Ab0ADG54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 01:57:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:34135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0ADG5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 01:57:55 -0500
Message-ID: <4B419113.1090204@kernel.org>
Date: Sun, 03 Jan 2010 22:56:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	 <4B398ECD.1080506@kernel.org> <4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com> <4B415E73.1050801@kernel.org>
In-Reply-To: <4B415E73.1050801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



between FIRST_EXTERNAL_VECTOR (0x20) and FIRST_DEVICE_VECTOR (0x41)

for 0x20 and 0x2f, we are safe be used_vectors will prevent it to use used one.

also try to reuse 0x30 to 0x3f after smp_affinity for irq[0,15] is changed to other cpu.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1162,7 +1162,8 @@ __assign_irq_vector(int irq, struct irq_
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_vector = FIRST_EXTERNAL_VECTOR + 1;
+	static int current_offset = 0;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
@@ -1198,7 +1199,7 @@ next:
 		if (vector >= first_system_vector) {
 			/* If out of vectors on large boxen, must share them. */
 			offset = (offset + 1) % 8;
-			vector = FIRST_DEVICE_VECTOR + offset;
+			vector = FIRST_EXTERNAL_VECTOR + 1 + offset;
 		}
 		if (unlikely(current_vector == vector))
 			continue;
