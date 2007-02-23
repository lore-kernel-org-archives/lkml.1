Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXBWNlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXBWNlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932346AbXBWNlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:41:40 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:10408 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXBWNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:41:39 -0500
Subject: Re: [patch] s390: do not use _local_bh_enable()
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070223093649.GA8084@osiris.boeblingen.de.ibm.com>
References: <20070223061459.GA10106@elte.hu>
	 <20070223093649.GA8084@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 23 Feb 2007 14:41:37 +0100
Message-Id: <1172238097.30132.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 10:36 +0100, Heiko Carstens wrote:
> Same here: this is not really an irq handler but a function that gets called
> from different contexts and pretends to be an irq handler. The
> local_bh_disable()/_local_bh_enable() pair is just a trick to prevent bottom
> halve execution. I think you can blame Martin for this ;)

This code is really tricky. There are now three functions (cio_tpi,
sclp_sync_wait and __udelay) where we use a local_bh_disable()
_local_bh_enable() pair while we are disabled for interrupts. cio_tpi
and sclp_sync_wait are used to wait for the interrupt of the console
device to make room in the buffer for a printk out of disabled context.
__udelay() is used in the ETR clock-synchronization code where we are
disabled as well and the only alternative would be looping on a STCK for
about a second.

So basically we want to synchronously receive a specific interrupt. All
other interrupt sources are disabled. We know that the interrupt we wait
for will not cause a softirq to get scheduled. In case of sclp_sync_wait
and __udelay the interrupt is delivered the usual way by using the
asynchronous interrupt handler (I told you it is tricky ;-). That works
as long as only the hardirq part of the interrupt is executed, the
softirq part may not happen -> local_bh_disable. Back in the function
after the interrupt we cannot allow the softirq to happen when we
reenable the bottom-halves since the functions are called disabled and
need to stay disabled -> _local_bh_enable. Since the interrupt we waited
for did not add a softirq no harms is done, no?

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


