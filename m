Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZDJUaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZDJUaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbZDJU3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:29:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:55174 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbZDJU3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WqSkJbNGEmui3u1aQIsRYoKXFUg1aqovLQT086zyM2XtQqqFIdOl+oAdUWh96R+cD1
         9MvAH8OAR6lQ1fM/u1GHzlwjNL60G2wXblLdkDz+KSEmIvJG5RtuQwmTkA+ZCa02r9Ds
         0P+Q9VlN0XgZRjL5jP2V8c/BMOyU0WqsXNROQ=
Date: Sat, 11 Apr 2009 00:29:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC -tip] x86: do_IRQ - send APIC EOI for x86-32 on irq
	without handler v3
Message-ID: <20090410202941.GF8204@lenovo>
References: <20090409181802.GC7558@lenovo> <20090410122750.GR21506@elte.hu> <20090410135606.GA8204@lenovo> <20090410140023.GA29090@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410140023.GA29090@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Apr 10, 2009 at 04:00:23PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Fri, Apr 10, 2009 at 02:27:50PM +0200]
| > | 
| > | * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| > | 
| > | > Ingo, I've checked the sources and as far as I see
| > | > we could NOP'ify apic->write indeed but I have
| > | > an internal feeling that this will bring us more problem
| > | > in future (for example it could be the following scenario:
| > | > some screwed APIC would require cleaning of LVT's or
| > | > IRR after resume regardless if it was initialized
| > | > or not at all). Mostly I mean that the idea of making
| > | > apic->write NOP'ified is quite elegant indeed but
| > | > cut off the subset of apic operations (we need
| > | > apic->read anyway) somehow bothering me from inside :)
| > | 
| > | it's as if assigned a special type of 'dummy apic' struct apic. It 
| > | wont cause problems down the line: we use the new APIC driver 
| > | infrastructure to abstract out quirks.
| > 
| > Well, it's not that new actually :-)
| 
| Yeah, i mean the new unified/modernized code in 2.6.30-to-be.
| 
| > | 
| > | one small detail:
| > | 
| > | > +/* Ack APIC irq if it's enabled only */
| > | > +static inline void ack_APIC_irq_safe(void)
| > | > +{
| > | > +#ifdef CONFIG_X86_LOCAL_APIC
| > | > +	if (cpu_has_apic)
| > | > +		ack_APIC_irq();
| > | > +#endif
| > | 
| > | we dont need the cpu_has_apic check there, do we? In the 
| > | !cpu_has_apic the ->write method should be a dummy.
| > 
| > Yes. In case you're talking about it'll not be needed
| > (we will find earlier whether cpu_has_apic or not).
| 
| yeah.
| 
| 	Ingo
| 

Ingo,

I think you meant something like the patch below. It's
not finished yet -- I need to find out right place for
calling freshly introduced apic_disable_write_op.
Will continue tomorrow.

But even having it not completed yet I would like to
get some feedbackabout code structure in general.

        Cyrill
---
 arch/x86/include/asm/apic.h |   10 ++++++++++
 arch/x86/kernel/apic/apic.c |    6 ++++++
 arch/x86/kernel/irq.c       |   10 ++--------
 3 files changed, 18 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -106,6 +106,7 @@ extern void native_apic_wait_icr_idle(vo
 extern u32 native_safe_apic_wait_icr_idle(void);
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
+extern void native_apic_write_dummy(u32 reg, u32 v);
 
 #define EIM_8BIT_APIC_ID	0
 #define EIM_32BIT_APIC_ID	1
@@ -372,6 +373,15 @@ static inline void apic_write(u32 reg, u
 	apic->write(reg, val);
 }
 
+/*
+ * right after this call apic->write doesn't do anything
+ * note that there is no restore operation it works one way
+ */
+static inline void apic_disable_write_op(void)
+{
+	apic->write = native_apic_write_dummy;
+}
+
 static inline u64 apic_icr_read(void)
 {
 	return apic->icr_read();
Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -210,6 +210,12 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * bare function to substitute write operation
+ * and it's _that_ fast :)
+ */
+void native_apic_write_dummy(u32 reg, u32 v) { }
+
 void native_apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -27,7 +27,6 @@ void ack_bad_irq(unsigned int irq)
 	if (printk_ratelimit())
 		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
 	 * We _must_ ack these because every local APIC has only N
@@ -37,9 +36,7 @@ void ack_bad_irq(unsigned int irq)
 	 * completely.
 	 * But only ack when the APIC is enabled -AK
 	 */
-	if (cpu_has_apic)
-		ack_APIC_irq();
-#endif
+	ack_APIC_irq();
 }
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
@@ -224,10 +221,7 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
-		if (!disable_apic)
-			ack_APIC_irq();
-#endif
+		ack_APIC_irq();
 
 		if (printk_ratelimit())
 			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
