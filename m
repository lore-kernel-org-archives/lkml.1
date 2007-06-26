Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXFZTBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXFZTBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXFZTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:01:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47568 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbXFZTBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:01:22 -0400
Date: Tue, 26 Jun 2007 12:01:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bugme-daemon@bugzilla.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: wbrana@gmail.com
Subject: Re: [Bug 8679] New: Section mismatch: reference to .init.text
Message-Id: <20070626120134.17aa6143.randy.dunlap@oracle.com>
In-Reply-To: <bug-8679-10286@http.bugzilla.kernel.org/>
References: <bug-8679-10286@http.bugzilla.kernel.org/>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 10:46:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8679
> 
>            Summary: Section mismatch: reference to .init.text
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.22-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Configuration
>         AssignedTo: zippel@linux-m68k.org
>         ReportedBy: wbrana@gmail.com
> 
> 
> Software Environment:
> gcc 3.4.6, binutils 2.17
> 
> Problem Description:
> Warnings appeared while building kernel:
> 
> WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
> to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')
> WARNING: kernel/built-in.o(.text+0x15f84): Section mismatch: reference to
> .init.text: (between 'kthreadd' and 'init_waitqueue_head')


I don't see the kernel/built-in.o warning when I build this (I have
binutils 2.16++).  Can you test the patch below to verify that it
fixes the warning?

On the other warning ('thermal_throttle_cpu_notifier'), we have:

static struct notifier_block thermal_throttle_cpu_notifier =
{
	.notifier_call = thermal_throttle_cpu_callback,
};

where CONFIG_CPU_HOTPLUG=n, so __cpuinit == __init in:

static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
						   unsigned long action,
						   void *hcpu)


so CPU hotplug actions should never happen here.  Still, we have
a registered notifier that is in __init space and has been discarded... :(
Any suggestions out there?



---
From: Randy Dunlap <randy.dunlap@oracle.com>

kthreadd_setup() is in an __init section, but we know that it's
safe to be called from kthreadd() since the latter is only called
at kernel init time, so mark kthreadd_setup() __init_refok so
that modpost won't complain about what text section it is in.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc6.orig/kernel/kthread.c
+++ linux-2.6.22-rc6/kernel/kthread.c
@@ -215,7 +215,7 @@ int kthread_stop(struct task_struct *k)
 EXPORT_SYMBOL(kthread_stop);
 
 
-static __init void kthreadd_setup(void)
+static __init_refok void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
 
