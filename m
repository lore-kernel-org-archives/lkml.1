Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab0BQKHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:07:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:50934 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900Ab0BQKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:07:38 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100217095553.GA30033@n2100.arm.linux.org.uk>
References: <20100208065519.GE1290@ucw.cz>
	 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	 <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
	 <20100217095553.GA30033@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 21:05:49 +1100
Message-ID: <1266401149.16346.276.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 09:55 +0000, Russell King - ARM Linux wrote:
> Nope.  It's to do with mapping a buffer for DMA, and then doing PIO
> reads/writes to it.
> 
> With speculative prefetches, you have to deal with cache coherency with
> hardware DMA on DMA unmap.  If you've written to the buffer in violation
> of the DMA API buffer ownership rules, then your writes get thrown away
> resulting in immediate data corruption. 

Right, and this exact same problem will bite some embedded powerpc
too I suppose :-)

Hrm... actually not :-) We don't do the invalidate at unmap time
today because we know 44x have such a broken prefetcher that we disable
it ... interesting considering that there are machines around that
do non-coherent DMA with 750's style chips who -do- have a prefetcher...
damn, we have a bug :-)

In any case, same problem here.

See my reply to Oliver. Basically, the problem boils down to the
dma_map/unmap being done at the wrong layer. The driver should
simply not do these if it's going to do PIO over that range.

Cheers,
Ben.


