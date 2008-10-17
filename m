Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYJQVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYJQVCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYJQVC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:02:28 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45202 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYJQVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:02:27 -0400
Date: Fri, 17 Oct 2008 17:00:13 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, ebiederm@xmission.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       nhorman@tuxdriver.com, akpm@linux-foundation.org
Subject: [PATCH] kexec: fix hang on i386 when panic occurs while
	console_sem is held
Message-ID: <20081017210013.GD23591@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	Theres a corner case in 32 bit x86 kdump at the moment.  When the box
panics via nmi, we call bust_spinlocks(1) to disable sensitivity to the
console_sem (allowing us to print to the console in all cases), but we don't
call crash_kexec, until after we call bust_spinlocks(0), which re-enables
console_sem sensitivity.  The result is that, if we get an nmi while the
console_sem is held and kdump is configured, and we try to print something to
the console during kdump shutdown (which we often do) we deadlock the box.  The
fix is to simply do what 64 bit die_nmi does which is to not call
bust_spinlocks(0) until after we call crash_kexec.  Patch below tested
successfully by me:

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 dumpstack_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1a78180..b361475 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -405,7 +405,6 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 		panic("Non maskable interrupt");
 	console_silent();
 	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
 
 	/*
 	 * If we are in kernel we are probably nested up pretty bad
@@ -416,6 +415,7 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 		crash_kexec(regs);
 	}
 
+	bust_spinlocks(0);
 	do_exit(SIGSEGV);
 }
 
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
