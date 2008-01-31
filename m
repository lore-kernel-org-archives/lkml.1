Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYAaI2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYAaI2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbYAaI1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:27:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:11174 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762051AbYAaI1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:27:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="255965285"
Subject: Re: [PATCH 2/5] x86: c_p_a clflush_cache_range fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200801310840.25221.ak@suse.de>
References: <1201764962.12950.23.camel@caritas-dev.intel.com>
	 <200801310840.25221.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 16:27:53 +0800
Message-Id: <1201768073.21226.2.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 08:26:51.0354 (UTC) FILETIME=[076F9BA0:01C863E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 08:40 +0100, Andi Kleen wrote:
> On Thursday 31 January 2008 08:36:02 Huang, Ying wrote:
> > Because in i386 early boot stage, boot_cpu_data may be not available,
> > which makes clflush_cach_range() into infinite loop, which is called
> > by change_page_attr(). This patch fixes this by providing a default
> > clflush_size of 64. But the better method may be providing a
> > early_identify_cpu() for i386.
> 
> There already is one. arch/x86/kernel/cpu/common.c:early_cpu_detect 
> Just set it to 64 there.

Thanks. The following is a new patch based on your reminding.

--------------------------------------------------------------------

Because in i386 early boot stage, boot_cpu_data may be not available,
which makes clflush_cach_range() into infinite loop, which is called
by change_page_attr(). This patch fixes this by setting
boot_cpu_data.x86_clflush_size in early_cpu_detect().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/cpu/common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -274,8 +274,10 @@ void __init cpu_detect(struct cpuinfo_x8
 		if (c->x86 >= 0x6)
 			c->x86_model += ((tfms >> 16) & 0xF) << 4;
 		c->x86_mask = tfms & 15;
-		if (cap0 & (1<<19))
+		if (cap0 & (1<<19)) {
 			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
+			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+		}
 	}
 }
 static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
@@ -317,6 +319,7 @@ static void __init early_cpu_detect(void
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
 	c->x86_cache_alignment = 32;
+	c->x86_clflush_size = 32;
 
 	if (!have_cpuid_p())
 		return;

