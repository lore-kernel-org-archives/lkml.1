Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYCLFJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYCLFJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYCLFJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:09:02 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:48084 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbYCLFJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:09:00 -0400
Message-ID: <47D76561.8050805@in.ibm.com>
Date: Wed, 12 Mar 2008 10:38:49 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Muli Ben-Yehuda <muli@il.ibm.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdmason@kudzu.us
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
 in kdump
References: <1191962414.24134.68.camel@chandru> <20071009210623.GK4335@rhun.haifa.ibm.com> <20071010053057.GA24434@in.ibm.com> <20071014054110.GB4399@rhun.haifa.ibm.com> <20071015062919.GA4598@in.ibm.com> <476F4064.8010601@in.ibm.com> <47D5359D.5000909@in.ibm.com> <20080311132921.GA10828@redhat.com>
In-Reply-To: <20080311132921.GA10828@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Chandru,
>
> - How do we make sure that previous kernel's TCE tables are not
>   overwritten
>   by new kernel (In case previous kernel allocated TCE tables in first
>   640 KB?)
>   
TCE tables are allocated using alloc_bootmem_low() with goal set to 0. 
Don't know if this will be sufficient. Investigating...
> - How do we make sure that when new kernel tries to setup an entry in
>   TCE table, then it does not try to clear up an existing entry which is
>   still in use?
>   
A bitmap is created once the first kernel's TCE table is found. This 
bitmap is populated by reading the entries in the tce table. Non-zero 
entries in the table are marked as used/reserved in the bitmap.
> Did you try the Muli suggestion of ignoring DMA error in exception
> handler?
With what I tried, I was not successful
>  What happens if I setup new table and try to switch to new
> table?
This is the root cause of the problem.
>  Some sort of error will occur.
The pci bus on that PHB goes into an undefined state ( returning 
0xffffffff for all reads on that bus ).
>  Can't we modify the handler and
> ignore it for kdump case and move on?
>   
The system booted! , :) with the following change. Muli acceptable??

static void calgary_watchdog(unsigned long data)
{
...
...
/* Disable bus that caused the error and ignore if it's kdump kernel */
+ if ( !is_kdump_kernel()) {
target = calgary_reg(bbar, phb_offset(tbl->it_busno) |
PHB_CONFIG_RW_OFFSET);
val32 = be32_to_cpu(readl(target));
val32 |= PHB_SLOT_DISABLE;
writel(cpu_to_be32(val32), target);
+ }
readl(target); /* flush */
..
..
}
> Thanks
> Vivek
>   
-Chandru
