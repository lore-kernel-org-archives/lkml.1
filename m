Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbZFQG5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbZFQG5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZFQG53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:57:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZFQG52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:57:28 -0400
Date: Wed, 17 Jun 2009 08:57:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE boot crash in qemu
Message-ID: <20090617065720.GA4852@elte.hu>
References: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com> <20090615125200.GD31969@one.firstfloor.org> <1245072122.23207.47.camel@penberg-laptop> <1245217856.5604.16.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245217856.5604.16.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Mon, 2009-06-15 at 16:22 +0300, Pekka Enberg wrote:
> > On Mon, 2009-06-15 at 14:52 +0200, Andi Kleen wrote:
> > > x86: mce: Handle banks == 0 case in K7 quirk
> > > 
> > > This happens on QEMU which reports MCA capability, but no banks.
> > > Without this patch there is a buffer overrun and boot ops because the code
> > > would try to initialize the 0 element of a zero length kmalloc()
> > > buffer.
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > This fixes the bug for me!
> > 
> > Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Ingo, I hit this again in my testing after rebasing to 
> linus/master so I really would like this in mainline.

yep, i've tidied up the changelog and have committed it to 
x86/urgent.

But the bank[] code is quirky and butt-ugly and that needs to be 
cleaned up - it's no wonder that bugs like this slip in.

 - There's zero description about the hw model it represents 
   and how it relates to the bank[] array - what do the banks mean, 
   how are they organized.

 - It's full of magic constants and implicitly-assumed size
   calculations with little explanation and little extensibility:

       ...
                if (c->x86 == 15 && banks > 4) {
                        /*
                         * disable GART TBL walk error reporting, which
                         * trips off incorrectly with the IOMMU & 3ware
                         * & Cerberus:
                         */
                        clear_bit(10, (unsigned long *)&bank[4]);
                }
       ...
                bank = kmalloc(banks * sizeof(u64), GFP_KERNEL);
       ...
                memset(bank, 0xff, banks * sizeof(u64));
       ...

 - There's lots of bitmaps, arrays, flags interacting, creating a
   maze of logic.

Instead of this messy code, the proper approach is to introduce an 
abstract data structure representing the attributes of an MCE bank 
register:

  struct mce_bank_register {
	int enabled;
	int polled;
	int dont_init;
	int msr_idx;
  };

( There's lots of other structural problems with the MCE code too - 
  but now that it's unified lets first fix the most obvious ones... )

	Ingo
