Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbXDASTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbXDASTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXDASSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:18:51 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40686 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794AbXDASSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:18:37 -0400
Date: Sun, 1 Apr 2007 20:18:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 16/16] warn-on-kthread-name-truncation.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012011430.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton noted in http://lkml.org/lkml/2006/6/30/247

	"""We do occasionally hit task_struct.comm[] truncation, when people
	use "too-long-a-name%d" for their kernel thread names."""

This patch warns when such a truncation happens.

Already posted on http://lkml.org/lkml/2006/7/3/93

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

 kthread.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc5/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/kthread.c
+++ linux-2.6.21-rc5/kernel/kthread.c
@@ -176,8 +176,11 @@ struct task_struct *kthread_create(int (
 	if (!IS_ERR(create.result)) {
 		va_list args;
 		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
+		if(vsnprintf(create.result->comm, sizeof(create.result->comm),
+		  namefmt, args) != strlen(create.result->comm))
+			printk(KERN_WARNING "kthread_create: command name of "
+			  "pid %d truncated to \"%s\"\n", create.result->pid,
+			  create.result->comm);
 		va_end(args);
 	}
 
#<EOF>
