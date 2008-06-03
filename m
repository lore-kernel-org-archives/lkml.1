Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYFCQzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYFCQzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYFCQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:55:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36223 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYFCQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:55:41 -0400
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
In-Reply-To: <20080603052146.GI7011@il.ibm.com>
References: <20080531133114P.tomof@acm.org>
	 <20080603052146.GI7011@il.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 09:55:37 -0700
Message-Id: <1212512137.8567.43.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 08:21 +0300, Muli Ben-Yehuda wrote:
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
> of the global dma_ops? If not, assuming going through the global one
> would be more efficient, Calgary should be the global one and
> nommu/swiotlb should be used on devices that do not have translation
> enabled. The reason why is that the majority of devices on a Calgary
> system, assuming Calgary is in use, will have translation enabled.
> 
> In general the patch looks good, barring the point above. We'll give
> it a spin on some Calgary/CalIOC2 machines.
Initial testing on a CalIO2 box this patch causes the machine not to
boot (and this time I tested the base 2.6.26-rc4 + FUJITA 2 per deive
dma_ops patches first and it boots just fine).  Here is a bit of the
dump from the failed boot:

Loading megaraid_sas
[17180656.651128] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
[17180656.657866] megasas: 0x1000:0x0060:0x1014:0x0363: bus 4:slot 0:func 0
[17180656.663899] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 46 (level, low) -> IRQ 46
[17180656.673677] megasas: FW now in Ready state
[17180657.774102] Calgary: DMA error on CalIOC2 PHB 0x3
[17180657.779171] Calgary: 0x02000000@CSR 0x00000000@PLSSR 0xb0008000@CSMR 0x00000000@MCK
[17180657.787212] Calgary: 0x00000000@0x810 0xf6200000@0x820 0xf6200040@0x830 0x00000000@0x840 0x06000000@0x850 0x00000000@0x860 0x00000000@0x870 
[17180657.801629] Calgary: 0x00000000@0xcb0

Adding some quick debug code it seems that the megaraid controller is
not getting its dev->dev.archdata.dma_ops set to calgary_dma_ops.  I am
not sure why, but will keep digging.  Any ideas?

--Alexis
> 
> Cheers,
> Muli
> 
> 

