Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab0CMILZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:11:25 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46816 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab0CMILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qW5Tfo1hnAYIciiCOwWySJziQlYuA4kDBM7xKImi970vKuWUv6yMaoHOmw5k0eBM7b
         lZT7+OfW0BvWTMoYQyHP8QNPcCIApSovqsRPSpykxrmp3hdwjih8Qm+WBMTEDWqsA6/0
         OcZNpJ8oiGYwiBF2Vbo3d1DqKnaHhQD9hatj0=
Date: Sat, 13 Mar 2010 11:11:16 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86,perf: Unmask LVTPC only if we have APIC supported
Message-ID: <20100313081116.GA5179@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo reported
|
| There's a build failure on -tip with the P4 driver, on UP 32-bit, if
| PERF_EVENTS is enabled but UP_APIC is disabled:
|
| arch/x86/built-in.o: In function `p4_pmu_handle_irq':
| perf_event.c:(.text+0xa756): undefined reference to `apic'
| perf_event.c:(.text+0xa76e): undefined reference to `apic'
|

So we have to unmask LVTPC only if we're configured to have one.

Reported-by: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -365,8 +365,10 @@ static int p4_pmu_handle_irq(struct pt_r
 	}
 
 	if (handled) {
+#ifdef CONFIG_X86_LOCAL_APIC
 		/* p4 quirk: unmask it again */
 		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+#endif
 		inc_irq_stat(apic_perf_irqs);
 	}
 
