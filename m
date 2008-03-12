Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbYCLJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbYCLJ6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYCLJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:58:12 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:19458 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCLJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:58:11 -0400
Date: Wed, 12 Mar 2008 11:58:20 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jdmason@kudzu.us
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080312095820.GG10790@tyrion.haifa.ibm.com>
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com> <476F4064.8010601@in.ibm.com> <47D5359D.5000909@in.ibm.com> <20080311132921.GA10828@redhat.com> <47D76561.8050805@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D76561.8050805@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:38:49AM +0530, Chandru wrote:

> The system booted! , :) with the following change. Muli acceptable??
>
> static void calgary_watchdog(unsigned long data)
> {
> ...
> ...
> /* Disable bus that caused the error and ignore if it's kdump kernel */
> + if ( !is_kdump_kernel()) {
> target = calgary_reg(bbar, phb_offset(tbl->it_busno) |
> PHB_CONFIG_RW_OFFSET);
> val32 = be32_to_cpu(readl(target));
> val32 |= PHB_SLOT_DISABLE;
> writel(cpu_to_be32(val32), target);
> + }
> readl(target); /* flush */

Yikes, not really :-)

You're basically saying "if we're in a kdump kernel, let's ignore all
DMA errors and hope for the best". This is not really acceptable. What
we could do is limit the scope of ignorance - only ignore errors from
the point the kdump kernel starts booting until we have reinitialized
the device and then go back to handling DMA errors correctly.

Cheers,
Muli
