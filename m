Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZHTCWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZHTCWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZHTCWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:22:32 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:49499 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZHTCWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:22:32 -0400
Message-ID: <4A8CB358.4090001@oracle.com>
Date: Wed, 19 Aug 2009 19:22:16 -0700
From: "tina.yang" <tina.yang@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add debug message to reboot event
References: <4A89AC97.6030109@oracle.com>	<alpine.LNX.2.00.0908181339310.25797@wotan.suse.de> <20090819135827.168621d8.akpm@linux-foundation.org>
In-Reply-To: <20090819135827.168621d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt015.oracle.com [141.146.116.24]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A8CB359.014A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug message to detect keyboard vs non-keyboard triggered sysrq-b events.
This is to assist postmortem debugging on complicated computing setup with
large number of applications involved where reboot event had occurred, but 
unclear of its origin.

Signed-off-by: Tina Yang <Tina.Yang@oracle.com>
Signed-off-by: Zach Brown <Zach.Brown@oracle.com>

---

--- linux-2.6.18.i686/drivers/char/sysrq.c.orig	2009-08-13 10:55:57.526459000 -0700
+++ linux-2.6.18.i686/drivers/char/sysrq.c	2009-08-13 10:58:10.798739000 -0700
@@ -112,18 +112,23 @@ static struct sysrq_key_op sysrq_crashdu
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
-static void sysrq_handle_reboot(int key, struct pt_regs *pt_regs,
+static void sysrq_handle_reboot(int check_mask, int key, struct pt_regs *pt_regs,
 				struct tty_struct *tty)
 {
+	if (check_mask)
+		printk("<keyboard-invoked>\n");
+	else
+		printk("<non-keyboard-invoked: PID %d COMMAND %s>\n",
+			current->pid, current->comm);
 	lockdep_off();
 	local_irq_enable();
 	emergency_restart();
 }
 static struct sysrq_key_op sysrq_reboot_op = {
-	.handler	= sysrq_handle_reboot,
-	.help_msg	= "reBoot",
-	.action_msg	= "Resetting",
-	.enable_mask	= SYSRQ_ENABLE_BOOT,
+	.handler_with_mask	= sysrq_handle_reboot,
+	.help_msg		= "reBoot",
+	.action_msg		= "Resetting",
+	.enable_mask		= SYSRQ_ENABLE_BOOT,
 };
 
 static void sysrq_handle_sync(int key, struct pt_regs *pt_regs,
@@ -411,7 +416,10 @@ void __handle_sysrq(int key, struct pt_r
 			}
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
-			op_p->handler(key, pt_regs, tty);
+			if (op_p->handler_with_mask)
+				op_p->handler_with_mask(check_mask, key, pt_regs, tty);
+			else
+				op_p->handler(key, pt_regs, tty);
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}
--- linux-2.6.18.i686/include/linux/sysrq.h.orig	2009-08-13 10:58:29.779925000 -0700
+++ linux-2.6.18.i686/include/linux/sysrq.h	2009-08-13 11:05:30.723865000 -0700
@@ -28,6 +28,7 @@ struct tty_struct;
 
 struct sysrq_key_op {
 	void (*handler)(int, struct pt_regs *, struct tty_struct *);
+	void (*handler_with_mask)(int check_mask, int, struct pt_regs *, struct tty_struct *);
 	char *help_msg;
 	char *action_msg;
 	int enable_mask;


Andrew Morton wrote:
>
> The changelog had no description of why the change should be applied
> and I was unable to understand the motivation from reading the patch,
> so I skipped it.
>
> Also the patch was wordwrapped and had all its tabs replaced by spaces.
>   

