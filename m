Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZB1Ltc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZB1Ltc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 06:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZB1LtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 06:49:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42142 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZB1LtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 06:49:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A92487.3020108@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 12:48:23 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271830.37207.david-b@pacbell.net> <20090227183949.90f231e6.akpm@linux-foundation.org> <200902272046.50572.david-b@pacbell.net>
In-Reply-To: <200902272046.50572.david-b@pacbell.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Now, where is that being set up as being threaded?  I
> referenced that a message or two earlier:
> 
>   drivers/mfd/twl4030-irq.c
> 
> Where you'll observe twl_init_irq() at line 688 setting
> up the thread and the Primary IRQ Handler (PIH) dispatch.
> That's pretty much bog-standard chained IRQ setup code,
> except that it chains through a thread.
> 
> When an IRQ comes in, handle_twl4030_pih() acks and masks
> that top level IRQ.  Then it wakes twl4030_irq_thread(),
> which issues I2C operations to read the IRQ status from
> the chip ... first PIH to find out which SIH modules are
> raising an IRQ, then SIH to dispatch that status.  Then
> handle_irq() from that thread to invoke the handler in
> that thread context; it will issue more I2C ops.
> 
> And the lockdep thing kicks in through handle_irq(),
> where the IRQ handler wrongly gets invoked with the
> IRQs disabled -- iff lockdep is enabled.  Otherwise,
> that IRQ thread is just like any other thread.

Ah, so there /is/ a threaded IRQ handler implementation in the mainline,
down in some driver framework...

Why don't these drivers simply use <linux/workqueue.h>?
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
