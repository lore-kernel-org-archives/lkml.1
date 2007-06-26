Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbXFZHNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbXFZHNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 03:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXFZHND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 03:13:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:57679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXFZHNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 03:13:00 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Date: Tue, 26 Jun 2007 09:12:45 +0200
User-Agent: KMail/1.9.6
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070625234550.058635cb.akpm@linux-foundation.org>
In-Reply-To: <20070625234550.058635cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260912.45838.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 08:45:50 Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:37:01 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > 	This patch supports the upcomming Intel IOMMU hardware
> > a.k.a. Intel(R) Virtualization Technology for Directed I/O 
> > Architecture
> 
> So...  what's all this code for?
> 
> I assume that the intent here is to speed things up under Xen, etc? 

Yes in some cases, but not this code. That would be the Xen version
of this code that could potentially assign whole devices to guests.
I expect this to be only useful in some special cases though because
most hardware is not virtualizable and you typically want an own
instance for each guest.

Ok at some point KVM might implement this too; i likely would
use this code for this.

> Do we 
> have any benchmark results to help us to decide whether a merge would be
> justified?

The main advantage for doing it in the normal kernel is not performance, but 
more safety. Broken devices won't be able to corrupt memory by doing
random DMA.

Unfortunately that doesn't work for graphics yet, for that need
user space interfaces for the X server are needed.

There are some potential performance benefits too:
- When you have a device that cannot address the complete address range
an IOMMU can remap its memory instead of bounce buffering. Remapping
is likely cheaper than copying. 
- The IOMMU can merge sg lists into a single virtual block. This could
potentially speed up SG IO when the device is slow walking SG lists.
[I long ago benchmarked 5% on some block benchmark with an old
MPT Fusion; but it probably depends a lot on the HBA]

And you get better driver debugging because unexpected memory accesses
from the devices will cause an trapable event.

> 
> Does it slow anything down?

It adds more overhead to each IO so yes.

-Andi

