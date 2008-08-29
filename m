Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYH2G6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYH2G6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYH2G6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:58:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYH2G63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:58:29 -0400
Date: Fri, 29 Aug 2008 08:58:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
Message-ID: <20080829065812.GA28777@elte.hu>
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com> <20080829063012.GA19459@elte.hu> <86802c440808282347n66a6dfb7r2bebd9f65918614a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808282347n66a6dfb7r2bebd9f65918614a@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
> >  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> >
> > which overlaps with the chipset PCI BAR (hpet) resource:
> >
> >   pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff
> >
> > so due to this 1K conflict we take the full e820-reserved entry out and
> > give the range 0xfec00000-0x100000000 as 'free'.
> 
> you will get
> fec00000 - ffffffff reserved
>    fed0000 - fed003ff hpet
>      fed0000 - fed003ff 0000:00:14.0

ok - because it's fully contained insert_resource() will succeed? I 
thought it would only succeed if the new resource was smaller than (a 
subset of) the existing resource. In the other direction, when a newly 
inserted resource is a superset of the existing resource, i thought we'd 
fail.

hypothetical scenario, what if we had neither a superset nor a subset 
scenario, but a partial overlap, between:

> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)

and:

> >   pci 0000:00:14.0: BAR has HPET at feb0f000-fec01000

i.e. we have:

      [... PCI BAR ...]
            [... e820 reservation ...]

in that case the insert_resource() will fail due to the conflict. Can we 
declare it in that case that the e820 reserved entry is mortally broken 
and we just ignore it?

At least we should emit a prominent warning if insert_resource() fails, 
and add in an mdelay(2000) so that the user sees it.

	Ingo
