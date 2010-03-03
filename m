Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0CCKYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:24:51 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48190 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0CCKYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:24:50 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       catalin.marinas@arm.com, mdharm-kernel@one-eyed-alien.net,
       oliver@neukum.org, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100303093650.GA22482@n2100.arm.linux.org.uk>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <1267572594.2173.25.camel@pasglop>
	 <20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
	 <1267593032.16696.1.camel@pasglop> <1267594809.4383.27.camel@mulgrave.site>
	 <20100303093650.GA22482@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 15:54:37 +0530
Message-ID: <1267611877.15025.59.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 09:36 +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 03, 2010 at 11:10:09AM +0530, James Bottomley wrote:
> > On Wed, 2010-03-03 at 16:10 +1100, Benjamin Herrenschmidt wrote:
> > > On Wed, 2010-03-03 at 12:47 +0900, FUJITA Tomonori wrote:
> > > > The ways to improve the approach (introducing PG_arch_2 or marking a
> > > > page clean on dma_unmap_* with DMA_FROM_DEVICE like ia64 does) is up
> > > > to architectures. 
> > > 
> > > How does the above work ? IE, the dma unmap will flush the D side but
> > > not the I side ... or is the ia64 flush primitive magic enough to do
> > > both ?
> > 
> > The point is that in a well regulated system, the I cache shouldn't need
> > extra flushing in the kernel.  We should only be faulting in R-X pages.
> 
> James, that's a pipedream.  If you have a processor which doesn't support
> NX, then the kernel marks all regions executable, even if the app only
> asks for RW protection.

I'm not talking about what the processor supports ... I'm talking about
what the user sets on the VMA.  My point is that the kernel only has
responsibility in specific situations ... it's those paths we do the I/D
coherency on.

> You end up with the protection masks always having VM_EXEC set in them,
> so there's no way to distinguish from the kernel POV which pages are
> going to be executed and those which aren't.

I think you're talking about the pte page flags, I'm talking about the
VMA ones above.

> And if you can't do that, you have to _always_ flush the I cache for
> every page fault, because you don't know if the I cache is out of sync
> with the page that you've just read in from disk - and therefore you
> may end up executing bad code instead of the glibc text that was
> intended.

If you're doing a not present, fault in a VMA executable region, I
agree ... since that's the start of the lifecycle where we have to begin
with I/D coherent.

> So here's the question: in a system where the responsibility for I-cache
> flushing is in userspace, how do you ensure that you can execute code
> in userspace to do this I-cache flushing without first having flushed
> the (speculatively prefetching) I-cache?

I'm not saying the common path (faulting in text sections) is the
responsibility of user space.  I'm saying the uncommon path, write
modification of binaries, is.  So the kernel only needs to worry about
the ordinary text fault path.

James


