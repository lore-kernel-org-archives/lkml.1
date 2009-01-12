Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZALUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZALUxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZALUxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:53:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZALUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:53:21 -0500
Date: Mon, 12 Jan 2009 21:52:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20090112205259.GA5303@elte.hu>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com> <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com> <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> 
> 
> On Mon, 12 Jan 2009, Pallipadi, Venkatesh wrote:
> > +		if (strict_prot ||
> > +		    (want_flags == _PAGE_CACHE_UC_MINUS &&
> > +		     flags == _PAGE_CACHE_WB) ||
> > +		    (want_flags == _PAGE_CACHE_WC &&
> > +		     flags == _PAGE_CACHE_WB)) {
> 
> Please don't write code like this.
> 
> Do it as an inline function that returns true/false and has comments on 
> what the hell is going on.

I have asked Venki to do a minimal 'combo' patch that isolates just the 
functional changes. (it is otherwise identical to Venki's PAT changes.) 

The reason why we wanted to re-test the functional changes was that 
Torsten's crash looks very weird: double Call Trace line, a crash in the 
scsi/ata code, showing the after-effects of some sort of memory corruption 
there.

Connection to the x86-fixes patchset did not seem impossible [a theory 
would be: cache aliasing problems causing memory corruption], but 
nevertheless it was all quite weird. So we wanted an isolated repeat test 
for just the functional changes.

The 7 patches lined up for you (but quarantined from x86/urgent for now, 
until the crash Torsten got is investigated) introduce the above condition 
cleanly, as:

+static inline int is_new_memtype_allowed(unsigned long flags,
+                                               unsigned long new_flags)
+{
+       /*
+        * Certain new memtypes are not allowed with certain
+        * requested memtype:
+        * - request is uncached, return cannot be write-back
+        * - request is write-combine, return cannot be write-back
+        */
+       if ((flags == _PAGE_CACHE_UC_MINUS &&
+            new_flags == _PAGE_CACHE_WB) ||
+           (flags == _PAGE_CACHE_WC &&
+            new_flags == _PAGE_CACHE_WB)) {
+               return 0;
+       }
+
+       return 1;
+}

	Ingo
