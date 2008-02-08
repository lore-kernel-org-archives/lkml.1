Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbYBHDpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbYBHDpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbYBHDpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:45:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbYBHDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:45:33 -0500
Message-ID: <47ABD056.5070304@torque.net>
Date: Thu, 07 Feb 2008 22:45:26 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: npiggin@suse.de
CC: akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 10/18] sg: nopage
References: <20071205071547.701344000@nick.local0.net> <20071205071627.793811000@nick.local0.net>
In-Reply-To: <20071205071627.793811000@nick.local0.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the patch shown below:

Signed-off-by: Douglas Gilbert <dougg@torque.net>



npiggin@suse.de wrote:
Convert SG from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
  drivers/scsi/sg.c |   23 +++++++++++------------
  1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c
+++ linux-2.6/drivers/scsi/sg.c
@@ -1144,23 +1144,22 @@ sg_fasync(int fd, struct file *filp, int
  	return (retval < 0) ? retval : 0;
  }

-static struct page *
-sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
+static int
+sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
  {
  	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
  	unsigned long offset, len, sa;
  	Sg_scatter_hold *rsv_schp;
  	struct scatterlist *sg;
  	int k;

  	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
+		return VM_FAULT_SIGBUS;
  	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
+	offset = vmf->pgoff << PAGE_SHIFT;
  	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
+		return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
  				   offset, rsv_schp->k_use_sg));
  	sg = rsv_schp->buffer;
  	sa = vma->vm_start;
@@ -1169,21 +1168,21 @@ sg_vma_nopage(struct vm_area_struct *vma
  		len = vma->vm_end - sa;
  		len = (len < sg->length) ? len : sg->length;
  		if (offset < len) {
+			struct page *page;
  			page = virt_to_page(page_address(sg_page(sg)) + offset);
  			get_page(page);	/* increment page count */
-			break;
+			vmf->page = page;
+			return 0; /* success */
  		}
  		sa += len;
  		offset -= len;
  	}

-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	return VM_FAULT_SIGBUS;
  }

  static struct vm_operations_struct sg_mmap_vm_ops = {
-	.nopage = sg_vma_nopage,
+	.fault = sg_vma_fault,
  };

  static int


