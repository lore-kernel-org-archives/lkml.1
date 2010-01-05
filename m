Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068Ab0AEARZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0AEARZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020Ab0AEARX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:17:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0AEARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:17:22 -0500
Message-ID: <4B4284C6.9030107@kernel.org>
Date: Mon, 04 Jan 2010 16:16:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	 <4B398ECD.1080506@kernel.org>	 <4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	 <4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>	 <m1aawtlu6y.fsf@fess.ebiederm.org> <4B423B08.3010005@zytor.com>	 <m1my0thelq.fsf@fess.ebiederm.org>  <4B424305.7050803@kernel.org>	 <1262634353.2700.49.camel@sbs-t61.sc.intel.com>	 <4B42467F.5040008@zytor.com> <1262649945.2700.364.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1262649945.2700.364.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 04:05 PM, Suresh Siddha wrote:
> On Mon, 2010-01-04 at 11:50 -0800, H. Peter Anvin wrote:
>> On 01/04/2010 11:45 AM, Suresh Siddha wrote:
>>> On Mon, 2010-01-04 at 11:35 -0800, Yinghai Lu wrote:
>>>> sth like this?
>>>>
>>>> Subject: [PATCH 1/2] x86: get back 16 vectors
>>>>
>>>> -v2: according to hpa that we could start from 0x10
>>>>      according to Eric, we should hold 16 vectors for IRQ MOVE
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>
>>> Yinghai we have to change IRQ_MOVE_CLEANUP_VECTOR to 0x1f or so. From
>>> the cpu perspective this vector is documented as illegal, so we need to
>>> check if this change will work on the cpu's we have today to get some
>>> confidence.
>>>
>>
>> It's documented as reserved, not illegal.  The ability for the APIC to
>> generate vectors starting at 0x10 is documented, as is the ability for
>> the CPU to receive any vector number as an interrupt -- in fact, the
>> legacy BIOS relies on being able to receive interrupts starting at
>> vector 0x08.  It causes problems galore, but only at the software level.
> 
> I have checked out couple of platforms (including 32-bit atom) and 0x1f
> vector logic seems to be working.
> 
> Hopefully we won't have other hardware or software issues (vmm
> restrictions etc) with this logic.
> 

good. hope it is final version. let's have hpa own it.

From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: get back 16 vectors

-v2: according to hpa that we could start from 0x1f
-v3: update comments from Eric
-v4: update comments from hpa
-v5: use round up for IRQ0_VECTOR according to hpa

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/irq_vectors.h |   40 ++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -30,26 +30,38 @@
 /*
  * IDT vectors usable for external interrupt sources start
  * at 0x20:
+ * hpa said we can start from 0x1f.
+ *   0x1f is documented as reserved.  However, the ability for the APIC
+ *   to generate vectors starting at 0x10 is documented, as is the
+ *   ability for the CPU to receive any vector number as an interrupt.
+ *   0x1f is used for IRQ_MOVE_CLEANUP_VECTOR since that vector needs
+ *   an entire privilege level (16 vectors) all by itself at a higher
+ *   priority than any actual device vector.  Thus, by placing it in the
+ *   otherwise-unusable 0x10 privilege level, we avoid wasting a full
+ *   16-vector block.
  */
-#define FIRST_EXTERNAL_VECTOR		0x20
+#define FIRST_EXTERNAL_VECTOR		0x1f
 
+#define IA32_SYSCALL_VECTOR		0x80
 #ifdef CONFIG_X86_32
 # define SYSCALL_VECTOR			0x80
-# define IA32_SYSCALL_VECTOR		0x80
-#else
-# define IA32_SYSCALL_VECTOR		0x80
 #endif
 
 /*
- * Reserve the lowest usable priority level 0x20 - 0x2f for triggering
+ * Reserve the lowest usable priority level 0x10 - 0x1f for triggering
  * cleanup after irq migration.
+ * this overlaps with the reserved range for cpu exceptions so this
+ * will need to be changed to 0x20 - 0x2f if the last cpu exception is
+ * ever allocated.
  */
+
 #define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
 /*
- * Vectors 0x30-0x3f are used for ISA interrupts.
+ * Vectors 0x20-0x2f are used for ISA interrupts.
+ *   round up to the next 16-vector boundary
  */
-#define IRQ0_VECTOR			(FIRST_EXTERNAL_VECTOR + 0x10)
+#define IRQ0_VECTOR			((FIRST_EXTERNAL_VECTOR + 16) & ~15)
 
 #define IRQ1_VECTOR			(IRQ0_VECTOR +  1)
 #define IRQ2_VECTOR			(IRQ0_VECTOR +  2)
