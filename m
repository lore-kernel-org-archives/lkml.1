Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXGZIQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXGZIQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXGZIQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXGZIQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:16:22 -0400
Date: Thu, 26 Jul 2007 10:16:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070726081609.GA24377@elte.hu>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com> <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu> <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org> <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos> <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
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


* Marcin Ślusarz <marcin.slusarz@gmail.com> wrote:

> 2007/7/25, Thomas Gleixner <tglx@linutronix.de>:
> >(...)
> 
> I've tested Jarek's patch, 2 Ingo's patches (2nd and 3rd) and Thomas' 
> patch (one patch at time of course) - all of them fixed the problem, 
> but the last one flooded my logs with "Skip resend for irq 17". All 
> tests were done on 2.6.21.3.

that's great! I think we have two good theories about what might be 
going on:

 - the driver might be buggy in that it gets confused by the 'resent' 
   irq.

 - or the chipset/cpu has a bug where it might get confused about the
   resent APIC vector getting mixed up with the same vector coming
   externally too. (Now, it makes little sense to 'resend' a
   level-triggered interrupt on x86 platforms that have flat PIC 
   hierarchies (other architectures might need more than that to
   retrigger an interrupt) - but there's nothing wrong about it in 
   theory and it needs fixing for edge irqs anyway.)

in any case, the problem was triggered by our change generating much 
more resent irqs than before. Nevertheless we'd like to fix that resend 
bug (and if the driver is buggy, the driver bug too). It's really good 
progress so far - we are working on doing the real fix now.

	Ingo
