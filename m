Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZHJW4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZHJW4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZHJW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:56:48 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45505 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZHJW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iXzH+2v1/ePfynSsK95lBelI+IR9xydGZkD1ms7cYAPa7XAaa5CXr+Iokdb4KwFtJ6
         dPBG1ZVUOyCfBt2JIDVBIeiWks+stAUomUoLGk41t6E/gPcyeyKQFMLdVTlU4p15cepp
         7eWvu3Sa0ZR7gHKewXPbN3ov8BBKIhB0HnVU8=
Message-ID: <4A80A5AD.2000209@gmail.com>
Date: Mon, 10 Aug 2009 19:56:45 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic> <4A7E0797.7060504@gmail.com> <20090810131219.GD21879@aftab>
In-Reply-To: <20090810131219.GD21879@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=iso-8859-1
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
 arch/x86/kernel/cpu/amd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..63fddcd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly force this feature, but only K8
+		 * revision D (model = 0x14) and later actually support it.
+		 */
+		if (c->x86_model < 0x14)
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-- 
1.6.4


