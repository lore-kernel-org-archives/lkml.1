Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYDZI41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYDZI41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYDZI4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:56:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54281 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYDZI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:56:17 -0400
Date: Sat, 26 Apr 2008 10:56:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
Message-ID: <20080426085600.GA5891@elte.hu>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com> <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org>
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

> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> > 
> > The problem is that that can create cached/uncached aliases, which 
> > can cause some processors to lock up (especially AMD is known to 
> > have a lot of errata in this area.)
> 
> Umm.. I don't think you understand. Right now, NONPROMISC_DEVMEM 
> doesn't just disable mmap() on /dev/mem, it disables totally regular 
> reads and writes too. That seems pretty damn excessive.
> 
> If it was just mmap(), I don't think it would matter much. I don't 
> think we traditionally even supported mmap() on real RAM (because the 
> page counting would get confused), and that actually got supported 
> only thanks to VM changes that made it possible.
> 
> But read/write has always been supported, and shouldn't cause any 
> cached/uncached aliases!

You are right, there should be no architectural need to make PAT 
dependent on nonpromisc-devmem, and thus the patch below should be safe.

In theory even mmap() of /dev/mem should be safe this way - as all 
memtypes are properly tracked.

The thinking behind this dependency was three-fold:

- historic: from the days when the PAT patchset didnt do fully correct 
  tracking yet

- practical: that PAT would be utilized in newer distros on newer 
  systems - with older distros on older systems not really wanting 
  (or needing) neither /dev/mem restrictions nor PAT

- paranoia: one less degree of freedom to take into account

	Ingo

----------------------->
Subject: x86 PAT: decouple from nonpromisc devmem
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 10:26:52 CEST 2008

Linus pointed it out that PAT should not depend on NONPROMISC_DEVMEM.

Also make PAT non-default.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -1042,9 +1042,9 @@ config MTRR
 	  See <file:Documentation/mtrr.txt> for more information.
 
 config X86_PAT
-	def_bool y
+	bool
 	prompt "x86 PAT support"
-	depends on MTRR && NONPROMISC_DEVMEM
+	depends on MTRR
 	help
 	  Use PAT attributes to setup page level cache control.
 
