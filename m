Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYC0LFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYC0LFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYC0LFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:05:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbYC0LFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:05:20 -0400
Subject: Re: [PATCH 15/20] x86: move dma_supported and dma_set_mask to
	pci-dma_32.c
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       avi@qumranet.com, amit.shah@qumranet.com
In-Reply-To: <1206480999-21767-16-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-10-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-11-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-12-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-13-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-14-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-15-git-send-email-gcosta@redhat.com>
	 <1206480999-21767-16-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 11:03:15 +0000
Message-Id: <1206615795.31683.8.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 18:36 -0300, Glauber Costa wrote:
> This is the way x86_64 does, so this make them equal. They have
> to be extern now in the header, and the extern definition is moved to
> the common dma-mapping.h header
> 
> Signed-off-by: Glauber Costa <gcosta@redhat.com>
...
> diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
> index 5133032..453b4bd 100644
> --- a/arch/x86/kernel/pci-dma_32.c
> +++ b/arch/x86/kernel/pci-dma_32.c
> @@ -156,6 +156,39 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
>  int forbid_dac;
>  EXPORT_SYMBOL(forbid_dac);
>  
> +int
> +dma_supported(struct device *dev, u64 mask)
> +{
...
> +}
> +
> +int
> +dma_set_mask(struct device *dev, u64 mask)
> +{
...
> +}
...
> diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
> index e60c30a..fd7246d 100644
> --- a/include/asm-x86/dma-mapping_32.h
> +++ b/include/asm-x86/dma-mapping_32.h
> @@ -17,35 +17,6 @@ dma_mapping_error(dma_addr_t dma_addr)
>  extern int forbid_dac;
>  
>  static inline int
> -dma_supported(struct device *dev, u64 mask)
> -{
...
> -}
> -
> -static inline int
> -dma_set_mask(struct device *dev, u64 mask)
> -{
...
> -}

This breaks for me with:

ERROR: "dma_supported" [drivers/ssb/ssb.ko] undefined!
ERROR: "dma_set_mask" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
ERROR: "dma_set_mask" [drivers/scsi/aic7xxx/aic7xxx.ko] undefined!
ERROR: "dma_set_mask" [drivers/scsi/aic7xxx/aic79xx.ko] undefined!
ERROR: "dma_supported" [drivers/net/pcnet32.ko] undefined!
ERROR: "dma_supported" [drivers/media/video/saa7134/saa7134.ko] undefined!
ERROR: "dma_set_mask" [drivers/media/video/meye.ko] undefined!
ERROR: "dma_supported" [drivers/media/video/cx88/cx8802.ko] undefined!
ERROR: "dma_supported" [drivers/media/video/cx88/cx8800.ko] undefined!
ERROR: "dma_supported" [drivers/media/video/cx88/cx88-alsa.ko] undefined!
ERROR: "dma_supported" [drivers/media/video/cx23885/cx23885.ko] undefined!

They just need to be exported like on x86_64.

Cheers,
Mark.

Subject: [PATCH] x86: export dma_supported() and dma_set_mask() on i386

dma_supported() and dma_set_mask() were previously inlined,
but are now moved to pci-dma_32.c.

Since they're used by various drivers, they need to be
exported.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 55ab3c8..be6b1f6 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -180,6 +180,7 @@ dma_supported(struct device *dev, u64 mask)
 
 	return 1;
 }
+EXPORT_SYMBOL(dma_supported);
 
 int
 dma_set_mask(struct device *dev, u64 mask)
@@ -191,6 +192,7 @@ dma_set_mask(struct device *dev, u64 mask)
 
 	return 0;
 }
+EXPORT_SYMBOL(dma_set_mask);
 
 
 static __devinit void via_no_dac(struct pci_dev *dev)

