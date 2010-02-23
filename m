Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0BWWxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:53:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:41995 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0BWWxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:53:16 -0500
Subject: Re: UIO support for >32-bit physical addresses on 32-bit platforms
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20100223194946.GA1941@local>
Date: Tue, 23 Feb 2010 16:52:56 -0600
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <100F3ED0-597E-4F4F-83CC-CC8505E3563F@kernel.crashing.org>
References: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org> <20100223150140.GA3781@suse.de> <20100223194946.GA1941@local>
To: "Hans J. Koch" <hjk@linutronix.de>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23, 2010, at 1:49 PM, Hans J. Koch wrote:

> On Tue, Feb 23, 2010 at 07:01:41AM -0800, Greg KH wrote:
>> On Tue, Feb 23, 2010 at 08:54:16AM -0600, Kumar Gala wrote:
>>> Hans, Greg,
>>> 
>>> We are looking at using UIO for some driver work and noticed it
>>> assumes the address for MMIO regions is an 'unsigned long'.  This is a
>>> problem for the platforms we have in which we support a 36-bit
>>> physical address in a 32-bit machine.
>>> 
>>> Should we just change addr/size in struct uio_mem to u64 always?
> 
> No, if I didn't miss something important, it's not feasible IMHO.
> 
>>> At
>>> first I was thinking phys_addr_t but realized the addr could be PHYS,
>>> LOGICAL, or VIRTUAL.
>> 
>> I think that would work out fine, Hans, any ideas if this would cause
>> any problems with existing code or not?
> 
> It won't work. This is not a UIO problem. UIO just passes addr to other
> system functions, and all of them use "unsigned long" for these addresses.
> You'd have to change the whole memory management code.
> 
> Note that members vm_start and vm_end in struct vm_area_struct are
> also unsigned long. Having an u64 in the UIO core doesn't help at all.

This already works for mmap since we pass down a PFN and not an address to remap_pfn_range.  While we can handle any physical address size we can handle one up to 44 bits on most architectures which is well beyond the 36-bit physical address case I'm dealing with on PPC.

> Memory above the 4G border can only be accessed through himem mechanisms
> or be mapped to an address below that border in lowlevel arch code.
> 
> In most cases, I'd say it's bad board design to have memory-mapped hardware
> above the 4G border on a 32-bit machine.

While I might agree with you its a reality on a number of embedded processors and I know three different PowerPC based embedded families that have 36-bit physical addressing to allow for >4G of DDR and thus IO ends up being above the 4G physical boundary and we already support these in the kernel.

- k