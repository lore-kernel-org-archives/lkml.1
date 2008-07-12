Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbYGLHhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbYGLHhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYGLHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:37:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:48371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYGLHhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:37:17 -0400
Subject: Re: Multiple MSI, take 3
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
In-Reply-To: <m13amf3eak.fsf@frodo.ebiederm.org>
References: <20080711005719.GO14894@parisc-linux.org>
	 <m1iqvc91li.fsf@frodo.ebiederm.org>
	 <20080711215943.GW1678@linux-os.sc.intel.com>
	 <m1d4lkauxc.fsf@frodo.ebiederm.org> <1215834720.7549.154.camel@pasglop>
	 <m13amf3eak.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 17:36:01 +1000
Message-Id: <1215848161.7549.166.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It is edge triggered so it won't refire when unmasked (especially if we don't know).
> So it is easy to wind up in a state where the device is waiting for the software
> and the software is waiting for the device because an irq gets dropped.

Well, we are smarter than that. soft-masking is a know well-solved
problem. We just latch that something happened while masked and refire
when unmasked. Not terribly hard. We already do that in various
situations to mask edge interrupts.

> There are enough places that have problems that we have a fairly standard work around
> to the problem (listed above) by just taking the first irq (after we have disabled the
> irq) and setting it pending in software and then actually masking it in hardware.

Masking in HW is totally optional. I don't mask in HW on cell for
example, the HW just can't.

> That works, but it is still isn't quite correct.  Because we can run the
> interrupt handler once to often.

We only re-fire if it actually occured while "masked", that should take
care that we never fire once too much, no ?

>   For interrupts that are never shared and
> always in order with the DMA, generally don't require reading a status
> register on the card, and are otherwise highly optimized that might actually
> be a problem.

There must be some way of knowing what work is to do (ie, whether a DMA
q entry is completed, some kind of done bit, etc...). There generally is
at least, so that even in that case, spurrious MSIs are mostly a non
issue, but I don't think we have them here.
 
> Which is why I said that it doesn't look like even using an iommu can
> fix all of the issues with treating msi multi message mode messages
> as individual irqs.  We can get very close but not quite there.

I still mostly dislike the new approach, I prefer Matthew's original one
with SW masking of the MSIs. For example, if you have the MSIs be 'one'
interrupt, then you hit all of the logic in the IRQ core to make sure
only one happens at once. Might not be what you want, and -will- cause
some to be dropped... not nice.

Ben.


