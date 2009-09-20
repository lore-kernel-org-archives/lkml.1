Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZITSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZITSa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZITSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:52207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbZITSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:53 -0400
Date: Sun, 20 Sep 2009 18:30:20 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akataria@vmware.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akataria@vmware.com, mingo@elte.hu
In-Reply-To: <1252095219.12518.13.camel@ank32.eng.vmware.com>
References: <1252095219.12518.13.camel@ank32.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Print the hypervisor returned tsc_khz during boot
Message-ID: <tip-6399c087458859cddff2d6b46befb95b866df3e0@git.kernel.org>
Git-Commit-ID: 6399c087458859cddff2d6b46befb95b866df3e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:30:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6399c087458859cddff2d6b46befb95b866df3e0
Gitweb:     http://git.kernel.org/tip/6399c087458859cddff2d6b46befb95b866df3e0
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Fri, 4 Sep 2009 13:13:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:25:36 +0200

x86: Print the hypervisor returned tsc_khz during boot

On an AMD-64 system the processor frequency that is printed during
system boot, may be different than the tsc frequency that was
returned by the hypervisor, due to the value returned from
calibrate_cpu.

For debugging timekeeping or other related issues it might be
better to get the tsc_khz value returned by the hypervisor.

The patch below now prints the tsc frequency that the VMware
hypervisor returned.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1252095219.12518.13.camel@ank32.eng.vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/vmware.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 0a46b4d..1cbed97 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -58,6 +58,9 @@ static unsigned long vmware_get_tsc_khz(void)
 	tsc_hz = eax | (((uint64_t)ebx) << 32);
 	do_div(tsc_hz, 1000);
 	BUG_ON(tsc_hz >> 32);
+	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
+			 (unsigned long) tsc_hz / 1000,
+			 (unsigned long) tsc_hz % 1000);
 	return tsc_hz;
 }
 
@@ -69,6 +72,9 @@ void __init vmware_platform_setup(void)
 
 	if (ebx != UINT_MAX)
 		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
+	else
+		printk(KERN_WARNING
+		       "Failed to get TSC freq from the hypervisor\n");
 }
 
 /*
