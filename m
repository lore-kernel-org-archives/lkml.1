Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZJ2Pgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZJ2Pgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZJ2Pgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:36:39 -0400
Received: from claw.goop.org ([74.207.240.146]:50069 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZJ2Pgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:36:39 -0400
Message-ID: <4AE7A816.3050607@goop.org>
Date: Tue, 27 Oct 2009 19:10:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de> <4AE67506.2040200@goop.org> <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de> <4AE73973.3070709@goop.org> <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/09 12:01, Christian Kujau wrote:
> On Tue, 27 Oct 2009 at 11:18, Jeremy Fitzhardinge wrote:
>   
>> $ gdb vmlinux
>> (gdb) x/i 0xffffffff812c50ad
>>     
> The value is always ffffffff812c50ad, gdb says:
>
> (gdb) x/i 0xffffffff812c50ad
> 0xffffffff812c50ad <xen_load_gdt_boot+252>:     ud2a  
>   

Please try the patch below.

>> Hm, sounds like a xenstored bug, or something is just pounding on it. 
>> Are there any other domains running, or other busy processes?
>>     
> Yes, there's another domU running. But the high load and xenstored 
> spinning is only happening when I try to start the domain with this 
> 2.6.32-rc kernel.
>   

That seems unlikely to be related (or a secondary effect of having a
domain crash).

    J

Subject: [PATCH] xen: set up mmu_ops before trying to set any ptes

xen_setup_stackprotector() ends up trying to set page protections,
so we need to have vm_mmu_ops set up before trying to do so.
Failing to do so causes an early boot crash.

[ Impact: Fix early crash under Xen. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 3439616..23a4d80 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1075,6 +1075,8 @@ asmlinkage void __init xen_start_kernel(void)
 	 * Set up some pagetable state before starting to set any ptes.
 	 */
 
+	xen_init_mmu_ops();
+
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
 	if (!xen_initial_domain())
@@ -1099,7 +1101,6 @@ asmlinkage void __init xen_start_kernel(void)
 	 */
 	xen_setup_stackprotector();
 
-	xen_init_mmu_ops();
 	xen_init_irq_ops();
 	xen_init_cpuid_mask();
 


