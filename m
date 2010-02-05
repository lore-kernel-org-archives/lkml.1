Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0BELFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:05:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55493 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014Ab0BELE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:04:58 -0500
Subject: Re: [RFC PATCH] ARM: Change the mandatory barriers implementation
From: Catalin Marinas <catalin.marinas@arm.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry Bassel <lbassel@quicinc.com>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1265289330.28746.58.camel@pc1117.cambridge.arm.com>
References: <4B6A131B.1070005@codeaurora.org>
	 <1265289330.28746.58.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 05 Feb 2010 11:04:33 +0000
Message-Id: <1265367873.7692.52.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2010 11:04:34.0552 (UTC) FILETIME=[FFF90780:01CAA652]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 13:15 +0000, Catalin Marinas wrote:
> On Thu, 2010-02-04 at 00:21 +0000, Abhijeet Dharmapurikar wrote:
> > > The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
> > > systems for things like ordering Normal Non-cacheable memory accesses
> > > with DMA transfer (via Device memory writes). The current implementation
> > > uses dmb() for mb() and friends but this is not sufficient. The DMB only
> > > ensures the ordering of accesses with regards to a single observer
> > > accessing the same memory. If a DMA transfer is started by a write to
> > > Device memory, the data to be transfered may not reach the main memory
> > > (even if mapped as Normal Non-cacheable) before the device receives the
> > > notification to begin the transfer. The only barrier that would help in
> > > this situation is DSB which would completely drain the write buffers.
> >
> > On ARMv7, DMB guarantees that all accesses prior to DMB are observed by
> > an observer if that observer sees any accesses _after_ the DMB. In this
> > case, since DMA engine observes a write to itself( It is being written
> > to and hence must observe the write) it should also see the writes to
> > the buffers. A dmb() after the writes to buffer and before write to DMA
> > engine should suffice.
> 
> I asked our processor architect for a clarification on the wording of
> the DMB definition but the "all accesses" part most likely refer to
> accesses to the same peripheral or memory block (but not together).

I got some clarification and there is nothing wrong with the definition
of the DMB. The catch here is that "observe" (as per the ARM ARM) is
defined only for master accesses. The DMA engine in this case above does
not "observe" the write to itself as this is a slave access to one of
its memory-mapped ports.

So, the code below:

	STR	[Normal non-cacheable]
	DMB
	STR	[Device]

puts the first store in Group A (according to the DMB definition) and
the second store in Group B but since the DMA device does not "observe"
Group B in this case, there is no requirement for the ordering between
the observability of the store to normal memory and the observability of
the side-effects of the store to the DMA device.

-- 
Catalin

