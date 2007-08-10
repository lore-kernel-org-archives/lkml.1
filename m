Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbXHJJjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbXHJJjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXHJJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:38:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXHJJiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:38:52 -0400
Date: Fri, 10 Aug 2007 11:38:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>, tglx <tglx@linutronix.de>,
       torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after
	random time
Message-ID: <20070810093839.GB19777@elte.hu>
References: <JMJTMH$F1699B57C9B0E170ED337488612E649B@xandmail.com> <20070810083720.GE1764@ff.dom.local> <20070810084841.GA11086@elte.hu> <20070810090318.GG1764@ff.dom.local> <20070810090833.GA15121@elte.hu> <20070810091954.GI1764@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810091954.GI1764@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> All correct! There was also checked a possibility it can be not hw 
> itself, but wrong way of handling after hw (acking too late). This was 
> false idea (or bad implementation), so it looks like hw vs lapic 
> problem.

i think the problem is that local APIC 'self vectors' might be 
edge-triggered by default. I'm not exactly sure whether passing in 
APIC_INT_LEVELTRIG to send_IPI_self() will truly be interpreted by the 
local APIC into any external IO-APIC ACK sequence (the local APIC might 
just treat self-vectors as always-edge) - and it might also be that the 
pure act of mixing self-triggered vectors with level-triggered external 
irqs sometimes confuses the IO-APIC <-> local-APIC messaging. One more 
test of the patch below will tell us a bit more about this part of the 
story.

	Ingo

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -735,7 +735,8 @@ void fastcall send_IPI_self(int vector)
 	 * Wait for idle.
 	 */
 	apic_wait_icr_idle();
-	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL;
+	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | APIC_DEST_LOGICAL |
+		APIC_INT_LEVELTRIG;
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
