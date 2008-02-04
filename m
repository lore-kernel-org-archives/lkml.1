Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYBDPgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYBDPgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBDPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:36:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYBDPgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:36:45 -0500
Date: Mon, 4 Feb 2008 16:36:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: Commit f06e4ec breaks vmware
Message-ID: <20080204153631.GA30943@elte.hu>
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr> <20080204115144.GA17850@elte.hu> <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com> <20080204145311.GB13154@elte.hu> <b6a2187b0802040730y44580594i56b26ed0fcb8292e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0802040730y44580594i56b26ed0fcb8292e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Feb 4, 2008 10:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > > commit 8d947344c47a40626730bb80d136d8daac9f2060
> > > Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> > > Date:   Wed Jan 30 13:31:12 2008 +0100
> > >
> > >     x86: change write_idt_entry signature
> >
> > does the patch below ontop of x86.git#mm fix this?
> 
> 
> > 32-bit or 64-bit guest kernel?
> 
> 32-bit.
> 
> Yep, this fixed the problem.

great! I've added:

   Tested-by: Jeff Chua <jeff.chua.linux@gmail.com>

to the commit message as well, if you dont mind. Full patch is below.

> You're amazingly fast!

you did all the hard work by bisecting it down so fast - fixing it was 
easy :)

	Ingo

----------------------->
Subject: x86: VMI fix
From: Ingo Molnar <mingo@elte.hu>

Jeff Chua bisected down a vmware guest boot breakage (hang) to
this paravirt change:

  commit 8d947344c47a40626730bb80d136d8daac9f2060
  Author: Glauber de Oliveira Costa <gcosta@redhat.com>
  Date:   Wed Jan 30 13:31:12 2008 +0100

    x86: change write_idt_entry signature

fix the off-by-one indexing bug ...

Bisected-by: Jeff Chua <jeff.chua.linux@gmail.com>
Tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmi_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-x86.q/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/vmi_32.c
+++ linux-x86.q/arch/x86/kernel/vmi_32.c
@@ -220,21 +220,21 @@ static void vmi_set_tr(void)
 static void vmi_write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
 	u32 *idt_entry = (u32 *)g;
-	vmi_ops.write_idt_entry(dt, entry, idt_entry[0], idt_entry[2]);
+	vmi_ops.write_idt_entry(dt, entry, idt_entry[0], idt_entry[1]);
 }
 
 static void vmi_write_gdt_entry(struct desc_struct *dt, int entry,
 				const void *desc, int type)
 {
 	u32 *gdt_entry = (u32 *)desc;
-	vmi_ops.write_gdt_entry(dt, entry, gdt_entry[0], gdt_entry[2]);
+	vmi_ops.write_gdt_entry(dt, entry, gdt_entry[0], gdt_entry[1]);
 }
 
 static void vmi_write_ldt_entry(struct desc_struct *dt, int entry,
 				const void *desc)
 {
 	u32 *ldt_entry = (u32 *)desc;
-	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[2]);
+	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
 }
 
 static void vmi_load_sp0(struct tss_struct *tss,
