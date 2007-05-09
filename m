Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXEIUEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXEIUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbXEIUDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:03:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXEIUDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:03:55 -0400
Date: Wed, 9 May 2007 12:56:16 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: <ak@suse.de>
Cc: zaitcev@redhat.com, linux-kernel@vger.kernel.org, <joerg.roedel@amd.com>
Subject: Andi, you broke my laptop :-)
Message-Id: <20070509125616.cde56b8e.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi:

The attached patch (actually, git show output) makes my Dell 1501 to hang
on boot. Sorry, I have no clue why... The culprit is found with git bisect.
But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.

Cheers,
-- Pete

commit c5bcb5635a03da3158f121ae20ccbbf72b4fc62a
Author: Andi Kleen <ak@suse.de>
Date:   Wed May 2 19:27:21 2007 +0200

    [PATCH] x86: Use RDTSCP for synchronous get_cycles if possible
    
    RDTSCP is already synchronous and doesn't need an explicit CPUID.
    This is a little faster and more importantly avoids VMEXITs on Hypervisors.
    
    Original patch from Joerg Roedel, but reworked by AK
    Also includes miscompilation fix by Eric Biederman
    
    Cc: "Joerg Roedel" <joerg.roedel@amd.com>
    
    Signed-off-by: Andi Kleen <ak@suse.de>

diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index 0181f9d..3f3c1fa 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -38,6 +38,15 @@ static __always_inline cycles_t get_cycles_sync(void)
 	unsigned eax;
 
 	/*
+  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
+ 	 * and doesn't cause a VMEXIT on Hypervisors
+	 */
+	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
+			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
+	if (ret)
+		return ret;
+
+	/*
 	 * Don't do an additional sync on CPUs where we know
 	 * RDTSC is already synchronous:
 	 */
