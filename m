Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552Ab0AJNAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0AJNAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 08:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042Ab0AJNAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 08:00:25 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6954 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab0AJNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 08:00:23 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, Christian Kujau <lists@nerdbynature.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100110080940.GB5189@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de>
	 <4B4405B5.9040205@goop.org>
	 <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
	 <20100106112133.GA5815@lenovo>
	 <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
	 <4B4633D3.2070903@zytor.com>
	 <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
	 <20100108215039.GD4967@lenovo>
	 <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
	 <20100110080940.GB5189@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 12:59:03 +0000
Message-ID: <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=WUDd807v63sA:10 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=AZfGcq7nAAAA:8 a=OQNzS2De_kqakrVLa04A:9 a=mSVTvEyaHMOdic_sxecA:7 a=iQLbiVoB4wmno1k11xHwZQgvcUMA:4 a=MSl-tDqOz04A:10 a=CY6gl2JlH4YA:10 a=3mskUyRpf7Zx3Fs6:21 a=YuSJgg-zuaVtQAW8:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 11:09 +0300, Cyrill Gorcunov wrote:
> On Sat, Jan 09, 2010 at 08:50:04PM -0500, Brian Gerst wrote:
> ...
> > > ---
> > > x86: kernel_thread -- initialize SS to a known state
> > >
> > > Before the kernel_thread was converted into "C" we had
> > > pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).
> > >
> > > Though I must admit I didn't find any *explicit* load of
> > > %ss from this structure the better to be on a safe side
> > > and set it to a known value.
> > 
> > It shouldn't make any difference, but maybe Xen is doing something
> > subtle.  In 64-bit mode the %ss segment register is supposed to be
> > ignored, which is why it is left set to zero.  It works properly on
> > real hardware.  It can't hurt anything to put __KERNEL_DS back in, but
> > I'd just like to know why Xen requires it if this does fix it.
> 
> Yeah, I didn't found any explicit %ss reloading for this _particular_
> case (as I marked in patch changelog). So the only suspicious is Xen
> itself. So as only Christian get ability to test -- we will see the
> results.

The difference with Xen is that it must squash the RPL of SS (to 3 for
64 bit and 1 for 32 bit, 32 bit doesn't matter here though). Perhaps a
NULL selector can only have RPL==0? (I'm away from my architecture docs
so I can't check). In any case specifying a non-NULL SS selector allows
the squashing to occur correctly.

However this is not the cause of the original "Guest switching to user
mode with no user page tables" error. This is down to 
        commit f443ff4201dd25cd4dec183f9919ecba90c8edc2
        Author: Brian Gerst <brgerst@gmail.com>
        Date:   Wed Dec 9 12:34:43 2009 -0500
        
            x86: Sync 32/64-bit kernel_thread
            
            Signed-off-by: Brian Gerst <brgerst@gmail.com>
            LKML-Reference: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
            Signed-off-by: H. Peter Anvin <hpa@zytor.com>
which on 64 bit resulted in changing regs.cs from "__KERNEL_CS" to
"__KERNEL_CS | get_kernel_rpl()". The later seems more logical (and is
correct for 32 bit) but on 64 bit we frequently use a pattern like "cmpl
$3, CS(%rsp); je foo" quite a bit to detect return to user vs kernel and
an RPL of 1 will unfortunately incorrectly trigger the return to
userspace paths.

The correct fix is for the Xen backend to declare kernel RPL == 0 for 64
bit guests -- the hyervisor already takes care of all the necessary
squashing to ring 3 transparently (because making the guest worry about
it would break the very common assumption that you can distinguish user
from kernel CS by RPL).

With just the CS RPL fix below I see a GPF at kernel_thread_helper with
SS=3 (hence my hypothesis about NULL selectors and non-zero RPL above).
With both the SS and CS fixes things work fine.

Ian.

--- 
Subject: xen: 64 bit kernel RPL should be 0.

Under Xen 64 bit guests actually run their kernel in ring 3, however the
hypervisor takes care of squashing descriptor the RPLs transparently (in
order to allow them to continue to differentiate between user and kernel
space CS using the RPL). Therefore the Xen paravirt backend should use
RPL==0 instead of 1 (or 3). Using RPL==1 causes generic arch code to
take incorrect code paths because it uses "testl $3, <CS>, je foo" type
tests for a userspace CS and this considers 1==userspace.

This issue was previously masked because get_kernel_rpl() was omitted
when setting CS in kernel_thread(). This was fixed when kernel_thread()
was unified with 32 bit in f443ff4201dd25cd4dec183f9919ecba90c8edc2.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2b26dd5..36daccb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1151,9 +1151,13 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* keep using Xen gdt for now; no urgent need to change it */
 
+#ifdef CONFIG_X86_32
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
+#else
+	pv_info.kernel_rpl = 0;
+#endif
 
 	/* set the limit of our address space */
 	xen_reserve_top();
 

-- 
Ian Campbell

BOFH excuse #430:

Mouse has out-of-cheese-error

