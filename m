Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0CCJlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:41:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58904 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0CCJlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:41:07 -0500
Date: Wed, 3 Mar 2010 09:36:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       catalin.marinas@arm.com, mdharm-kernel@one-eyed-alien.net,
       oliver@neukum.org, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100303093650.GA22482@n2100.arm.linux.org.uk>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com> <1267572594.2173.25.camel@pasglop> <20100303124624Z.fujita.tomonori@lab.ntt.co.jp> <1267593032.16696.1.camel@pasglop> <1267594809.4383.27.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267594809.4383.27.camel@mulgrave.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:10:09AM +0530, James Bottomley wrote:
> On Wed, 2010-03-03 at 16:10 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2010-03-03 at 12:47 +0900, FUJITA Tomonori wrote:
> > > The ways to improve the approach (introducing PG_arch_2 or marking a
> > > page clean on dma_unmap_* with DMA_FROM_DEVICE like ia64 does) is up
> > > to architectures. 
> > 
> > How does the above work ? IE, the dma unmap will flush the D side but
> > not the I side ... or is the ia64 flush primitive magic enough to do
> > both ?
> 
> The point is that in a well regulated system, the I cache shouldn't need
> extra flushing in the kernel.  We should only be faulting in R-X pages.

James, that's a pipedream.  If you have a processor which doesn't support
NX, then the kernel marks all regions executable, even if the app only
asks for RW protection.

You end up with the protection masks always having VM_EXEC set in them,
so there's no way to distinguish from the kernel POV which pages are
going to be executed and those which aren't.

And if you can't do that, you have to _always_ flush the I cache for
every page fault, because you don't know if the I cache is out of sync
with the page that you've just read in from disk - and therefore you
may end up executing bad code instead of the glibc text that was
intended.

So here's the question: in a system where the responsibility for I-cache
flushing is in userspace, how do you ensure that you can execute code
in userspace to do this I-cache flushing without first having flushed
the (speculatively prefetching) I-cache?
