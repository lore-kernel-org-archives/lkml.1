Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYIAQKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYIAQKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYIAQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:10:11 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:6854 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYIAQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:10:10 -0400
Date: Mon, 1 Sep 2008 18:16:42 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: move mtrr cpu cap setting early in early_init_xxxx
Message-Id: <20080901181642.14bfb17f.krzysztof.h1@poczta.fm>
In-Reply-To: <1220242025-15113-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220242025-15113-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: ece2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 21:07:05 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2
> 
> root case:
> 	we move mtrr_bp_init early for mtrr trimming.
> and in early_detect, only read cap from cpuid, so some cpu doesn't have
> that bit in cpuid and need to set workaround bit will have problem.
> 
> need to add early_init_xxxx to preset those bit before mtrr_bp_init
> for those earlier cpus.
> 
> this patch is for 2.6.27
> 
> Reported-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> ---

Your patch works only if the the fix below is applied.

Otherwise, the caps set in the early_cpu_init are reset
in the early_get_cap.

Regards,
Krzysztof

---
>From 808cfe180c1400594a01d6229239d4bf01ca4eea Mon Sep 17 00:00:00 2001
From: Krzysztof Helt <krzysztof.h1@wp.pl>
Date: Tue, 2 Sep 2008 17:29:51 +0200
Subject: [PATCH] x86: delay early cpu initialization until cpuid is done

Move early cpu initialization after cpu
early get cap so the early cpu initialization
can fix up cpu caps.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d3bc82f..f970cbf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -335,11 +335,11 @@ static void __init early_cpu_detect(void)
 
 	get_cpu_vendor(c, 1);
 
+	early_get_cap(c);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
-
-	early_get_cap(c);
 }
 
 /*
-- 
1.5.2.2




----------------------------------------------------------------------
>> Sprawdz, czy do siebie pasujecie!
>> http://link.interia.pl/f1eea

