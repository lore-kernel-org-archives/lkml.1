Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbZDAVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbZDAVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZDAVBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:01:42 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:35939 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbZDAVBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:01:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: UIO: uio_mem does not handle devices above 4 GB address
Date: Wed, 1 Apr 2009 17:01:23 -0400
Message-ID: <6FCCA913376DD7488F4139A4D11B8F48AC8D51@troe2k1.cs.myharris.net>
In-Reply-To: <20090401201045.GB3734@bluebox.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: UIO: uio_mem does not handle devices above 4 GB address
Thread-Index: AcmzBfpjFR5gOCbqT3mwSnYFs76WEgABOAZw
References: <6FCCA913376DD7488F4139A4D11B8F48AC8CDE@troe2k1.cs.myharris.net> <20090401201045.GB3734@bluebox.local>
From: "Herrera-Bendezu, Luis" <lherrera@harris.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Apr 2009 21:01:24.0322 (UTC) FILETIME=[0433CC20:01C9B30D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans, 

-----Original Message-----
From: Hans J. Koch [mailto:hjk@linutronix.de] 
Sent: Wednesday, April 01, 2009 4:11 PM
To: Herrera-Bendezu, Luis
Cc: linux-kernel@vger.kernel.org
Subject: Re: UIO: uio_mem does not handle devices above 4 GB address


On Wed, Apr 01, 2009 at 01:20:49PM -0400, Herrera-Bendezu, Luis wrote:
>> I am working on a PPC440EPx board with some FPGAs located at
>> addresses above 4 GB

> That's not exactly a good idea on a 32-bit processor. Can't you remap
> that chip select to a decent address?
Well PPC440EPx implements a 32-bit effective address (EA) space. EA
is expanded into virtual address and then translated to 33-bit (8 GB)
real address by the MMU so real addresses > 4 GB are valid and used by
this CPU.

>> and kernel version 2.6.28.7. The UIO driver is
>> used to access the FPGAs. I get following error when trying to read
>> FPGA registers:
>> Machine check in kernel mode.
>> Data Read PLB Error
>> 
>> The problem is traced to member addr in struct uio_mem:
>> struct uio_mem {
>>     unsigned long     addr;
>>     unsigned long     size;
>>     int               memtype;
>>     void __iomem      *internal_addr;
>>     struct uio_map    *map;
>> };
>> 
>> When UIO_MEM_PHYS is used with device address > 32-bit then
>> uio_mmap_physical() remaps address using idev->info->mem[mi].addr
>> thus loosing high address bits.
>> 
>> One way to solve this problem is to change addr member to:
>>     phys_addr_t       addr;

> That alone won't solve the problem.

>> 
>> and modify corresponding attributes in uio.c. Only concern is that
>> uio_vma_fault() calls virt_to_page() and vmalloc_to_page() where both
>> have addr arg (unsigned long) and (const void *) respectively for
>> powerpc. But these functions are only used for UIO_MEM_LOGICAL and
>> UIO_MEM_VIRTUAL.

> That probably won't work without large modifications.
Can you elaborate a little more on the mods needed?

>> 
>> Any alternative approach?

> Yes, fix your hardware design.
As described above this CPU can to address up to 8 GB.
>
> Thanks,
> Hans

Thanks,
Luis
