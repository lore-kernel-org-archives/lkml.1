Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXEPXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXEPXaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXEPX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:29:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37272 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015AbXEPX35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:29:57 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 19:29:57 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Date: Wed, 16 May 2007 18:20:55 -0500
Message-ID: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Thread-Index: AceYENqeKwDo7DzLSiaYvkJKx0F4Nw==
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 May 2007 23:23:40.0170 (UTC) FILETIME=[3C9656A0:01C79811]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing we were noticing that we were getting some intermittent
crashes in profile_tick() when dyntick was enabled.

The crashes were because the frame pointer per_cpu____irq_regs value was
0.  That code does a user_mode(get_irq_regs()).  Currently regs is set
only upon real hardware entry on an irq.

The crash path shows resend_irqs() could be called with in a context
where set_irq_regs() was not executed.  In one specific case this was
from
softirq->tasklet_action(resend_tasklet)->resend_irqs->handle_level_irq->
handle_IRQ_event->...->profile_tick.

It seems anyone calling kernel/irq/manage.c:enable_irq() at the wrong
time can trigger this crash.

Creating a fake stack and doing a set_irq_regs() fixes the crash.  Would
it be useful to set a pointer to the entry context on all state changes?
For ease I just hacked a default fake stack into the init process after
fork time so there is never a 0 but that doesn't seem so nice.

Regards,
Richard W.

