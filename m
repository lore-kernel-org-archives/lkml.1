Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYKURPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYKURPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYKURPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:15:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55188 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751838AbYKURPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:15:40 -0500
Date: Fri, 21 Nov 2008 11:15:37 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
Message-ID: <20081121171537.GA12370@sgi.com>
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com> <20081119212350.GB3377@sgi.com> <20081119212631.GC3377@sgi.com> <20081120151208.f7892050.akpm@linux-foundation.org> <4925F095.40107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4925F095.40107@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 03:19:49PM -0800, H. Peter Anvin wrote:
> Andrew Morton wrote:
> >>
> >> Refreshing this to use 0xed as the vector.  Have repackaged it to be more
> >> generic.
> >>
> 
> What happened to the concept of using normal IRQs for this, via a custom
> irqchip?  Adding more reserved vectors really sucks, and it affects
> non-SGI platforms, which could potentially run out of vectors as a result.

There are basically two issues with using 'normal IRQs' in cases like this:

- Using normal IRQs would mean we would have an IRQ per cpu.  The current
  hard coded maximum, NR_IRQS, is 4352 (NR_VECTORS + (32 * MAX_IO_APICS)).
  On machines with large numbers of cpus and an irq per cpu for each desired
  interrupt, that's a lot of IRQs.  In addition, the GRU, will need 2 such
  IRQs per cpu.  On 4096 cpu systems, you've already used up more than the
  limit just for that.  Until some sort of infrastructure change takes place
  that would potentially allow this to be dynamically increased, such as
  Yinghai Lu's "sparse_irq aka dyn_irq v14" patch, this problem will exist.
  
  Furthermore, the actual runtime limit, nr_irqs, is set to 96 by
  probe_nr_irqs for our configuration.  This is because that code assumes all
  vectors are io-apic vectors, not cpu centric vectors like the ones I'm
  talking about.  With the current, scheme, even on a 128 cpu system, I'm out
  of IRQs immediately.

- The current infrastructure for requesting vector/IRQ combinations doesn't
  allow one to request an interrupt priority higher than i/o device interrupt
  priorities.  Clock event (high resolution timer) code should run at higher
  interrupt priority.

I labeled the system vector as generic to indicate that this is available to
other platforms.

Given the above issues, do you have any suggestions as to how I might best
resolve this?
