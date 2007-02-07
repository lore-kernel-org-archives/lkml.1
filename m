Return-Path: <linux-kernel-owner+w=401wt.eu-S1422817AbXBGVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXBGVa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422808AbXBGVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:30:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422794AbXBGVa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:30:28 -0500
Date: Wed, 7 Feb 2007 13:30:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com,
       sumant.patro@lsi.com
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl
 processing
Message-Id: <20070207133020.4c58e271.akpm@linux-foundation.org>
In-Reply-To: <1170800394.10482.41.camel@dumbo>
References: <1170800394.10482.41.camel@dumbo>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 14:19:54 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> Preallocate memory for ioctl processing. This is to avoid situations 
> where ioctl fails for lack of memory (when system under heavy stress).
> The memory pool will have 8*4K, 4*8K and 1*64K memory chunks

mutter.

I suspect all this horror is due to stupidity in the DMA API.

pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
to use GFP_KERNEL.

I bet this fixes it:



diff -puN include/asm-generic/pci-dma-compat.h~a include/asm-generic/pci-dma-compat.h
--- a/include/asm-generic/pci-dma-compat.h~a
+++ a/include/asm-generic/pci-dma-compat.h
@@ -4,6 +4,7 @@
 #ifndef _ASM_GENERIC_PCI_DMA_COMPAT_H
 #define _ASM_GENERIC_PCI_DMA_COMPAT_H
 
+#include <linux/types.h>
 #include <linux/dma-mapping.h>
 
 /* note pci_set_dma_mask isn't here, since it's a public function
@@ -22,6 +23,13 @@ pci_alloc_consistent(struct pci_dev *hwd
 	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
 }
 
+static inline void *
+pci_alloc_consistent_not_stupid(struct pci_dev *hwdev, size_t size,
+		     dma_addr_t *dma_handle, gfp_t flags)
+{
+	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, flags);
+}
+
 static inline void
 pci_free_consistent(struct pci_dev *hwdev, size_t size,
 		    void *vaddr, dma_addr_t dma_handle)
diff -puN drivers/scsi/megaraid/megaraid_sas.c~a drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~a
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2655,9 +2655,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		kbuff_arr[i] = pci_alloc_consistent_not_stupid(instance->pdev,
 						    ioc->sgl[i].iov_len,
-						    &buf_handle);
+						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
 			printk(KERN_DEBUG "megasas: Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
@@ -2684,8 +2684,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	if (ioc->sense_len) {
-		sense = pci_alloc_consistent(instance->pdev, ioc->sense_len,
-					     &sense_handle);
+		sense = pci_alloc_consistent_nopt_stupid(instance->pdev,
+					ioc->sense_len, &sense_handle,
+					GFP_KERNEL);
 		if (!sense) {
 			error = -ENOMEM;
 			goto out;
_

