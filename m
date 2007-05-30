Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXE3ORt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXE3ORt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXE3ORj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:17:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42857 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbXE3ORh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:17:37 -0400
Date: Wed, 30 May 2007 19:47:23 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: kexec and aacraid broken
Message-ID: <20070530141723.GB3773@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070530132430.GA3773@in.ibm.com> <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FEE@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FEE@otce2k301.adaptec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:57:08AM -0400, Salyzyn, Mark wrote:
> This is clouding the issue, Vivek.
> 
> There should be no harm, except to time, resetting the adapter. I do
> want to optimize for boot time, but do not view this as a 'bug' if the
> Adapter should reset during the initialization procedure. We need
> instead to harden the driver to deal with Adapters that behave in an
> untimely manner as a result of the reset since this generically deals
> with all possible transitions (boot w/o BIOS, w/BIOS, kexec and kdump).
> 

Hi Mark,

I agree. We should make sure that we should be able to do a software
reset of adapters.

> I will look into a possibility the driver is not performing the clean
> shutdown as a result of a kexec, but that is a refinement and should not
> be considered a fix for *this* reported problem; it merely moves the
> problem to a kdump.

Agreed. I just wanted to bring out this point that right now we are
triggering software reset on every kexec and probably that is not 
required. One can avoid it to save boot time. That was the whole
purpose of kexec (fastboot) project.  

But this is not a fix for this problem. We should any way be able to
reset the device and should root cause this.

> The driver only disables the interrupts when the
> driver is .remove'd (aac_remove_one) and not for .shutdown
> (aac_shutdown). The later merely tells the firmware to stop performing
> builds if in progress, flush the cache, and all subsequent writes are
> performed in write-through mode; it does not clear out the driver
> resources and leaves that to the .remove function only. The failure of
> .remove being called may be a result of this being a boot driver?
> 


> Also, the code:
> 
>         dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
>         if ((((status & 0x0c) != 0x0c) . . .
> 
> detects if the adapter's interrupts were disabled, as would happen on a
> clean shutdown. Some of the Adapters can NOT disable their interrupts,
> and some have a default state with the interrupts enabled. If the
> Adapter still has active interrupts, then there is no telling what
> transpired before and it is considered a safety measure to reset the
> Adapter in these cases. I'd prefer to err on the side of resetting the
> Adapter superfluously than deal with a condition where the Adapter could
> be in an unknown state with a possibility of sustaining an outstanding
> command and associated interrupt (which was the whole reason this code
> was introduced).
> 

So most likely if we start disabling the interrupts in .shutdown routine
we might skip resetting adapter on every kexec without any side affects?

Thanks
Vivek
