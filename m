Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYGRTDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYGRTDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYGRTCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:02:53 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63471 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756782AbYGRTCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:02:53 -0400
Date: Fri, 18 Jul 2008 20:02:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
In-Reply-To: <20080718172821.GA4149@localhost.localdomain>
Message-ID: <Pine.LNX.4.55.0807181934490.12125@cliff.in.clinika.pl>
References: <20080718172821.GA4149@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Vegard Nossum wrote:

> There are certain APIC errors which are obviously programmer errors,
> e.g. writing to illegal APIC registers, or sending invalid interrupt
> vectors. Since the error interrupt happens spot on the erroneous code,
> we might as well make a bit of noise about it and display the stack-
> trace.
[...]
> @@ -1317,6 +1317,7 @@ void smp_error_interrupt(struct pt_regs *regs)
>  	*/
>  	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
>  		smp_processor_id(), v , v1);
> +	WARN_ON(v1 & ((1 << 0) | (1 << 2) | (1 << 5) | (1 << 7)));

 Hmm, I think there is no point in dumping state on send checksum errors
as these normally signify a problem like a data line driven low on the
inter-APIC bus by another agent while the sender drove it high.  Barring a
faulty chip, it would normally happen as a result of a problem with
arbitration, such as when duplicate IDs would happen on the bus.  In this
case finding the triggering command would not help at all as the culprit
would lie elsewhere.  It could result from crosstalk or some other problem
with board hardware too.

 The rest is fine with me.

 You need to check (v | v1) though as for Pentium processor integrated
APICs the error triggering the interrupt is provided by the first read of
the ESR register and for later implementations it is the second read that
does that after the latches have been updated by the write access between.

  Maciej
