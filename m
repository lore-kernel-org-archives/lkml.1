Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYJUH3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYJUH3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJUH3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:29:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:43891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYJUH3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:29:45 -0400
Message-ID: <48FD8497.4090402@kernel.org>
Date: Tue, 21 Oct 2008 00:28:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Friesen <cfriesen@nortel.com>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [Fwd: Re: -tip  hangs my G5 during boot]  -- Bug in "genirq: record
 trigger type"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-------- Original Message --------
Subject: Re: -tip  hangs my G5 during boot
Date: Fri, 10 Oct 2008 11:13:34 -0600
From: Chris Friesen <cfriesen@nortel.com>
To: David Brownell <david-b@pacbell.net>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <48ECDFE2.1020609@nortel.com> <200810091043.27149.david-b@pacbell.net> <20081010153737.GC28977@elte.hu> <200810100958.38383.david-b@pacbell.net>

David Brownell wrote:
> On Friday 10 October 2008, Ingo Molnar wrote:
>
>>>>>	 bisection gave the following as the culprit.
>>>>>
>>>>>commit 0c5d1eb77a8be917b638344a22afe1398236482b
>>>>>Author: David Brownell <dbrownell@users.sourceforge.net>
>>>>>
>>>>>    genirq: record trigger type
>>
>>a quick review of the patch shows that it's about much more than just
>>recording the trigger type, it also changes the semantics of
>>set_irq_type():
>
>
> This is *exactly* what I meant when I wrote:
>
>
>>>>Other than that, I suspect something (new or old) depending on
>>>>either set_irq_type(irq, IRQ_TYPE_NONE) getting to an irq_chip
>>>>which doesn't treat it as a NOP, or ...
>
>
> As noted in my patch comments:  as part of recording those flags,
> it made their semantics in set_irq_type() paths be identical to
> their semantics in request_irq() paths.
>
> There do seem to be some irq_chip implementations in the
> arch/powerpc/sysdev (and some Cell support) that treat
> IRQ_TYPE_NONE as other-than-NOP.

At least in my case, it was nothing so complicated.  David's original
patch was passing "flags" rather than "type" down to __irq_set_trigger().
If I change it to pass "type" then everything works.

The following patch applies on top of -tip with David's original patch
re-applied.

Chris


From: Chris Friesen    <cfriesen@nortel.com>
Subject: [PATCH] fix set_irq_type() when recording trigger type

In set_irq_type() we want to pass the type rather than the current
interrupt state.

Signed-off-by: Chris Friesen <cfriesen@nortel.com>


diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 570d1ea..1c178ae 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -132,7 +132,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 		return 0;

 	spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, flags);
+	ret = __irq_set_trigger(desc, irq, type);
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
