Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZAaHSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZAaHSv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZAaHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:18:43 -0500
Received: from gw.goop.org ([64.81.55.164]:40942 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZAaHSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:18:42 -0500
Message-ID: <4983FB51.8080008@goop.org>
Date: Fri, 30 Jan 2009 23:18:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: [PATCH 2/2] x86/vmi: fix interrupt enable/disable/save/restore calling
 convention.
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org>
In-Reply-To: <4983DBC9.5080701@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach says:
> Enable/Disable have no clobbers at all.
> Save clobbers only return value, %eax
> Restore also clobbers nothing.

This is precisely compatible with the calling convention, so we can
just call them directly without wrapping.

(Compile tested only.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/vmi_32.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -670,10 +670,11 @@
 	para_fill(pv_mmu_ops.write_cr2, SetCR2);
 	para_fill(pv_mmu_ops.write_cr3, SetCR3);
 	para_fill(pv_cpu_ops.write_cr4, SetCR4);
-	para_fill(pv_irq_ops.save_fl, GetInterruptMask);
-	para_fill(pv_irq_ops.restore_fl, SetInterruptMask);
-	para_fill(pv_irq_ops.irq_disable, DisableInterrupts);
-	para_fill(pv_irq_ops.irq_enable, EnableInterrupts);
+
+	para_fill(pv_irq_ops.save_fl.func, GetInterruptMask);
+	para_fill(pv_irq_ops.restore_fl.func, SetInterruptMask);
+	para_fill(pv_irq_ops.irq_disable.func, DisableInterrupts);
+	para_fill(pv_irq_ops.irq_enable.func, EnableInterrupts);
 
 	para_fill(pv_cpu_ops.wbinvd, WBINVD);
 	para_fill(pv_cpu_ops.read_tsc, RDTSC);


