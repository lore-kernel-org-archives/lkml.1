Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYJWNfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYJWNfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYJWNfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:35:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32881 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYJWNfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KMfGM+jnNmqNSy7xa+uTDswZnRGFlG4h2WpPpZntVsFx0Gku4lowm/3qsQ+uUA94e4
         LtNB1wRwQgR34IS9r86PIvaiRdkjhZ6PAedAADyt4Um+X98JRWZPSFNrrixHfTRzxwc6
         hXu4Y5hBWcioLAfWSyLem7QQX4yIQFt64HW8g=
Message-ID: <49008D12.5090204@gmail.com>
Date: Thu, 23 Oct 2008 16:41:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: kernel/trace/trace.c:658: error:
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>	 <20081023121145.GB27984@x200.localdomain>	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
In-Reply-To: <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2008/10/23 Frédéric Weisbecker <fweisbec@gmail.com>:
>> 2008/10/23 Alexey Dobriyan <adobriyan@gmail.com>:
>>> On alpha-smp-n-debug-y:
>>>
>>> kernel/trace/trace.c: In function 'tracing_generic_entry_update':
>>> kernel/trace/trace.c:658: error: implicit declaration of function 'irqs_disabled_flags'
>>> kernel/trace/trace.c: In function 'tracing_cpumask_write':
>>> kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
>>> kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'
>>> kernel/trace/trace.c: In function 'trace_die_handler':
>>> kernel/trace/trace.c:3039: error: 'DIE_OOPS' undeclared (first use in this function)
>>>
>>> This has something with config dependencies, because adding include doesn't fix it.
>>>
>> A lot of arch have an asm/irqflags.h but not alpha.
>> In linux/irqflags, raw_local_irq_* functions are defined to be
>> local_irq_* function if they don't support
>> CONFIG_TRACE_IRQFLAGS_SUPPORT.
>> It seems the error is here, alpha may turn this option off.
>>
> 
> Hmm no actually your CONFIG_TRACE_IRFLAGS_SUPPORT is not set.
> So that's because the linux/irqflags.h is not included in the
> asm/system.h on alpha (other archs do).
> 

Does this patch correct the issue?
It applies on last -tip
---

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] alpha: include irqflags.h to enable use of tracing

asm/system.h should include linux/irqflags.h to enable the use of tracing
which needs raw_local_irq_* functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/alpha/include/asm/system.h b/arch/alpha/include/asm/system.h
index afe20fa..c1e6dc5 100644
--- a/arch/alpha/include/asm/system.h
+++ b/arch/alpha/include/asm/system.h
@@ -48,6 +48,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 #define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
 
 /*

