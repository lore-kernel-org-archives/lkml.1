Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZDBNk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZDBNk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZDBNkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:40:49 -0400
Received: from mlbe2k1.cs.myharris.net ([137.237.90.88]:46894 "EHLO
	mlbe2k1.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZDBNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:40:48 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 09:40:48 EDT
Message-ID: <49D4BB9F.8050903@harris.com>
Date: Thu, 02 Apr 2009 09:20:31 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, hjk@linutronix.de,
       "Herrera-Bendezu, Luis" <lherrera@harris.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: UIO: uio_mem does not handle devices above 4 GB address
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 13:20:32.0835 (UTC) FILETIME=[CD0B7930:01C9B395]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 01, 2009 at 01:20:49PM -0400, Herrera-Bendezu, Luis wrote:
> >> I am working on a PPC440EPx board with some FPGAs located at
> >> addresses above 4 GB

Cc'ing the PPC list, since they have the most experience with this
CPU, and may have some useful insights.  The topic is "UIO on the
PPC440EPx - 36-bit physical addresses".

The PPC440EPx uses 36-bit addressing but is a 32-bit processor.
*All* peripherals are above the first 4 GB - that cannot be changed
if you use this CPU chip.

In general, the solution is to use "struct resource" to carry physical
addresses and sizes.  The basic type is:

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

and for this processor, we use u64 rather than u32.

So, if we want to make UIO usable on this class of CPU, we might
replace:

struct uio_mem {
	unsigned long		addr;
	unsigned long		size;
	int			memtype;
	void __iomem		*internal_addr;
	struct uio_map		*map;
};

with:

struct uio_mem {
	phys_addr_t		addr;
	phys_addr_t		size;
	int			memtype;
	void __iomem		*internal_addr;
	struct uio_map		*map;
};

A few other changes would be needed.  We'd have to use something
other than

	return sprintf(buf, "0x%lx\n", mem->addr);

because the format would be incorrect for a u64.  Also, I believe
we would get warnings in uio_vma_fault().  However, the phys_addr
is really only applicable to UIO_MEM_PHYS, so perhaps we want a
union of phys_addr_t and unsigned long for addr and size?

Anyway, this is a real problem for the PPC440EPx, that board 
designers cannot work around.

	Steve

