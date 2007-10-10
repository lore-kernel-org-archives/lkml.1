Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXJJFav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXJJFav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXJJFan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:30:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:32783 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbXJJFam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:30:42 -0400
Date: Wed, 10 Oct 2007 11:00:58 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: chandru <chandru@in.ibm.com>, linux-kernel@vger.kernel.org,
       mark_salyzyn@adaptec.com, ak@suse.de
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Message-ID: <20071010053057.GA24434@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009210623.GK4335@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:06:23PM +0200, Muli Ben-Yehuda wrote:
> Hi Chandru,
> 
> Thanks for the patch. Comments on the patch below, but first a general
> question for my education: the main problem here that aacraid
> continues DMA'ing when it shouldn't. Why can't we shut it down
> cleanly? Even without the presence of an IOMMU, it seems dangerous to
> let an adapter continue DMA'ing to and from memory when the kernel is
> an inconsistent state.
> 

Hi Muli,

After the kernel crash, we can't rely on the crashed kernel's data
structures or methods any more. We can't call the device shutdown methods of
all the device drivers as we might be invoking a driver which actually might
have caused the crash. Hence we don't perform any device shutdown
in the case of kdump. Instead after the crash, we try to take the shortest
route to second kernel (Execute minimum code in crashed kernel).

Whatever special handling is required to bring up the second kernel on 
a potentially unknown state hardware, is taken in second kernel.

We will not be too concerned about ongoing DMA's as long as there is no
corruption of tce tables. That would mean DMA is happening in first
kernel's memory buffer and second kernel is not impacted. But if TCE
tables themselves are corrupted, then it can potentially interfere with
second kernel's operation. Don't know how it can be addressed.
  
> The patch below looks reasonable *if* that is the least worst way of
> doing it - let's see if we can come up with something cleaner that
> doesn't rely in the new kernel on data (which may or may not be
> corrupted...) from the old kernel.
> 

I think the issue here is that some DMA was going on when first kernel
crashed. After the crash, second kernel booted and created new TCE tables
and switched to it. This resulted in ongoing DMA failure and hardware raised
an alarm. 

In this case, probably it would make sense to re-use the TCE tables of
previous kernel (until and unless we have a way to tell hardware not
to flag a DMA error if TCE mapping is changed while DMA is going on ?)

I think, we also need to reserve some TCE table entries (in first kernel),
which can be used by second kernel for saving kernel core file to disk. There
might be a case where first kernel has used up all TCE entries and second
kernel can't allocate more. I think ppc64 has taken the approach of freeing
some entries in second kernel but that will have the problem as you might
be clearing an entry which is being used by ongoing DMA.  

Thanks
Vivek
