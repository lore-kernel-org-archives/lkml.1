Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbZDARlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbZDARlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZDARlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:41:09 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:32269 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZDARlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:41:08 -0400
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 13:41:08 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: UIO: uio_mem does not handle devices above 4 GB address
Date: Wed, 1 Apr 2009 13:20:49 -0400
Message-ID: <6FCCA913376DD7488F4139A4D11B8F48AC8CDE@troe2k1.cs.myharris.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UIO: uio_mem does not handle devices above 4 GB address
Thread-Index: Acmy7jNciFodbr1kQ4u5rd4/KXsL3A==
From: "Herrera-Bendezu, Luis" <lherrera@harris.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Apr 2009 17:20:46.0072 (UTC) FILETIME=[31972780:01C9B2EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on a PPC440EPx board with some FPGAs located at
addresses above 4 GB and kernel version 2.6.28.7. The UIO driver is
used to access the FPGAs. I get following error when trying to read
FPGA registers:
Machine check in kernel mode.
Data Read PLB Error

The problem is traced to member addr in struct uio_mem:
struct uio_mem {
    unsigned long     addr;
    unsigned long     size;
    int               memtype;
    void __iomem      *internal_addr;
    struct uio_map    *map;
};

When UIO_MEM_PHYS is used with device address > 32-bit then
uio_mmap_physical() remaps address using idev->info->mem[mi].addr
thus loosing high address bits.

One way to solve this problem is to change addr member to:
    phys_addr_t       addr;

and modify corresponding attributes in uio.c. Only concern is that
uio_vma_fault() calls virt_to_page() and vmalloc_to_page() where both
have addr arg (unsigned long) and (const void *) respectively for
powerpc. But these functions are only used for UIO_MEM_LOGICAL and
UIO_MEM_VIRTUAL.

Any alternative approach?

Thanks,
Luis

