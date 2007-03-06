Return-Path: <linux-kernel-owner+w=401wt.eu-S965886AbXCFOky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbXCFOky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965888AbXCFOkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:40:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965886AbXCFOkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:40:52 -0500
Message-ID: <45ED7D6B.7010404@redhat.com>
Date: Tue, 06 Mar 2007 15:40:43 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dcbw@redhat.com>
Subject: [PATCH -rt] airo: threaded IRQ handler sleeps forever
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The airo driver tries to avoid excessive latencies when issuing commands
to the card by calling schedule() after several retries. But
issuecommand() can be run from an interrupt handler. The function is
careful enough to check with in_atomic() if it is safe to call schedule().
This check breaks when the interrupt handler is threaded, because then
in_atomic() is always false there. The handler is run as
TASK_INTERRUPTIBLE, so schedule() takes it off the runqueue and it never
wakes up again.
Here's an obvious fix - simply don't call schedule() when using
preemptible hardirqs.
An improved solution might be to identify the commands that take so long
to issue and avoid sending them from the interrupt handler. In my
testing there was only one such command: CMD_ACCESS. I need to
investigate if it's always possible to delay it to airo's kthread.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 44a2270..98014c0 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3938,8 +3938,10 @@ static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp) {
 		if ((IN4500(ai, COMMAND)) == pCmd->cmd)
 			// PC4500 didn't notice command, try again
 			OUT4500(ai, COMMAND, pCmd->cmd);
+#ifndef CONFIG_PREEMPT_HARDIRQS
 		if (!in_atomic() && (max_tries & 255) == 0)
 			schedule();
+#endif
 	}
 
 	if ( max_tries == -1 ) {


