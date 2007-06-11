Return-Path: <linux-kernel-owner+w=401wt.eu-S1764202AbXFKIsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764202AbXFKIsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXFKIsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:48:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48912 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXFKIsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:48:36 -0400
Date: Mon, 11 Jun 2007 10:47:40 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [patch-mm 19/23] x86_64: Convert to cleckevents
Message-ID: <20070611104740.22adc9bc@frecb000686.frec.bull.fr>
In-Reply-To: <20070610092447.072839259@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	<20070610092447.072839259@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/06/2007 10:52:14,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/06/2007 10:52:16,
	Serialize complete at 11/06/2007 10:52:16
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Thomas,

On Sun, 10 Jun 2007 09:44:18 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> Convert x86_64 to the clockevents code. Share code with i386 for
> hpet and PIT.
> 
> Build and whitespace fixups from:
>  Venki Pallipadi <venkatesh.pallipadi@intel.com>
> and
>  Chris Wright <chrisw@sous-sol.org>


  It seems that the hpet clocksource's ->vread has been lost in the conversion.
Is this on purpose?

  The patch below fixes it for x86_64 on 2.6.21.3-rt9. If you want it rebased
on -mm let me know.

  Thanks,

  Sébastien.

---

  It seems the hpet clocksource's vread method was lost in the x86_64 conversion
to clockevent. So here it is.

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

 arch/i386/kernel/hpet.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.21.3-rt9/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21.3-rt9.orig/arch/i386/kernel/hpet.c	2007-06-07 15:09:41.000000000 +0200
+++ linux-2.6.21.3-rt9/arch/i386/kernel/hpet.c	2007-06-07 15:50:50.000000000 +0200
@@ -313,6 +313,13 @@ static cycle_t notrace read_hpet(void)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
+#ifdef CONFIG_X86_64
+static notrace cycle_t __vsyscall_fn vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+#endif
+
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -321,6 +328,9 @@ static struct clocksource clocksource_hp
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_restart_counter,
+#ifdef CONFIG_X86_64
+	.vread		= vread_hpet,
+#endif
 };
 
 static int hpet_clocksource_register(void)

