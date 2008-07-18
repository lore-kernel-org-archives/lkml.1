Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYGRW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYGRW6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYGRW6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:58:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:15365 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbYGRW6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="22181169"
Date: Fri, 18 Jul 2008 15:58:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080718225835.GC4507@linux-os.sc.intel.com>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> <20080718105259.GY6875@elte.hu> <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> <20080718210348.GB24373@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718210348.GB24373@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 02:03:48PM -0700, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > > git merge tip/x86/x2apic
> > CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
> > CONFLICT (content): Merge conflict in arch/x86/kernel/paravirt.c
> > CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
> > CONFLICT (content): Merge conflict in arch/x86/kernel/vmi_32.c
> > CONFLICT (content): Merge conflict in arch/x86/xen/enlighten.c
> > CONFLICT (content): Merge conflict in include/asm-x86/apic.h
> > CONFLICT (content): Merge conflict in include/asm-x86/paravirt.h
> 
> that's due to the changes in tip/x86/apic and in tip/x86/uv.
> 
> ok, i've just merged x86/apic into x86/x2apic and x86/uv as well, and
> pushed out the result.
> 
> Note: it's a first raw merge and completely untested. It will now merge
> cleanly into tip/master. There are probably a few details missing.

Ingo, thanks for doing this. While I was testing my merge changes, you posted
yours... anyhow we need this piece, which is missing from your merge.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index dcb897f..8728f54 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -174,8 +174,8 @@ u32 safe_xapic_wait_icr_idle(void)
 
 void xapic_icr_write(u32 low, u32 id)
 {
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(id));
-	apic_write_around(APIC_ICR, low);
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR, low);
 }
 
 u64 xapic_icr_read(void)
@@ -191,7 +191,6 @@ u64 xapic_icr_read(void)
 static struct apic_ops xapic_ops = {
 	.read = native_apic_mem_read,
 	.write = native_apic_mem_write,
-	.write_atomic = native_apic_mem_write_atomic,
 	.icr_read = xapic_icr_read,
 	.icr_write = xapic_icr_write,
 	.wait_icr_idle = xapic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 46e6124..a850bc6 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -167,7 +167,6 @@ u64 xapic_icr_read(void)
 static struct apic_ops xapic_ops = {
 	.read = native_apic_mem_read,
 	.write = native_apic_mem_write,
-	.write_atomic = native_apic_mem_write_atomic,
 	.icr_read = xapic_icr_read,
 	.icr_write = xapic_icr_write,
 	.wait_icr_idle = xapic_wait_icr_idle,
@@ -206,7 +205,6 @@ u64 x2apic_icr_read(void)
 static struct apic_ops x2apic_ops = {
 	.read = native_apic_msr_read,
 	.write = native_apic_msr_write,
-	.write_atomic = native_apic_msr_write,
 	.icr_read = x2apic_icr_read,
 	.icr_write = x2apic_icr_write,
 	.wait_icr_idle = x2apic_wait_icr_idle,
