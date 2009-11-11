Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZKKTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZKKTD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbZKKTD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:03:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:50769 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168AbZKKTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mHdnuF/KdaKKLJmX7tTJAtu2PYDVdZdY/cfjEdRTv9mnYkVJ5wcVJUroxSALa9mJUL
         8DuY9NajRsY1n7pCaFgFmPC/+si7cmVUtctopgDvREoUXpEU8CHerndGXJcXA/Te4+vv
         DcD5KWUk/JtPI33VHkfs6GtOxKBPI9WhjwC2Y=
Date: Wed, 11 Nov 2009 20:03:29 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, dimm <dmitry.adamushko@gmail.com>
Subject: [PATCH] x86, ucode-amd: Ensure ucode update on suspend/resume
 after CPU off/online cycle
Message-ID: <20091111190329.GF18592@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching a CPU offline/online and then doing suspend/resume,
ucode is not updated on this CPU.

This is due to the microcode_fini_cpu() call which frees uci->mc
when setting the CPU offline:

  static void microcode_fini_cpu_amd(int cpu)
  {
          struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

          vfree(uci->mc);
          uci->mc = NULL;
  }

When the CPU is set online uci->mc is still NULL because no ucode
update is required.

Finally this prevents ucode update when resuming after suspend:

  static enum ucode_state microcode_resume_cpu(int cpu)
  {
        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

        if (!uci->mc)
                return UCODE_NFOUND;

        ...
  }

Fix is to check whether uci->mc is valid before microcode_resume_cpu()
is called.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 230fb09..e68aae3 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -391,7 +391,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (uci->valid)
+	if (uci->valid && uci->mc)
 		ustate = microcode_resume_cpu(cpu);
 	else
 		ustate = microcode_init_cpu(cpu);
-- 
1.6.5.2

