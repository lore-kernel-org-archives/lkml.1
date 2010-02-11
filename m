Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0BKKx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:53:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39342 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab0BKKxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:53:23 -0500
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, adharmap@codeaurora.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
In-Reply-To: <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
References: <20100210212156.GB30854@n2100.arm.linux.org.uk>
	 <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Feb 2010 10:53:05 +0000
Message-Id: <1265885585.3389.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2010 10:53:06.0390 (UTC) FILETIME=[64465760:01CAAB08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 10:45 +0000, Catalin Marinas wrote:
> On Wed, 2010-02-10 at 21:21 +0000, Russell King - ARM Linux wrote:
> > @@ -345,6 +347,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
> >         BUG_ON(!valid_dma_direction(dir));
> >
> >         __dma_single_cpu_to_dev(cpu_addr, size, dir);
> > +       __dma_barrier(dir);
> >
> >         return virt_to_dma(dev, cpu_addr);
> >  }
> 
> The ___dma_single_cpu_to_dev() covers both inner and outer caches but I
> haven't seen it touched by this patch (nor the other you posted). When
> you clean the L1 cache, you need to make sure that there is a barrier
> (DSB) so that it completes before cleaning the L2, otherwise you clean
> the L2 but data keeps coming from L1.

Actually after L2 maintenance we don't even need the __dma_barrier(), we
need an outer_cache.sync() function.

I can do the outer cache optimisations together with a few others for
PL310 (which does not require the cache_wait() call for line
operations).

-- 
Catalin

