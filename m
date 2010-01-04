Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579Ab0ADQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0ADQQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408Ab0ADQQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:16:30 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36448 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0ADQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:16:29 -0500
Date: Mon, 4 Jan 2010 17:16:26 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: caiqian@redhat.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results	on s390x)
Message-ID: <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100104155225.GA16650@redhat.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<20100104155225.GA16650@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 16:52:25 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Hi!
> 
> We have some strange problems with utrace on s390, and so far this _looks_
> like a s390 problem.
> 
> Looks like, on any CPU user_enable_single_step() does not "work" until at
> least one thread with per_info.single_step = 1 does the context switch.
> 
> This doesn't matter with the old ptrace implementation, but with utrace
> the tracee itself does user_enable_single_step(current) and returns to
> user-mode. Until it does at least one context switch the single-stepping
> doesn't work, after that everything works fine till the next reboot.

The PER control registers only get reloaded on task switch. Can you test
if this patch fixes your problem?

--
Subject: [PATCH] fix loading of PER control registers for utrace.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

If the current task enables / disables PER tracing for itself the
PER control registers need to be loaded in FixPerRegisters.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/ptrace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -98,6 +98,9 @@ FixPerRegisters(struct task_struct *task
 		per_info->control_regs.bits.storage_alt_space_ctl = 1;
 	else
 		per_info->control_regs.bits.storage_alt_space_ctl = 0;
+
+	if (task == current)
+		__ctl_load(per_info->control_regs.words, 9, 11);
 }
 
 void user_enable_single_step(struct task_struct *task)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

