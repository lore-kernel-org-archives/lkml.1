Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZDNQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZDNQzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZDNQy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:54:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52017 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076AbZDNQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:54:56 -0400
Subject: Re: [PATCH 01/14] [VOYAGER] x86: add {safe,hard}_smp_processor_id
	to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090414163143.GB12888@lenovo>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090414163143.GB12888@lenovo>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 16:54:55 +0000
Message-Id: <1239728095.3357.55.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sent to correct cc list this time]
On Tue, 2009-04-14 at 20:31 +0400, Cyrill Gorcunov wrote:
> [James Bottomley - Tue, Apr 14, 2009 at 10:51:27AM -0500]
> | Not having apics, Voyager can't use the default apic implementation of
> | these, it has to read from a special port in the VIC to get the
> | processor ID, so abstract these functions in smp_ops to allow voyager
> | to live simultaneously with the apic code.
> | 
> Hi James, wouldn't it break summit32 platform?
> This snippet from summit_32.c
> 
> static void summit_init_apic_ldr(void)
> {
>       unsigned long val, id;
>       int count = 0;
> --->  u8 my_id = (u8)hard_smp_processor_id();
>       u8 my_cluster = APIC_CLUSTER(my_id);
> 
> if we have CONFIG_SMP _not_ set smp_ops.hard_smp_processor_id
> would be plain NULL deref (or linker warning)? I could be missing something...

I think so, yes, thanks!

Apparently it missed out on the coversion to read_apic_id().

This should fix it up, I'll fold it into the 01 patch

James

---
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9cfe1f4..6e1c7ed 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -206,7 +206,7 @@ static void summit_init_apic_ldr(void)
 {
        unsigned long val, id;
        int count = 0;
-       u8 my_id = (u8)hard_smp_processor_id();
+       u8 my_id = (u8)read_apic_id();
        u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
        u8 lid;
@@ -333,7 +333,7 @@ static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
  */
 static int summit_phys_pkg_id(int cpuid_apic, int index_msb)
 {
-       return hard_smp_processor_id() >> index_msb;
+       return read_apic_id() >> index_msb;
 }
 
 static int probe_summit(void)



