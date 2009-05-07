Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZEGQTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZEGQTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZEGQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:19:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62683 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZEGQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:19:32 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] genirq: ensure IRQs are lazy disabled before suspend
References: <1241655468-5750-1-git-send-email-khilman@deeprootsystems.com>
	<1241655468-5750-2-git-send-email-khilman@deeprootsystems.com>
	<20090507111548.GH28398@elte.hu>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 07 May 2009 09:19:30 -0700
In-Reply-To: <20090507111548.GH28398@elte.hu> (Ingo Molnar's message of "Thu\, 7 May 2009 13\:15\:48 +0200")
Message-ID: <87k54ssx65.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Kevin Hilman <khilman@deeprootsystems.com> wrote:
>

[...]

>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -190,6 +190,11 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
>>  		if (!desc->action || (desc->action->flags & IRQF_TIMER))
>>  			return;
>>  		desc->status |= IRQ_SUSPENDED;
>> +
>> +		/* Lazy disable: handles case where lazy disable in
>> +		 * handler doesn't happen before suspend. */
>> +		if (desc->status & IRQ_DISABLED)
>> +			desc->chip->mask(irq);
>
> Please look at the rest of the file and follow the multi-line 
> comment style that is used in the 29 multi-line comment instances 
> there. (which is also what Documentation/CodingStyle specifies)

Doh, sorry.  Updated patch below.

Kevin

>From a3f359c66bd0ae1bb2603e7cf120d9d4d68591b7 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Wed, 6 May 2009 16:00:07 -0700
Subject: [PATCH] genirq: ensure IRQs are lazy disabled before suspend

In commit 76d2160147f43f982dfe881404cfde9fd0a9da21, the default
behavior of disable_irq() was changed to delay the disable until it is
next handled.

However, this leaves open the possibility that the system can go into
suspend with an interrupt enabled.  For example, if a driver calls
disable_irq() in its suspend_hook there's now a possibility that the
system is suspended before the lazy disable happens.

The result is an unwanted wakeup from suspend if the IRQ is capable of
waking the system (common on embedded SoCs.)

This patch ensures that the lazy disable is done, and masked by
the irq_chip before the system goes into suspend.

Note that even though __disable_irq() also calls irq_chip->disable, it
is quite common for the irq_chip not to provide a disable hook in
which case the IRQ is never masked/disabled in hardware before going
into suspend.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 kernel/irq/manage.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..c786820 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -190,6 +190,13 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
 			return;
 		desc->status |= IRQ_SUSPENDED;
+
+		/*
+		 * Lazy disable: handles case where lazy disable in
+		 * handler doesn't happen before suspend.
+		 */
+		if (desc->status & IRQ_DISABLED)
+			desc->chip->mask(irq);
 	}
 
 	if (!desc->depth++) {
-- 
1.6.2.2

