Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXJXG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXJXG7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXJXG7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:59:09 -0400
Received: from kuber.nabble.com ([216.139.236.158]:41094 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXJXG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:59:08 -0400
Message-ID: <13380086.post@talk.nabble.com>
Date: Tue, 23 Oct 2007 23:59:06 -0700 (PDT)
From: joncglenn <joncglenn@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: Mapping PCI memory to user-space
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: joncglenn@hotmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I am writing a driver to map a PCI board memory space (pcibar2) into a
user-space vma via 'mmap'.  What is the relationship between the address
returned from ioremap and the type of address needed in the
'io_remap_page_range' or 'remap_pfn_range' functions?  How about the
following? (I am developing under RHEL4 and a 2.6.9 kernel)

In the 'init' part of the driver:

     dev.pcibar2 = ioremap_nocache(resource,size);
     dev.region_start = dev.pcibar2 + offset;     // RAM is at some offset
from base
     dev.region_size  = <some size>

In the mydriver_mmap function:

static ssize_t mydriver_mmap (struct file *filp,
                                                    struct vm_area_struct
*vma)
{
  // off             = convert vm_pgoff back to user-space mmap 'off' value
  // phyaddr   = physical address of PCI memory area
  // vsize         = total size of area user wants to map
  // psize         = total avail size in device
  struct mydriver_dev *dev = filp->private_data;
  unsigned long off              = vma->vm_pgoff << PAGE_SHIFT;
  unsigned long phy            = __pa(dev->region_start + off);
  unsigned long vsize          = vma->vm_end - vma->vm_start;
  unsigned long psize          = dev->region_size - off;

  if (vsize > psize)
     return -EINVAL; /* spans too high */
  if (io_remap_page_range(vma, phyaddr, vma->vm_start, vsize,
vma->vm_page_prot))
     return -EAGAIN;

  vma->vm_ops    = &mydriver_vm_ops;
  vma->vm_flags |= VM_IO | VM_RESERVED;
  mydriver_vma_open(vma);

  return 0;
}

-- 
View this message in context: http://www.nabble.com/Mapping-PCI-memory-to-user-space-tf4682416.html#a13380086
Sent from the linux-kernel mailing list archive at Nabble.com.

