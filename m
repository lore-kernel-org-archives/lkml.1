Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYDSOL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYDSOL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYDSOLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:11:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59044 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYDSOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:11:22 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       Dave Olson <dave.olson@qlogic.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 19 Apr 2008 07:11:20 -0700
In-Reply-To: <20080419081614.GA2437@elte.hu> (Ingo Molnar's message of "Sat,
	19 Apr 2008 10:16:14 +0200")
Message-ID: <adaod86aq9j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Apr 2008 14:11:21.0171 (UTC) FILETIME=[3E3DA230:01C8A227]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > x86.git auto-testing found that these changes broke the -git build, with 
 > this config:
 > 
 >   http://redhat.com/~mingo/misc/config-Sat_Apr_19_09_55_05_CEST_2008.bad
 > 
 > the failure is a link failure:
 > 
 >  drivers/built-in.o: In function `ipath_init_one':
 >  ipath_driver.c:(.devinit.text+0x1e5bc): undefined reference to `ipath_init_iba7220_funcs'

Thanks.  The relevant parts of the config are

    # CONFIG_PCI_MSI is not set
    CONFIG_HT_IRQ=y
    CONFIG_INFINIBAND_IPATH=y

The problem is that the iba7220 files don't get built in that case, but
the main driver file tries to call ipath_init_iba7220 anyway.

This is fixed by the patch below, which makes the iba7220 file build
unconditionally.

I also removed the dependency on HT_IRQ || PCI_MSI in the Kconfig, since
the iba7220 support should work without it.  I know we discussed this
before, but looking closer at the code, the dependency seems pointless
to me, since it's still possible to build a driver that doesn't work if
a particular system needs, say HT_IRQ, and the user selects PCI_MSI.
And since iba7220 doesn't need either, we might as well let people build
that.

If this is OK with everyone, I will merge this with a proper changelog.

 - R.

diff --git a/drivers/infiniband/hw/ipath/Kconfig b/drivers/infiniband/hw/ipath/Kconfig
index 044da58..3c7968f 100644
--- a/drivers/infiniband/hw/ipath/Kconfig
+++ b/drivers/infiniband/hw/ipath/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPATH
 	tristate "QLogic InfiniPath Driver"
-	depends on (PCI_MSI || HT_IRQ) && 64BIT && NET
+	depends on 64BIT && NET
 	---help---
 	This is a driver for QLogic InfiniPath host channel adapters,
 	including InfiniBand verbs support.  This driver allows these
diff --git a/drivers/infiniband/hw/ipath/Makefile b/drivers/infiniband/hw/ipath/Makefile
index 75a6c91..bf94500 100644
--- a/drivers/infiniband/hw/ipath/Makefile
+++ b/drivers/infiniband/hw/ipath/Makefile
@@ -29,11 +29,13 @@ ib_ipath-y := \
 	ipath_user_pages.o \
 	ipath_user_sdma.o \
 	ipath_verbs_mcast.o \
-	ipath_verbs.o
+	ipath_verbs.o \
+	ipath_iba7220.o \
+	ipath_sd7220.o \
+	ipath_sd7220_img.o
 
 ib_ipath-$(CONFIG_HT_IRQ) += ipath_iba6110.o
 ib_ipath-$(CONFIG_PCI_MSI) += ipath_iba6120.o
-ib_ipath-$(CONFIG_PCI_MSI) += ipath_iba7220.o ipath_sd7220.o ipath_sd7220_img.o
 
 ib_ipath-$(CONFIG_X86_64) += ipath_wc_x86_64.o
 ib_ipath-$(CONFIG_PPC64) += ipath_wc_ppc64.o
