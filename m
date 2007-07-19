Return-Path: <linux-kernel-owner+w=401wt.eu-S939734AbXGSPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939734AbXGSPwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935902AbXGSPwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850AbXGSPwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:52:42 -0400
Date: Thu, 19 Jul 2007 17:52:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719155230.GA31267@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu> <200707191237.56455.olaf.kirch@oracle.com> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu> <20070719150728.GA17000@elte.hu> <20070719153217.GA25544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719153217.GA25544@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> ah! Just found the reason: the bug apparently depends on the precise 
> kernel command-line contents. I accidentally dropped ignore_loglevel 
> (found this while comparing with the older logs i sent to you), adding 
> it back in produces hung networking too. So it appears that a 
> netconsole printout while e1000 is initializing (or while some other 
> networking component is initializing) might be the culprit?

and the WARN_ON() below does not seem to trigger.

i'll now check whether removing ignore_on_loglevel (no other changes) 
makes the hang go away. Maybe ignore_on_loglevel is buggy - or it 
produces an immediate printk (going out to the interface) during a 
particularly sensitive period of network initialization.

	Ingo

----------------->
Index: linux/drivers/net/e1000/e1000_main.c
===================================================================
--- linux.orig/drivers/net/e1000/e1000_main.c
+++ linux/drivers/net/e1000/e1000_main.c
@@ -358,6 +358,7 @@ e1000_irq_enable(struct e1000_adapter *a
 		E1000_WRITE_REG(&adapter->hw, IMS, IMS_ENABLE_MASK);
 		E1000_WRITE_FLUSH(&adapter->hw);
 	}
+	WARN_ON_ONCE(atomic_read(&adapter->irq_sem) < 0);
 }
 
 static void
