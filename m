Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYJFMsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYJFMsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYJFMsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:48:45 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:17996 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYJFMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:48:45 -0400
X-Greylist: delayed 3920 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 08:48:44 EDT
Message-ID: <48E9F9C9.6060609@siemens.com>
Date: Mon, 06 Oct 2008 13:43:05 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: KGDB: x86: Avoid invoking kgdb_nmicallback twice per NMI
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stress-testing KVM's latest NMI support with kgdbts inside an SMP guest,
I came across spurious unhandled NMIs while running the singlestep test.
Looking closer at the code path each NMI takes when KGDB is enabled, I
noticed that kgdb_nmicallback is called twice per event: One time via
DIE_NMI_IPI notification, the second time on DIE_NMI. Removing the first
invocation cures the unhandled NMIs here.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kernel/kgdb.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: b/arch/x86/kernel/kgdb.c
===================================================================
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -455,12 +455,7 @@ static int __kgdb_notify(struct die_args
 		return NOTIFY_DONE;
 
 	case DIE_NMI_IPI:
-		if (atomic_read(&kgdb_active) != -1) {
-			/* KGDB CPU roundup */
-			kgdb_nmicallback(raw_smp_processor_id(), regs);
-			was_in_debug_nmi[raw_smp_processor_id()] = 1;
-			touch_nmi_watchdog();
-		}
+		/* Just ignore, we will handle the roundup on DIE_NMI. */
 		return NOTIFY_DONE;
 
 	case DIE_NMIUNKNOWN:

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
