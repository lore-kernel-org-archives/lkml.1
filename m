Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXK0INT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXK0INT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXK0INI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:13:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXK0INH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:13:07 -0500
Date: Tue, 27 Nov 2007 00:13:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "peerchen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "pchen" <pchen@nvidia.com>,
       "acurrid" <acurrid@nvidia.com>
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT
 platform
Message-Id: <20071127001302.6e136aa3.akpm@linux-foundation.org>
In-Reply-To: <200711251121445151346@gmail.com>
References: <200711251121445151346@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 11:21:48 +0800 "peerchen" <peerchen@gmail.com> wrote:

> According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active. So it should be set when enable the MSI.
> 
> The patch base on kernel 2.6.24-rc3
> 
> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> 
> ---
> --- linux-2.6.24-rc3/drivers/pci/msi.c.orig	2007-11-23 17:28:45.000000000 -0500
> +++ linux-2.6.24-rc3/drivers/pci/msi.c	2007-11-23 17:50:59.000000000 -0500
> @@ -20,6 +20,8 @@
>  #include <asm/errno.h>
>  #include <asm/io.h>
>  
> +#include <asm/k8.h>

This inclusion makes msi.c x86-specific whereas it previously was not.  I
assume that this change breaks arm, ia64, sparc64 and powerpc.

I'll queue the below ugliness to avoid this, but it would be nicer to move
these functions out to an arch-specific file and then require that all
MSI-using architectures implement them.

diff -puN drivers/pci/msi.c~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix
+++ a/drivers/pci/msi.c
@@ -20,7 +20,9 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 
+#ifdef CONFIG_X86
 #include <asm/k8.h>
+#endif
 
 #include "pci.h"
 #include "msi.h"
@@ -292,6 +294,7 @@ void pci_restore_msi_state(struct pci_de
 }
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_X86
 /*
  * pci_enable_msi_ht_cap - Set the HT MSI mapping capability En bit of
  * a device.
@@ -384,6 +387,12 @@ static int pci_check_msi_ht_cap(struct p
 	}
 	return 0;
 }
+#else
+static inline int pci_check_msi_ht_cap(struct pci_dev *dev)
+{
+	return 0;
+}
+#endif
 
 /**
  * msi_capability_init - configure device's MSI capability structure
_

