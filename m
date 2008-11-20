Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYKTEAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYKTEAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYKTEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:00:12 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50477 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYKTEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:00:11 -0500
Message-ID: <4924E0C7.8000003@ct.jp.nec.com>
Date: Wed, 19 Nov 2008 20:00:07 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <4921FC19.1080803@kernel.org>
In-Reply-To: <4921FC19.1080803@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Ingo Molnar wrote:
>> hm, one of my testboxes is rather unhappy about your patch:
> 
> 
> please check
> 
> if you agree, will update update_genapic to autodetect other functions or etc.
> 
> YH
> 
> ---
> 
> [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2 - fix
> 
> Impact: fix wakeup_secondary_cpu with hotplug
> 
> We can not put that in x86_quirks, because that is __initdata.
> So try to move that to genapic, and add update_genapic in x86_quirks.
> 
> later we even could use that stub to
> 1. autodetect CONFIG_ES7000_CLUSTERED_APIC
> 2. more correct inquire_remote_apic with apic_verbosity setting.

Hi,

I encountered boot failure on x86_32 box.
I think setting wakeup_cpu is missing.

--------
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: genapic: fix missing wakeup_cpu setup

Impact: fix boot failure

There is no way to setup wakeup_cpu when boot parameter apic= is not passed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/mach-generic/probe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index 90b134f..bde6e36 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -98,6 +98,9 @@ void __init generic_apic_probe(void)
 		/* Not visible without early console */
 		if (!apic_probe[i])
 			panic("Didn't find an APIC driver");
+
+		if (x86_quirks->update_genapic)
+			x86_quirks->update_genapic();
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", genapic->name);
 }
-- 
1.5.6

