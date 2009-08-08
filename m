Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbZHHLxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbZHHLxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZHHLxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:53:37 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:37608 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZHHLxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=cfzxbaH5UFBDED2VCBvKduFyFZkL8fKCcGrZNFiAmkqBmC8ZFa3P/OdKZMbWN6vQht
         MCcuf6jQID2LqK/6ZCa/Rz+397HVslTSDPcMSbKYbb/x11cN9PVNwd2YAlUXdgMZf+g4
         bk1o1EdIKr3aatbGwxnyEfKBERUhpIXi5GAz8=
Message-ID: <4A7D673A.1090401@gmail.com>
Date: Sat, 08 Aug 2009 08:53:30 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
need to force enable the LAHF_LM capability.  Unfortunately, in at
least one case, the BIOS does this even for processors that do not
support the functionality.

Add a specific check that will clear the feature bit for processors
known not to support the LAHF/SAHF instructions.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---

While making this change, I noticed the clause above my code:

    if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)

It does not seem concerned with the possibility that some of the
upper 16 bits of level will be non-zero.  Is this intentional, or
should the upper 16 bits be masked off before the comparisons?

 arch/x86/kernel/cpu/amd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..a2f0fe4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly set this feature, but only
+		 * Revision E (with Extended Model = 2) actually supports
+		 * it.
+		 */
+		if (!(level & 0x00020000))
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-- 
1.6.4


