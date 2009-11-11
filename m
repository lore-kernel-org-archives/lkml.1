Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbZKKTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbZKKTL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZKKTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:11:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:33284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbZKKTLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:11:25 -0500
Date: Wed, 11 Nov 2009 19:09:47 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, dmitry.adamushko@gmail.com,
       herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091111190329.GF18592@alberich.amd.com>
References: <20091111190329.GF18592@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online cycle
Message-ID: <tip-9f15226e75583547aaf542c6be4bdac1060dd425@git.kernel.org>
Git-Commit-ID: 9f15226e75583547aaf542c6be4bdac1060dd425
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f15226e75583547aaf542c6be4bdac1060dd425
Gitweb:     http://git.kernel.org/tip/9f15226e75583547aaf542c6be4bdac1060dd425
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Wed, 11 Nov 2009 20:03:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 20:06:54 +0100

x86, ucode-amd: Ensure ucode update on suspend/resume after CPU off/online cycle

When switching a CPU offline/online and then doing
suspend/resume, ucode is not updated on this CPU.

This is due to the microcode_fini_cpu() call which frees uci->mc
when setting the CPU offline:

  static void microcode_fini_cpu_amd(int cpu)
  {
          struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

          vfree(uci->mc);
          uci->mc = NULL;
  }

When the CPU is set online uci->mc is still NULL because no
ucode update is required.

Finally this prevents ucode update when resuming after suspend:

  static enum ucode_state microcode_resume_cpu(int cpu)
  {
        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

        if (!uci->mc)
                return UCODE_NFOUND;

        ...
  }

Fix is to check whether uci->mc is valid before
microcode_resume_cpu() is called.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: dimm <dmitry.adamushko@gmail.com>
LKML-Reference: <20091111190329.GF18592@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index d2a8160..adf2340 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -393,7 +393,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (uci->valid)
+	if (uci->valid && uci->mc)
 		ustate = microcode_resume_cpu(cpu);
 	else
 		ustate = microcode_init_cpu(cpu);
