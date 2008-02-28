Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYB1UE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYB1UE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYB1UEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:04:47 -0500
Received: from gw.goop.org ([64.81.55.164]:34188 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYB1UEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:04:46 -0500
Message-ID: <47C712EF.1060703@goop.org>
Date: Thu, 28 Feb 2008 12:00:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Christopher S. Aker" <caker@theshore.net>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net>
In-Reply-To: <4772AC8E.7010007@theshore.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------010604020402030607030701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010604020402030607030701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christopher S. Aker wrote:
> Sorry for the noise if this isn't the appropriate venue for this.  I 
> posted this last month to xen-devel:
>
> http://lists.xensource.com/archives/html/xen-devel/2007-11/msg00777.html
>
> I can reliably cause a paravirt_ops Xen guest to hang during intensive 
> IO.  My current recipe is an untar/tar loop, without compression, of a 
> kernel tree.  For example:
>
> wget http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
> bzip2 -d linux-2.6.23.tar.bz2
>
> while true;
>   echo `date`
>   tar xf linux-2.6.23.tar
>   tar cf linux-2.6.23.tar linux-2.6.23
> done
>
> After a few loops, anything that touches the xvd device that hung will 
> get stuck in D state.

I've been running this all night without seeing any problem.  I'm using 
current x86.git#testing with a few local patches, but nothing especially 
relevent-looking.

Could you try the attached patch to see if it makes any difference?

    J

>
> This happens on both a 2.6.16 and 2.6.18 dom0 (3.1.2 tools).  Paravirt 
> guests I've tried that exhibit the problem: 2.6.23.8, 2.6.23.12, and 
> 2.6.24-rc6.  It does *not* occur using the Xensource 2.6.18 domU tree 
> from 3.1.2.  In all cases, the host continues to run fine, nothing out 
> of the ordinary is logged on the dom0 side, xenstore reports the 
> status of the devices is fine.
>
> Can anyone reproduce this problem, or let me know what else I can 
> provide to help track this down?
>
> Thanks,
> -Chris
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization


--------------010604020402030607030701
Content-Type: text/x-patch;
 name="xen-indirect-iret.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xen-indirect-iret.patch"

Subject: xen: use iret instruction all the time

Change iret implementation to not be dependent on direct-access vcpu
structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/enlighten.c |    3 +--
 arch/x86/xen/xen-asm.S   |   11 +++--------
 arch/x86/xen/xen-ops.h   |    2 +-
 3 files changed, 5 insertions(+), 11 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -860,7 +860,6 @@ void __init xen_setup_vcpu_info_placemen
 		pv_irq_ops.irq_disable = xen_irq_disable_direct;
 		pv_irq_ops.irq_enable = xen_irq_enable_direct;
 		pv_mmu_ops.read_cr2 = xen_read_cr2_direct;
-		pv_cpu_ops.iret = xen_iret_direct;
 	}
 }
 
@@ -964,7 +963,7 @@ static const struct pv_cpu_ops xen_cpu_o
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
-	.iret = (void *)&hypercall_page[__HYPERVISOR_iret],
+	.iret = xen_iret,
 	.irq_enable_syscall_ret = NULL,  /* never called */
 
 	.load_tr_desc = paravirt_nop,
===================================================================
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -130,13 +130,8 @@ ENDPATCH(xen_restore_fl_direct)
 	current stack state in whatever form its in, we keep things
 	simple by only using a single register which is pushed/popped
 	on the stack.
-
-	Non-direct iret could be done in the same way, but it would
-	require an annoying amount of code duplication.  We'll assume
-	that direct mode will be the common case once the hypervisor
-	support becomes commonplace.
  */
-ENTRY(xen_iret_direct)
+ENTRY(xen_iret)
 	/* test eflags for special cases */
 	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
 	jnz hyper_iret
@@ -150,9 +145,9 @@ ENTRY(xen_iret_direct)
 	GET_THREAD_INFO(%eax)
 	movl TI_cpu(%eax),%eax
 	movl __per_cpu_offset(,%eax,4),%eax
-	lea per_cpu__xen_vcpu_info(%eax),%eax
+	mov per_cpu__xen_vcpu(%eax),%eax
 #else
-	movl $per_cpu__xen_vcpu_info, %eax
+	movl per_cpu__xen_vcpu, %eax
 #endif
 
 	/* check IF state we're restoring */
===================================================================
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -63,5 +63,5 @@ DECL_ASM(unsigned long, xen_save_fl_dire
 DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
-void xen_iret_direct(void);
+void xen_iret(void);
 #endif /* XEN_OPS_H */

--------------010604020402030607030701--
