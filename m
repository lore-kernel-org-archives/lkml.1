Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbZLQMza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbZLQMza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764571AbZLQMz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:55:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764413AbZLQMzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:55:09 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: -tip: origin tree build failure
From: Andi Kleen <andi@firstfloor.org>
References: <20091217094041.GA24708@elte.hu> <20091217122316.GB14088@elte.hu>
Date: Thu, 17 Dec 2009 13:55:04 +0100
In-Reply-To: <20091217122316.GB14088@elte.hu> (Ingo Molnar's message of "Thu, 17 Dec 2009 13:23:16 +0100")
Message-ID: <87bphxu5ef.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>  config MEMORY_FAILURE
>>  	depends on MMU
>>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>> +	select PROC_PAGE_MONITOR
>>  	bool "Enable recovery from hardware memory errors"
>
> It also needs to depend on PROC_FS in that case - as per the updated patch 
> below.

Thanks for the report.

MEMORY_FAILURE itself doesn't depend on the page flags, just the
injector which has a separate config option. It already has a select
PROC_PAGE_MONITOR, but the proc dependency is indeed missing.

I think the correct fix is the appended patch.

-Andi

---

HWPOISON: Add PROC_FS dependency to hwpoison injector

The injector filter requires stable_page_flags() which is supplied
by procfs. So make it dependent on that.

Reported by Ingo Molnar

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -252,7 +252,7 @@ config MEMORY_FAILURE
 
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
-	depends on MEMORY_FAILURE && DEBUG_KERNEL
+	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
 	select PROC_PAGE_MONITOR
 
 config NOMMU_INITIAL_TRIM_EXCESS
