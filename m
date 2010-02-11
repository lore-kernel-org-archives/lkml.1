Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0BKK5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:57:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55055 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0BKK47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:56:59 -0500
Date: Thu, 11 Feb 2010 10:56:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
Message-ID: <20100211105638.GB9480@n2100.arm.linux.org.uk>
References: <20100210212156.GB30854@n2100.arm.linux.org.uk> <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:45:01AM +0000, Catalin Marinas wrote:
> Alternatively we could use the dsb() macro. I don't think we need more
> than this and we would not (well, not easily) compile ARMv5 and ARMv6 in
> the same kernel.

That doesn't work - ARMv3 and some ARMv4 don't have a 'drain write
buffer' instruction but others do - executing that instruction on
older CPUs which don't have a write buffer causes an illegal
instruction fault.

> The ___dma_single_cpu_to_dev() covers both inner and outer caches but I
> haven't seen it touched by this patch (nor the other you posted). When
> you clean the L1 cache, you need to make sure that there is a barrier
> (DSB) so that it completes before cleaning the L2, otherwise you clean
> the L2 but data keeps coming from L1.
> 
> For the *_sg functions, you either use barrier between L1 and L2 for
> each page or you do the for_each_sg() loop twice, once for L1 and
> another for L2.

Okay, that's a fundamental problem with this approach.  Spanner in the
works kind of thing.  I think that's a problem for Abhijeet's patch
as well - since the same comment appears to apply there too.

Sounds like it needs a totally different approach then.
