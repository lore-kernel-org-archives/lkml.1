Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXFYSup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXFYSup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXFYSua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:50:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbXFYSu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:50:29 -0400
Date: Mon, 25 Jun 2007 20:50:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang, take #2
Message-ID: <20070625185014.GA3935@elte.hu>
References: <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu> <20070625082652.GA3870@elte.hu> <20070625124512.GA5118@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070625124512.GA5118@atjola.homenet>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> > and of course i'm happy to test any patch that is simpler than the 
> > brutal revert i sent.
> 
> wrmsrl() looks broken, dropping the upper 32bits of the value to be 
> written. Does this help?

this did the trick, rc6 plus your fix and the NMI watchdog works again! 
Thanks! I suspect other code (oprofile?) broke due to this too.

below is a tidied up patch for upstream application. Must-have for 
2.6.22.

	Ingo

----------------->
From: Björn Steinbrink <B.Steinbrink@gmx.de>
Subject: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang, take #2

wrmsrl() is broken, dropping the upper 32bits of the value to be
written. This broke the NMI watchdog on AMD hardware. (and it
probably broke other code too.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-i386/paravirt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -539,7 +539,7 @@ static inline int paravirt_write_msr(uns
 	val = paravirt_read_msr(msr, &_err);	\
 } while(0)
 
-#define wrmsrl(msr,val)		((void)paravirt_write_msr(msr, val, 0))
+#define wrmsrl(msr,val)		wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
 #define wrmsr_safe(msr,a,b)	paravirt_write_msr(msr, a, b)
 
 /* rdmsr with exception handling */
