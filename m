Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYF0A7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYF0A7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYF0A7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:59:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:40043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYF0A7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,712,1204531200"; 
   d="scan'208";a="582463274"
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for
	AVR32 users
From: Dan Williams <dan.j.williams@intel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Adrian Bunk <bunk@kernel.org>, Pierre Ossman <drzeus-list@drzeus.cx>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, "Nelson, Shannon" <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	 <20080626141552.GB30954@cs181140183.pp.htv.fi>
	 <20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 17:59:39 -0700
Message-Id: <1214528379.32709.51.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 07:46 -0700, Haavard Skinnemoen wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> > That discussion is mixing two different things I suggested besides other
> > things before the Kconfig file was added [1]:
> > - have DMA_ENGINE select'ed when a device gets enabled by the user,
> >   and not be an independent option
> > - switch to menuconfig and don't offer an empty kconfig menu
> >
> > There seems to be no disagreement about the former (which could
> > otherwise easily lead to users mistakenly enabling NET_DMA).
> >
> > The latter is more a cosmetical kconfig UI thing, and I already said
> > back then that it "could be dropped if it would become a problem" [2].
> 
> Ok, thanks for explaining. The menu does appear empty if I remove the
> architecture dependency without adding the driver...if that's a problem
> maybe we should do the HAVE_DMA_DEVICE thing...
> 
> > So if you want to remove the architecture dependency from the DMADEVICES
> > menu that's OK with me.
> 
> Ok, I'm gonna wait for Dan and others to respond. If it's fine with
> them, I'll post a patch removing the arch dependency.

I agree with removing the arch dependency, and I do not think we
necessarily need to add HAVE_DMA_ENGINE.  Taking an example from libata
the SATA_FSL driver depends on FSL_SOC but the menuconfig for ATA does
not.  We can use "depends on HAS_DMA" to make the menu disappear on
archs that will never have a dmaegine.  So I propose the following:

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6239c3d..e4dd006 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,13 +4,14 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC
-	depends on !HIGHMEM64G
+	depends on !HIGHMEM64G && HAS_DMA
 	help
 	  DMA engines can do asynchronous data transfers without
 	  involving the host CPU.  Currently, this framework can be
 	  used to offload memory copies in the network stack and
-	  RAID operations in the MD driver.
+	  RAID operations in the MD driver.  This menu only presents
+	  DMA Device drivers supported by the configured arch, it may
+	  be empty in some cases.
 
 if DMADEVICES
 
@@ -55,10 +56,12 @@ comment "DMA Clients"
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
+	default (INTEL_IOATDMA || FSL_DMA)
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
-	  Since this is the main user of the DMA engine, it should be enabled;
-	  say Y here.
+
+	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
+	  say N.
 
 endif



