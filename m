Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbYLLSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbYLLSK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbYLLSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:10:45 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:64816 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbYLLSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:10:44 -0500
X-BigFish: VPS-7(z6c9Rzzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBRZTD-02-BWI-01
Date: Fri, 12 Dec 2008 19:10:21 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: re-enable MCE on secondary CPUS after
	suspend/resume
Message-ID: <20081212181021.GU19144@alberich.amd.com>
References: <20081212180650.GS19144@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081212180650.GS19144@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Dec 2008 18:10:32.0510 (UTC) FILETIME=[EC34EDE0:01C95C84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix suspend/resume bug with MCE

After suspend/resume MCx_CTL registers of secondary CPUs are cleared.
(At least that's what I've observed on several systems.)
Linux currently only re-initializes MCE on the boot CPU - see mce_resume().
Thus after suspend/resume we end up with a system where MCE is active
on the boot CPU but switched off on all other CPUs.

By calling mce_init() whenever a CPU comes online this problem is
solved.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index e2d9649..0174539 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -889,6 +889,7 @@ static int __cpuinit mce_cpu_callback(struct notifier_block *nfb,
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mce_init(NULL);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-- 
1.6.0.4



