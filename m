Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbYGBQlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbYGBQlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYGBQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:41:17 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:16607 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYGBQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:41:16 -0400
Date: Wed, 2 Jul 2008 18:39:01 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 6/7] x86: traps_xx: modify default_do_nmi
Message-ID: <20080702163901.GA1283@mailshack.com>
References: <20080701193643.GA29695@mailshack.com> <20080701233227.GF29903@mailshack.com> <20080702161220.GA7003@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702161220.GA7003@cvg>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 02 Jul 2008 18:41:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.64; VDF: 7.0.5.39; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - local caching of smp_processor_id() in default_do_nmi()
 - v2: do not split default_do_nmi over two lines

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

On Wed, Jul 02, 2008 at 08:12:20PM +0400, Cyrill Gorcunov wrote:
> | -static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> | +static notrace __kprobes void
> | +default_do_nmi(struct pt_regs *regs)
> | [ ... ]
> | -asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
> | +asmlinkage notrace __kprobes void
> | +default_do_nmi(struct pt_regs *regs)
> 
> Hi Alexander, good done, thanks! But why did you split default_do_nmi
> definition by two lines? I think it would be better to keep them as it
> was before, ie by a single line
> 
> 	static notrace __kprobes void default_do_nmi(struct pt_regs *regs)

Thanks! Here is the replacement patch with default_do_nmi left on
a single line. Patch 7 applies with 1 line fuzz.

Greetings,
    Alexander

> 		- Cyrill -

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bed6e72..9e3b0c4 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -793,9 +793,12 @@ void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
+	int cpu;
+
+	cpu = smp_processor_id();
 
-	/* Only the BSP gets external NMIs from the system: */
-	if (!smp_processor_id())
+	/* Only the BSP gets external NMIs from the system. */
+	if (!cpu)
 		reason = get_nmi_reason();
 
 	if (!(reason & 0xc0)) {
@@ -809,7 +812,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, smp_processor_id()))
+		if (!do_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 7511553..26ab0be 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -832,7 +832,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 
 /* Runs on IST stack. This code must keep interrupts off all the time.
    Nested NMIs are prevented by the CPU. */
-asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
+asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
