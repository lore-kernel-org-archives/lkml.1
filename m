Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZHHXRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZHHXRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZHHXRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:17:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:39564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZHHXRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=p0bN8tM4HGF1NkqJ/ej7F7akxN4pPO51mPzMvuaxjSbG43WbP6yqvJNDgbIrWQ+4TA
         Veet8QJtKr6R/tCCIb8ns19Ns/meZ9kwQeJw/AC+vbAtTrERXjYbcRR0x5NwAOdZgnL2
         Kqt7nt2xEdYh4DVRbpNMra4JfqqX13gQzjG9M=
Message-ID: <4A7E0797.7060504@gmail.com>
Date: Sat, 08 Aug 2009 20:17:43 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: [PATCH v2] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
In-Reply-To: <20090808152016.GB25374@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
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
 arch/x86/kernel/cpu/amd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..7b52787 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly set this feature, but only Revisions
+		 * D (Extended Model = 1) and E (Extended Model = 2) actually
+		 * support it.
+		 */
+		if (!(level & 0x00030000))
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-- 
1.6.4


