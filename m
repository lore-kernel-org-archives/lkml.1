Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYB0R0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYB0R0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYB0R0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:26:17 -0500
Received: from www.tglx.de ([62.245.132.106]:47165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbYB0R0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:26:16 -0500
Date: Wed, 27 Feb 2008 18:26:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Emelyanov <xemul@openvz.org>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc3 regression] sysctl table check failed:
 /kernel/vsyscall64
In-Reply-To: <47C581AD.60603@openvz.org>
Message-ID: <alpine.LFD.1.00.0802271823500.7583@apollo.tec.linutronix.de>
References: <200802271609.48450.elendil@planet.nl> <47C581AD.60603@openvz.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Pavel Emelyanov wrote:

> Frans Pop wrote:
> > Just tried 2.6.25-rc3 and got the error below. Boot continued normally.
> > Error was not present in rc2.
> > 
> > System is x86_64, dual core Pentium D, Debian unstable.
> > 
> > Cheers,
> > FJP
> > 
> > P.S. Yes, I do have VirtualBox working under 2.6.25 now ;-)
> 
> That's due to commit ce28b9 x86: fix vsyscall wreckage
> 
> The proc_handler initialization is simply dropped for this table,
> but AFAIS from the commit comment this was done simply to disable
> the vsyscall_gtod_data.sysctl_enabled tuning. Did I miss something?

No. I noticed my stupidity already. Patch below is queued for Linus.

Thanks,
	tglx

------------>
Subject: x86: restore vsyscall64 prochandler
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 27 Feb 2008 09:39:52 +0100

commit ce28b9864b853803320c3f1d8de1b81aa4120b14
       x86: fix vsyscall wreckage

removed the prochandler completely. This triggers:
sysctl table check failed: /kernel/vsyscall64  No proc_handler

Restore the sane part of the proc handler.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/vsyscall_64.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6/arch/x86/kernel/vsyscall_64.c
@@ -222,10 +222,19 @@ long __vsyscall(3) venosys_1(void)
 }
 
 #ifdef CONFIG_SYSCTL
+
+static int
+vsyscall_sysctl_change(ctl_table *ctl, int write, struct file * filp,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
+}
+
 static ctl_table kernel_table2[] = {
 	{ .procname = "vsyscall64",
 	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644 },
+	  .mode = 0644,
+	  .proc_handler = vsyscall_sysctl_change },
 	{}
 };
 
