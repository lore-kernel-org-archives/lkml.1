Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXEJIpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXEJIpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbXEJIpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:45:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:41923 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbXEJIpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:45:02 -0400
Subject: Re: [PATCH 1/3] powerpc: Fixup hard_irq_disable semantics
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <Pine.LNX.4.62.0705100942590.32241@pademelon.sonytel.be>
References: <20070510052620.EC36DDDF92@ozlabs.org>
	 <Pine.LNX.4.62.0705100942590.32241@pademelon.sonytel.be>
Content-Type: text/plain
Date: Thu, 10 May 2007 18:44:22 +1000
Message-Id: <1178786662.14928.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 09:44 +0200, Geert Uytterhoeven wrote:
> On Thu, 10 May 2007, Benjamin Herrenschmidt wrote:
> > This patch renames the raw hard_irq_{enable,disable} into
> > __hard_irq_{enable,disable} and introduces a higher level
> > hard_irq_disable() function that can be used by any code
> > to enforce that IRQs are fully disabled, not only lazy
> > disabled.
> 
> Why did you rename hard_irq_enable() too?
> 
> Isn't it more logical to have high-level hard_irq_disable() and
> hard_irq_enable(), and a special low-level __hard_irq_disable()?

Not really. If you see my subsequent patch, the idea is to introduce a
single generic hard_irq_disable() which is meant to be called with
irqs already disabled (that is within a local_irq_disable section) to
enforce that if the arch does lazy disabling, it gets hard disabled
at this point.

If we start adding hard_irq_enable() we end up in a can of worms:

 - Do we want all the full set of save/restore etc... ?
 - What if somebody does hard_enable while we are soft-disabled
   -and- have been hard disabled because of a pending interrupt ?
 - What's the point ? :-)

So overall, I want to keep the semantics as simple as they can be. Maybe
I can even add some WARN_ON() to make sure we are in a
local_irq_disable'd section even in the generic one instead of just a
NOP to enfore that.

Cheers,
Ben.


