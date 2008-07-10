Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYGJIYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYGJIYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYGJIXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:23:45 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:20919 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYGJIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:23:43 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-164.messagelabs.com!1215678221!26821491!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 10 Jul 2008 10:23:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] handle failure of irqchip->set_type in setup_irq
Message-ID: <20080710082336.GA31219@digi.com>
References: <20080625131101.GA6205@digi.com> <20080704104634.GA31634@digi.com> <20080704101717.28f6a771.akpm@linux-foundation.org> <20080704184307.GA8076@digi.com> <20080704120837.573adc9c.akpm@linux-foundation.org> <20080709131353.GA12009@digi.com> <20080709145253.f658db37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080709145253.f658db37.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jul 2008 08:23:38.0067 (UTC) FILETIME=[40BC1A30:01C8E266]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> > > However I'm presently brewing up a plot to do this:
> > >
> > >         printk("function name is %Ss\n", (unsigned long *)chip->set_type);
> > >
> > > which I think will work.  We can also do
> > >
> > >         printk("IP address is %Si\n", (unsigned long *)ip_address_buffer);
> > >
> > > to replace NIPQUAD.  And similar printk extensions.
> > >
> > > Am still thinking about it though.
> > I assume the result is 0fe1ef24f7bd0020f29ffe287dfdb9ead33ca0b2?
> 
> yup.
When I saw this commit I wondered that it was you who told me to think
about this but the commiter was Linus.
 
> > Should I send a new version using %pF or is it easier if you fix up the
> > patch?
> 
> A new version would be nice, thanks.  Or an incremental diff, but I can and
> will turn new versions into an incremental in the twinkle of an eye, so
> either is OK.
voilà:

--->8---
>From c991997725fdce93352aab53ccab34f41b5afd52 Mon Sep 17 00:00:00 2001
From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Date: Thu, 10 Jul 2008 10:03:59 +0200
Subject: [PATCH] __irq_set_trigger: use %pF to print the set_type callback's name
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

This uses the new feature of printk introduced in
0fe1ef24f7bd0020f29ffe287dfdb9ead33ca0b2.

The actual output is unchanged.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 kernel/irq/manage.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 178b966..e01ad8e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -287,14 +287,9 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
 
 	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
 
-	if (ret) {
-		char buf[100];
-
-		snprintf(buf, sizeof(buf), KERN_ERR
-				"setting flow type for irq %u failed (%%s)\n",
-				irq);
-		print_fn_descriptor_symbol(buf, chip->set_type);
-	}
+	if (ret)
+		pr_err("setting flow type for irq %u failed (%pF)\n",
+				irq, chip->set_type);
 
 	return ret;
 }
-- 
1.5.6


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
