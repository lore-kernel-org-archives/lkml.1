Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYKQVyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYKQVyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYKQVyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:54:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:4426 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYKQVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wSH0plXb/fg5db4DzxUaGV1pQzQjeNsI2+Wy43SR8a9biH3W32hsFasI/lp44kb4B/
         QiSWSTrgc1N/zsMA36W7iCzEwgwSKKJmjJC6eso3WNg+PcyvOe5odegEdTqK0krp75Zi
         +s3lJh7JSqeRXtWvzoTyEd8C6mBpFnLK03aCw=
Message-ID: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
Date: Mon, 17 Nov 2008 22:54:33 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: pci_map_sg() does not coalesce adjacent physical memory? x86
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

pci_map_sg() does not coalesce the scattergather list for me on x86.
Is this expected? Documentation mentions that coalescing is typically
done by pci_map_sg().

Manually traversing scatterlists that describe large user space
allocations I found that on my system 25% reduction of list length can
be achieved.


static int sgm_map_to_table(struct sg_mapping_t *sgm)
{
        int i, j = 0;
        dma_addr_t addr = sg_dma_address(&sgm->sgl[0]);
        unsigned int len = sg_dma_len(&sgm->sgl[0]);
        dma_addr_t cont_addr = addr;
        unsigned int cont_len = len;
        for (i = 0; i < sgm->mapped_pages - 1; i++) {
                dma_addr_t next = sg_dma_address(&sgm->sgl[i + 1]);
                len = sg_dma_len(&sgm->sgl[i]);
                printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n",
i, addr, len);
                /* page i + 1 is non-contiguous with page i? */
                if (next != addr + len) {
                        /* TODO create entry here (we could overwrite i) */
                        printk(KERN_DEBUG "%4d: cont_addr=0x%08x
cont_len=0x%08x\n",
                                j++, cont_addr, cont_len);
                        cont_addr = next;
                        cont_len = 0;
                }
                /* add page i + 1 to current contiguous block */
                cont_len += len;
                /* goto page i + 1 */
                addr = next;
        }
        /* TODO create entry here  (we could overwrite i) */
        printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n", i, addr, len);
        printk(KERN_DEBUG "%4d: cont_addr=0x%08x length=0x%08x\n",
j++, cont_addr, cont_len);
}

Regards,
-- 
Leon
