Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZHUFOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZHUFOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 01:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZHUFOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 01:14:34 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25762 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZHUFOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 01:14:33 -0400
Message-ID: <4A8E2D2A.40600@oracle.com>
Date: Thu, 20 Aug 2009 22:14:18 -0700
From: "tina.yang" <tina.yang@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add debug message to reboot event
References: <4A89AC97.6030109@oracle.com>	<alpine.LNX.2.00.0908181339310.25797@wotan.suse.de>	<20090819135827.168621d8.akpm@linux-foundation.org>	<4A8CB358.4090001@oracle.com> <20090820151024.a60567c7.akpm@linux-foundation.org>
In-Reply-To: <20090820151024.a60567c7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A8E2D2C.0086:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 19 Aug 2009 19:22:16 -0700
> "tina.yang" <tina.yang@oracle.com> wrote:
>
>   
>> Add debug message to detect keyboard vs non-keyboard triggered sysrq-b events.
>> This is to assist postmortem debugging on complicated computing setup with
>> large number of applications involved where reboot event had occurred, but 
>> unclear of its origin.
>>     
>
> I'm still struggling to understand the motivation for the change. 
> There are a large number of ways in which a machine can be rebooted,
> all the way down to a triple-fault.  So it seems fairly arbitrary to
> add additional information to discriminate between just two of those
> ways.
>
> I assume that somewhere in your setup you have a script which does
> `echo b /proc/sysrq-trigger' and it took ages to work out that this was
> happening and you felt that having this code in place would have
> helped you debug that problem, yes?
>
> If so, I wonder what is the likelihood that someone else will have the
> same problem and will find this change useful.
>   
    Exactly what you've described except we are debugging someone else's
    (customers') setup remotely without familiarity of their environment
    and often with a time constraint.  The setup usually involves
    large database clusters and who knows what else are running there. 
    I think people in a comparable environment can benefit from a little
    more debug help from the system as we can.

> Perhaps we should do this for all sysrq events rather than just sysrq-b?
>
>
>   
    From a system perspective, I agree generalization of message handling is
    better.  The most critical one we have experienced is the reboot event.

>> --- linux-2.6.18.i686/drivers/char/sysrq.c.orig	2009-08-13 10:55:57.526459000 -0700
>> +++ linux-2.6.18.i686/drivers/char/sysrq.c	2009-08-13 10:58:10.798739000 -0700
>>     
>
> 2.6.18 is truly ancient and this patch doesn't apply at all to
> current development kernels.
>
>   
    Sorry grabbed the wrong one.

--- linux-2.6.git/drivers/char/sysrq.c.orig	2009-08-13 15:43:34.000000000 -0700
+++ linux-2.6.git/drivers/char/sysrq.c	2009-08-20 20:40:50.287922000 -0700
@@ -135,17 +135,22 @@ static struct sysrq_key_op sysrq_crash_o
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
-static void sysrq_handle_reboot(int key, struct tty_struct *tty)
+static void sysrq_handle_reboot(int check_mask, int key, struct tty_struct *tty)
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
 
 static void sysrq_handle_sync(int key, struct tty_struct *tty)
@@ -509,7 +514,10 @@ void __handle_sysrq(int key, struct tty_
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
-			op_p->handler(key, tty);
+			if (op_p->handler_with_mask)
+				op_p->handler_with_mask(check_mask, key, tty);
+			else
+				op_p->handler(key, tty);
 		} else {
 			printk("This sysrq operation is disabled.\n");
 		}
--- linux-2.6.git/include/linux/sysrq.h.orig	2009-08-13 20:53:48.085786000 -0700
+++ linux-2.6.git/include/linux/sysrq.h	2009-08-13 20:54:12.625756000 -0700
@@ -32,6 +32,7 @@ struct tty_struct;
 
 struct sysrq_key_op {
 	void (*handler)(int, struct tty_struct *);
+	void (*handler_with_mask)(int, int, struct tty_struct *);
 	char *help_msg;
 	char *action_msg;
 	int enable_mask;

