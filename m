Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYFCGqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYFCGqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYFCGp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:45:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:54119 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYFCGp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:45:57 -0400
Date: Tue, 3 Jun 2008 15:43:43 +0900
To: muli@il.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       alexisb@us.ibm.com, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080603052146.GI7011@il.ibm.com>
References: <20080531133114P.tomof@acm.org>
	<20080603052146.GI7011@il.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080603150902Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 08:21:46 +0300
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Sat, May 31, 2008 at 01:31:33PM +0900, FUJITA Tomonori wrote:
> 
> > The calgary code can give drivers addresses above 4GB which is very
> > bad for hardware that is only 32bit DMA addressable:
> > 
> > http://lkml.org/lkml/2008/5/8/423
> > 
> > This patch tries to fix the problem by using per-device
> > dma_mapping_ops support. This fixes the calgary code to use swiotlb
> > or nommu properly for devices which are not behind the
> > Calgary/CalIOC2.
> > 
> > With this patch, the calgary code sets the global dma_ops to swiotlb
> > or nommu, and the dma_ops of devices behind the Calgary/CalIOC2 to
> > calgary_dma_ops. So the calgary code can handle devices safely that
> > aren't behind the Calgary/CalIOC2.
> 
> This seems a little backward to me. I thought we were going to get rid
> of the global dma_ops?

Yeah, I think that we can (though I'm not sure yet if it's the
cleanest way to handle IOMMUs). I think that it would better to clean
up the x86 IOMMU startup code a bit. Currently, IOMMUs interact too
much. It might take time for me to figure out the cleanest way so I
tried to fix the Calgary problem in the easiest way.

Yeah, I'm not sure if x86 maintainers are ok with the cleanup. If they
are, I'll try.


> If not, assuming going through the global one
> would be more efficient, Calgary should be the global one and
> nommu/swiotlb should be used on devices that do not have translation
> enabled. The reason why is that the majority of devices on a Calgary
> system, assuming Calgary is in use, will have translation enabled.

get_dma_ops() checks dev->archdata.dma_ops first then uses the global
if device dma_ops is NULL. So I'm not sure about the efficiency.

But I agreed that it's a bit odd to set nommu/swiotlb to the global
ops since the majority of devices uses calgary_ops on a Calgary
system, as you said. The patch does that just because seems that it's
the easiest way to handle devices that aren't behind Calgary.


> In general the patch looks good, barring the point above. We'll give
> it a spin on some Calgary/CalIOC2 machines.

Thanks,

Please feel free to drop the patch if you want to fix the problem
differently. I just wanted to see how the per-device ops can handle
the problem.
