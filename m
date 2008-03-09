Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbYCIL4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbYCIL4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYCIL4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:56:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYCIL4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:56:24 -0400
Date: Sun, 9 Mar 2008 12:56:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080309115603.GA951@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I'm half tempted to just do it as inline period ... any objections ?
> 
> Yes, I object. I want to understand why it would matter. If this is a 
> compiler bug, it's a really rather bad one. And if it's just some 
> stupid bug in our pmd_bad() macro, I still want to know what the 
> problem was.

ok, i think i figured it out: on PAE 32-bit we dont properly sign-extend 
to a 64-bit pmd value in the new pmd_bad() macro - so if any physical 
RAM is above 4GB (Arjan's laptop had 4GB of RAM in it?) then we'll start 
seeing those high bits. This definitely needs PAE and more than 4GB of 
RAM to trigger.

The best fix is the one below (it should solve Arjan's regression with 
that now-reverted patch redone), as it is the right thing to do [that 
way sign auto-extend trickles over into PAGE_MASK as well].

It boots fine on a >4GB box of mine but changing the type of PAGE_SIZE 
affects _everything_ so i'll keep testing it and i'd suggest to delay 
this fix to shortly after -rc5 is released instead of risking -rc5 with 
such a late commit. I'll send this and the re-done hugetlbfs fix 
together early next week.

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/include/asm-x86/page.h
===================================================================
--- linux.orig/include/asm-x86/page.h
+++ linux/include/asm-x86/page.h
@@ -5,7 +5,7 @@
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1,L) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifdef __KERNEL__
