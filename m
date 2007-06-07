Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXFGLHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXFGLHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXFGLHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:07:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45320 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXFGLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qIyMc9D/Yk2U6nV3rOwz23g9uWgbePI8TxbGoMNgkFMncZtGGIRYXa6Sa9HY60GQj5wRyfpPeP2gtLpvx27jD3yOK7MwMypBOIpw/KV9ZfykG75MmsMHv5W7MEwwHY2ohYyyccch5GbYbiA1DfgOHktrng3UOfHJEcSJUq5JhVM=
Message-ID: <a781481a0706070407x59c78190n65d9303857feee9c@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:37:32 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386/x86_64: NMI watchdog: Protect smp_call_function() within CONFIG_SMP and some trivialities
Cc: "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Cox" <alan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a. arch/i386/kernel/nmi.c:check_nmi_watchdog() calls
   smp_call_function() unconditionally. Protect it inside
   a #ifdef CONFIG_SMP, as it is meaningless for UP, also
   making i386's version similar to x86_64's.
b. Also update the filename in the comment on top of
   arch/{i386, x86_64}/kernel/nmi.c, while we're editing
   these files.

BTW: smp_call_function() simply returns 0 and
smp_call_function_single() simply returns -EBUSY when !SMP.
These appear to be just some ad hoc values. IMHO, we should
be going BUG() in both these cases because "other" CPUs for
!SMP are undefined / meaningless. [ Copying Alan Cox. ]

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@redhat.com>

---

 arch/i386/kernel/nmi.c   |    4 +++-
 arch/x86_64/kernel/nmi.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

---

diff -ruNp a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c	2007-06-07 12:46:34.000000000 +0530
+++ b/arch/i386/kernel/nmi.c	2007-06-07 15:43:52.000000000 +0530
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/nmi.c
+ *  linux/arch/i386/kernel/nmi.c
  *
  *  NMI watchdog support on APIC systems
  *
@@ -89,8 +89,10 @@ static int __init check_nmi_watchdog(voi

 	printk(KERN_INFO "Testing NMI watchdog ... ");

+#ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+#endif

 	for_each_possible_cpu(cpu)
 		prev_nmi_count[cpu] = per_cpu(irq_stat, cpu).__nmi_count;
diff -ruNp a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c	2007-06-07 12:46:39.000000000 +0530
+++ b/arch/x86_64/kernel/nmi.c	2007-06-07 15:43:13.000000000 +0530
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/nmi.c
+ *  linux/arch/x86_64/kernel/nmi.c
  *
  *  NMI watchdog support on APIC systems
  *
