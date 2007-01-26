Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbXAZWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbXAZWuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXAZWuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:50:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:13942 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXAZWuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:50:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,244,1167638400"; 
   d="scan'208"; a="173487369:sNHT21106792"
Message-ID: <45BA85CC.6060802@intel.com>
Date: Fri, 26 Jan 2007 14:50:52 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Auke Kok <auke-jan.h.kok@intel.com>
CC: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable
 to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com>
In-Reply-To: <45BA82DA.6050201@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 22:50:53.0419 (UTC) FILETIME=[6EDF73B0:01C7419C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Auke Kok wrote:
> Hi,
> 
> I've established a regression in the MSI vector/irq allocation routine for both 
> i386 and x86_64. Our test labs repeatedly modprobe/rmmod the e1000 driver for 
> serveral minutes which allocates msi vectors and frees them. These tests have 
> been running fine until 2.6.19.
> 
> git-bisecting I've established that in between commit 
> 04b9267b15206fc902a18de1f78de6c82ca47716 "Eric W. Biederman -- genirq: x86_64 
> irq: Remove the msi assumption that irq == vector" and commit 
> f29bd1ba68c8c6a0f50bd678bbd5a26674018f7c "Ingo Molnar -- genirq: convert the 
> x86_64 architecture to irq-chips" the behaviour broke.
> 
> The revisions in between seem to be dependent and give all sorts of other 
> issues, so it's rather hard for me to bisect that and give trustworthy results.
> 
> the e1000 driver hits the 256-mark cycle (I think - it consistently refuses to 
> do 500 msi irq/vector allocations which is my test case) and throws:
> 
> e1000: eth4: e1000_request_irq: Unable to allocate MSI interrupt Error: -16
> 
> which is caused by a `if ((err = pci_enable_msi(adapter->pdev))) {` call from 
> the e1000 driver. It's rather easy to hit this mark with the new 4-port e1000 
> adapters :).
> 
> as for the e1000 code, I can say that even our oldest msi-enabled e1000 driver 
> works fine with 2.6.18 and under. All kernels from 2.6.19 fail consistently.
> 
> I mostly suspect commit 7bd007e480672c99d8656c7b7b12ef0549432c37 at the moment. 
> Perhaps Eric Biederman can help?

PS PS

The exact same problem exists when doing "for n in `seq 1 300` ; do modprobe 
snd_hda_intel enable_msi ; rmmod snd_hda_intel ; done".

I'm sure it will show up for other msi enabled devices.
