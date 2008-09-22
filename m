Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYIVXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYIVXEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYIVXEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:04:38 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57446 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbYIVXEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:04:38 -0400
Date: Mon, 22 Sep 2008 16:04:35 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Timur Tabi <timur@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, leoli@freescale.com, zw@zh-kernel.org
Subject: Re: Problems with Freescale DMA driver
Message-ID: <20080922230435.GA20825@ovro.caltech.edu>
References: <20080825165133.GA20446@ovro.caltech.edu> <e9c3a7c20809181458p4cabccblfde6a92bf35976ee@mail.gmail.com> <48D2D00B.3010001@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D2D00B.3010001@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 22 Sep 2008 16:04:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 05:02:51PM -0500, Timur Tabi wrote:
> Dan Williams wrote:
> > [adding Timur to the cc]
> > 
> > On Mon, Aug 25, 2008 at 9:51 AM, Ira Snyder <iws@ovro.caltech.edu> wrote:
> >> Hello LKML,
> >>
> >> I'm developing on a Freescale MPC8349EA MDS evaluation board. I'm
> >> currently testing the DMA controller. It uses the CONFIG_FSL_DMA driver.
> >>
> >> All tests were done with a recent git pull.
> 
> I just posted two patches lkml that affect the FSL DMA driver:
> 
> [PATCH v2] dmatest: properly handle duplicate DMA channels
> [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
> 
> Could you apply them both and re-run the tests?
> 

I have tested today's git pull with your patches. I had to add the
cell-index property to each DMA channel in the dts for my board. I just
added them as 0, 1, 2, and 3 respectively.

When your patch makes it in, you should probably add the cell-index to
all of the dts files that are missing them.

I was still able to cause the "DMA Halt Timeout" error message (on
channel 0, just like in the previous report).

To cause this, I built a kernel with CONFIG_DMATEST=y and
CONFIG_NET_DMA=y. Then, I ran the following concurrently:

netperf -H localhost -l 600
netperf -H 192.168.17.65 -l 600

While they were running, I got the "DMA Halt Timeout" message 6 times.
Here is the output (all messages were the same):
of_platform e0008100.dma-channe: DMA halt timeout!

The following output leads me to believe that NET_DMA is using channel 0
only:

cat /sys/class/dma/*/memcpy_count
1278897
198585
198681
198591

I was not able to cause the DMA controller to copy bad data. Perhaps the
kernel just had a bug at the time. It was still relatively early on in
the development cycle.

> I will also try to duplicate this here on an 8360.
> 

Thanks.

In a related note, I've been somewhat following the discussion on LKML
about creating an API for requesting a single DMA channel. This would be
great in a driver I've written for PCI communication over a backplane.
(I have a test board running in PCI Agent mode. It creates a virtual
ethernet interface that passes data over the PCI bus.)

Also, are there any plans to support the external start feature on the
83XX parts? (According to my datasheet, it is supported.) I will be
using this feature in a driver I will be starting fairly soon.

Thanks,
Ira
