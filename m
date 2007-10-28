Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbXJ1DHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbXJ1DHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXJ1DGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:06:53 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29366 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXJ1DGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:06:52 -0400
X-IronPort-AV: E=Sophos;i="4.21,338,1188802800"; 
   d="scan'208";a="243410542"
To: joncglenn <joncglenn@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Mapping PCI memory to user-space
X-Message-Flag: Warning: May contain useful information
References: <13380086.post@talk.nabble.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 27 Oct 2007 20:06:49 -0700
In-Reply-To: <13380086.post@talk.nabble.com> (joncglenn@hotmail.com's message of "Sat, 27 Oct 2007 18:39:00 -0700 (PDT)")
Message-ID: <adaejfgx7hy.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2007 03:06:50.0235 (UTC) FILETIME=[956F1CB0:01C8190F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I am writing a driver to map a PCI board memory space (pcibar2) into a
 > user-space vma via 'mmap'.  What is the relationship between the address
 > returned from ioremap and the type of address needed in the
 > 'io_remap_page_range' or 'remap_pfn_range' functions?  How about the
 > following? (I am developing under RHEL4 and a 2.6.9 kernel)

There is no relationship between the address returned from ioremap and
what you pass into io_remap_page_range().  ioremap gives you a kernel
virtual address for the PCI address you remap.  io_remap_page_range()
creates a userspace mapping in the same way, and you should pass in
the PCI address exactly the same way you pass in the PCI address into
ioremap.  io_remap_pfn_range() takes a PFN ("page frame number"),
which is basically the PCI address you want to map divided by
PAGE_SIZE.  The main reason for using PFNs is that they allow you to
map addresses above 4G even if sizeof long is only 4.

In your code:

 >      dev.pcibar2 = ioremap_nocache(resource,size);
 >      dev.region_start = dev.pcibar2 + offset;     // RAM is at some offset from base

This gives you a kernel mapping that you can use with readl(),
writel() etc to access the PCI memory from the kernel.

To map to userspace, this:

 >   if (io_remap_page_range(vma, phyaddr, vma->vm_start, vsize, vma->vm_page_prot))

should use phyaddr as you have it here:

 >   // phyaddr   = physical address of PCI memory area

This is just wrong:

 >   unsigned long phy            = __pa(dev->region_start + off);

__pa() doesn't work on addresses returned from ioremap.  Just use the
same resource address you passed into ioremap.

 - R.
