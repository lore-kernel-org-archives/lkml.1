Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXFYMoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXFYMoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXFYMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:44:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:49143 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755654AbXFYMo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:44:29 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/suuB6ewnsdje7zYTwrolR1Wp4+oPf9qlXz1lDjU
	mFE1pODMpJgiTU
Date: Mon, 25 Jun 2007 14:45:12 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
Message-ID: <20070625124512.GA5118@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu> <20070625082652.GA3870@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070625082652.GA3870@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 10:26:52 +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > the winner is ...
> > 
> >  f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
> >  commit f8822f42019eceed19cc6c0f985a489e17796ed8
> >  Author: Jeremy Fitzhardinge <jeremy@goop.org>
> >  Date:   Wed May 2 19:27:14 2007 +0200
> > 
> >     [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable
> 
> and of course i'm happy to test any patch that is simpler than the 
> brutal revert i sent.

wrmsrl() looks broken, dropping the upper 32bits of the value to be
written. Does this help?

Björn
---
diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index d7a0512..7f846a7 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -539,7 +539,7 @@ static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 	val = paravirt_read_msr(msr, &_err);	\
 } while(0)
 
-#define wrmsrl(msr,val)		((void)paravirt_write_msr(msr, val, 0))
+#define wrmsrl(msr,val)		wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
 #define wrmsr_safe(msr,a,b)	paravirt_write_msr(msr, a, b)
 
 /* rdmsr with exception handling */
