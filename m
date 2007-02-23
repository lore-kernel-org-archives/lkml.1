Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXBWOUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXBWOUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbXBWOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:20:33 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:20345 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXBWOUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:20:31 -0500
Subject: Re: [patch] s390: do not use _local_bh_enable()
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070223140443.GA23754@elte.hu>
References: <20070223061459.GA10106@elte.hu>
	 <20070223093649.GA8084@osiris.boeblingen.de.ibm.com>
	 <1172238097.30132.34.camel@localhost>  <20070223140443.GA23754@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 23 Feb 2007 15:20:29 +0100
Message-Id: <1172240430.30132.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 15:04 +0100, Ingo Molnar wrote:
> > [...] cio_tpi and sclp_sync_wait are used to wait for the interrupt of 
> > the console device to make room in the buffer for a printk out of 
> > disabled context.
> 
> ouch. So you want/need to wait for a specific type of interrupt, in a 
> section of code that has all interrupts disabled? Is this the only form 
> of communication to the hypervisor, for this particular purpose? It 
> seems to me that polling a bit in a buffer shared between the hypervisor 
> and the guest OS [combined with cpu_relax()] would fit this scenario 
> alot better (and wouldnt cause any such gymnastics to avoid regular 
> Linux irq processing) than waiting for an interrupt to be injected by 
> the hypervisor. Or is this interrupt-based interface an ABI property and 
> the only way to do it?

This has nothing to do with the hypervisor. Even on bare metal (that
machine mode exists up to G7, newer machine always run a hypervisor) you
have to deal with your console device. If this is a 3270 green-screen
you have to do asynchronous i/o. To wait for some room in the console
buffer translates to waiting for the interrupt of a ccw device. The
memory of the machine is unchanged until the interrupt is received.
So yes, ouch!

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


