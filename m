Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbXF2NQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbXF2NQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXF2NQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:16:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXF2NQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:16:18 -0400
Date: Fri, 29 Jun 2007 15:16:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070629131605.GA25964@elte.hu>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629130955.GA284@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Yes, I think cinergyt2 is buggy.

> cinergyt2_release() does flush_scheduled_work() under cinergyt2->sem. 
> flush_scheduled_work() hangs because cinergyt2_query_rc() waits for 
> the same cinergyt2->sem.
> 
> ->disconnect_pending is used without any locks/barriers, perhaps this 
> is the reason.
> 
> I'll try to look further tomorrow. In any case, cinergyT2 should not 
> use flush_scheduled_work() at all.

would the hack below be worth trying, to see whether there are any 
further problems?

	Ingo

Index: linux/drivers/media/dvb/cinergyT2/cinergyT2.c
===================================================================
--- linux.orig/drivers/media/dvb/cinergyT2/cinergyT2.c
+++ linux/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -523,7 +523,6 @@ static int cinergyt2_release (struct ino
 
 	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
 		cancel_delayed_work(&cinergyt2->query_work);
-		flush_scheduled_work();
 		cinergyt2_sleep(cinergyt2, 1);
 	}
 
@@ -974,8 +973,6 @@ static void cinergyt2_disconnect (struct
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	flush_scheduled_work();
-
 	cinergyt2_unregister_rc(cinergyt2);
 
 	cancel_delayed_work(&cinergyt2->query_work);
@@ -1002,7 +999,6 @@ static int cinergyt2_suspend (struct usb
 		cancel_delayed_work(&cinergyt2->query_work);
 		if (cinergyt2->streaming)
 			cinergyt2_stop_stream_xfer(cinergyt2);
-		flush_scheduled_work();
 		cinergyt2_sleep(cinergyt2, 1);
 	}
 
