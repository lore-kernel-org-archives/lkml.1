Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZEENqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZEENqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZEENp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:45:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36942 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZEENp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:45:57 -0400
Date: Tue, 5 May 2009 09:45:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
       nhorman@tuxdriver.com
Subject: [PATCH] sysrq: Simplify sysrq-c handler
Message-ID: <20090505134547.GA11780@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the sysrq-c handler is bit over-engineered.  Its behavior is dependent
on a few compile time and run time factors that alter its behavior which is
really unnecessecary.  If CONFIG_KEXEC is not configured, sysrq-c, crashes the
system with a NULL pointer dereference.  If CONFIG_KEXEC is configured, it calls
crash_kexec directly, which implies that the kexec kernel will either be booted
(if its been previously loaded), or it will simply do nothing (the no kexec
kernel has been loaded).  It would be much easier to just simplify the whole
thing to dereference a NULL pointer all the time regardless of configuration.
That way, it will always try to crash the system, and if a kexec kernel has been
loaded into reserved space, it will still boot from the page fault trap handler
(assuming panic_on_oops is set appropriately).

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 sysrq.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)


diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index b0a6a3e..9319e75 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -120,20 +120,17 @@ static struct sysrq_key_op sysrq_unraw_op = {
 #define sysrq_unraw_op (*(struct sysrq_key_op *)0)
 #endif /* CONFIG_VT */
 
-#ifdef CONFIG_KEXEC
-static void sysrq_handle_crashdump(int key, struct tty_struct *tty)
+static void sysrq_handle_crash(int key, struct tty_struct *tty)
 {
-	crash_kexec(get_irq_regs());
+	void *killer = NULL;
+	*killer = 1;
 }
 static struct sysrq_key_op sysrq_crashdump_op = {
-	.handler	= sysrq_handle_crashdump,
-	.help_msg	= "Crashdump",
-	.action_msg	= "Trigger a crashdump",
+	.handler	= sysrq_handle_crash,
+	.help_msg	= "Crash",
+	.action_msg	= "Trigger a crash",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
-#else
-#define sysrq_crashdump_op (*(struct sysrq_key_op *)0)
-#endif
 
 static void sysrq_handle_reboot(int key, struct tty_struct *tty)
 {
