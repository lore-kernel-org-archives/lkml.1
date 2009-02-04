Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZBDAB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZBDAB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZBDABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:01:48 -0500
Received: from gw.goop.org ([64.81.55.164]:51422 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbZBDABs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:01:48 -0500
Message-ID: <4988DAEA.6040608@goop.org>
Date: Tue, 03 Feb 2009 16:01:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH] xen: disable interrupts before saving in percpu
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_mc_batch has a small preempt race where it takes the address of a
percpu variable immediately before disabling interrupts, thereby
leaving a small window in which we may migrate to another cpu and save
the flags in the wrong percpu variable.  Disable interrupts before
saving the old flags in a percpu.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -19,8 +19,10 @@
    paired with xen_mc_issue() */
 static inline void xen_mc_batch(void)
 {
+	unsigned long flags;
 	/* need to disable interrupts until this entry is complete */
-	local_irq_save(__get_cpu_var(xen_mc_irq_flags));
+	local_irq_save(flags);
+	__get_cpu_var(xen_mc_irq_flags) = flags;
 }
 
 static inline struct multicall_space xen_mc_entry(size_t args)


