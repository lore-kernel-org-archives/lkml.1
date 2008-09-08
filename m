Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYIHHlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYIHHlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 03:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYIHHlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 03:41:10 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52876 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751237AbYIHHlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 03:41:08 -0400
Date: Mon, 8 Sep 2008 13:07:32 +0530
From: Chirag Jog <chirag@linux.vnet.ibm.com>
To: xavier droubay <xavier.droubay@gmail.com>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Convert tlbstate_lock spin_lock to raw_spin_lock
Message-ID: <20080908073732.GC5798@linux.vnet.ibm.com>
Reply-To: Chirag Jog <chirag@linux.vnet.ibm.com>
Mail-Followup-To: xavier droubay <xavier.droubay@gmail.com>,
	linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <2c6d8d720809071806i54e58093vf87bec5175d9b074@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <2c6d8d720809071806i54e58093vf87bec5175d9b074@mail.gmail.com>
Organization: IBM LTC
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* xavier droubay <xavier.droubay@gmail.com> [2008-09-08 03:06:51]:

> Hello,
> 
> I experienced this "rtmutex.c:743" known bug with rt3 patch, using
> 
>  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.3.tar.bz2
>  http://rt.et.redhat.com/download/patch-2.6.26.3-rt3.bz2
> 
> I compiled this kernel with the "make-kpkg" debian utility.
> 
> I first compiled this kernel with NO SMP, NO HIGHMEM, and partial ACPI
> (without fan, processor, ... modules). Attached file
> "config-2.6.26.3-rt3lowlty.frwr.gz".
> I didn't experience any problem with this kernel.
> 
> I then enabled SMP and HIGHMEM, and experienced  "rtmutex.c:743" BUG.
> Attached files
> "config-2.6.26.3-rt3rt-smp-hm.gz" and  "dmesg.gz" for some BUGGY message.
> 
> 
> I have seen somewhere on the archive, that some people still
> experienced problems with SMP.
> I guess no fix has been done from rt3 to rt7 patch. Can you confirm?
> 
> If so, which recent kernel should I use in order to get smp and rt
> running without problems?
> 
This simple patch should solve the above problem. Seeing the config, its
seems to be a 32bit box.


It convert tlbstate_lock spin_lock to raw_spin_lock.
Preemption has already been disabled, hence this change shouldn't
affect latency numbers.


Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>


diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
index 9bb2363..228849c 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -23,7 +23,7 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
 static cpumask_t flush_cpumask;
 static struct mm_struct *flush_mm;
 static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
+static DEFINE_RAW_SPINLOCK(tlbstate_lock);
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,



