Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYHKPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYHKPoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYHKPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:44:46 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:52867 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYHKPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:44:45 -0400
Message-ID: <48A05E79.4030304@keyaccess.nl>
Date: Mon, 11 Aug 2008 17:44:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu>
In-Reply-To: <20080811122038.GA10082@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------080002050509020708030709"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002050509020708030709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-08-08 14:20, Ingo Molnar wrote:

>> From: Rene Herman <rene.herman@keyaccess.nl>
>> Date: Thu, 7 Aug 2008 01:50:35 +0200
>> Subject: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
>>
>> commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly 
>> nopped debugging printks in arch/x86/kernel/mppparse.c into regular 
>> ones. The one at the top of smp_scan_config() in particular also 
>> prints on !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines 
>> without anything resembling MP tables which makes their lowly UP 
>> owners wonder...
>>
>> given that it was up to this point also not considered valuable 
>> user-level information, let's just kill that one.
> 
> hm, i found it useful in the past in about 2-3 cases.
> 
> How about a patch that makes the printout depend on apic=debug ? That 
> way the message can still be there in case of bugreports that somehow 
> deal with SMP or APIC bugs (without having to recompile the kernel).
> 
> The way to make the printout depend on apic=debug/verbose is to do 
> something like this:
> 
> 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n", bp, length);
> 
> Would you mind to send a patch for that?

I wouldn't. Like this? This turns the printk's that used to be Dprintk's 
into apic_printk's.

I am myself only interested in the one at the top of smp_scan_config() 
(it made me think I had misconfigured something upon all of a sudden 
seeing SMP printk's on my UP machine on 2.6.27-rc) but I guess this is 
the more complete version.

One problem; on 32-bit, "apic=" is a __setup() param and isn't actually 
early enough for us here so this needs it turned into an early_param() 
(followup).

Rene.

--------------080002050509020708030709
Content-Type: text/plain;
 name="0001-x86-make-arch-x86-kernel-mpparse.c-debugging-printk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-make-arch-x86-kernel-mpparse.c-debugging-printk.pat";
 filename*1="ch"

>From 3d6ab02d08c3597cd24581968dd0b41f3c264716 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Mon, 11 Aug 2008 17:20:42 +0200
Subject: [PATCH] x86: make arch/x86/kernel/mpparse.c debugging printk's apic_printk's

commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly
nopped debugging printks in arch/x86/kernel/mppparse.c into regular
ones. The one at the top of smp_scan_config() in particular also
prints on !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines
without anything resembling MP tables which makes their lowly UP
owners wonder...

Turn the former Dprintk()s into apic_printk()s instead meaning that
their printing is dependent on passing the apic=verbose (or =debug)
command line param.

On 32-bit, "apic" is a __setup() param which isn't early enough
for this code and therefore needs a followup changing it into an
early_param(). On 64-bit, it already is.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/kernel/mpparse.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6ae005c..6780905 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -83,7 +83,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 	if (x86_quirks->mpc_oem_bus_info)
 		x86_quirks->mpc_oem_bus_info(m, str);
 	else
-		printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
+		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->mpc_busid, str);
 
 #if MAX_MP_BUSSES < 256
 	if (m->mpc_busid >= MAX_MP_BUSSES) {
@@ -154,7 +154,7 @@ static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
 
 static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
@@ -163,7 +163,7 @@ static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 
 static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 {
-	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
 		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
@@ -235,7 +235,7 @@ static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 
 static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
 {
-	printk(KERN_INFO "Lint: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
@@ -695,7 +695,8 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
+	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
+			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
-- 
1.5.5


--------------080002050509020708030709--
