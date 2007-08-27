Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbXH0FJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbXH0FJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 01:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXH0FJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 01:09:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42873 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXH0FJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 01:09:07 -0400
Date: Mon, 27 Aug 2007 10:30:27 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2 -mm] kexec based hibernation
Message-ID: <20070827050027.GB9809@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1188177245.3247.36.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188177245.3247.36.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 09:14:05AM +0800, Huang, Ying wrote:
> Kexec base hibernation has some potential advantages over uswsusp and
> TuxOnIce (suspend2). Some most obvious advantages are:
> 
> 1. The hibernation image size can exceed half of memory size easily.
> 
> 2. The hibernation image can be written to and read from almost
>    anywhere, such as USB disk, NFS.
> 
> 3. It is possible to eliminate freezer from kexec based hibernation
>    implementation.
> 
> 4. Based on kexec/kdump implementation, the kernel code needed is
>    less.
> 
> 
> This patch set implements a prototype of kexec based hibernation. The
> kernel functionalities added are as follow:
> 
> 1. Jumping from kexeced kernel back to original kernel. This is used
>    by hibernation to save/load necessary state in original kernel and
>    jumping back to original kernel after restore the memory of
>    original kernel.
> 
> 2. Add writing support to /dev/oldmem. This is used by hibernation to
>    restore the memory of original kernel.
> 
> 
> The hibernation process with the patch set is as follow:
> 
> 1. Boot a kernel A
> 
> 2. Work under kernel A
> 
> 3. Kexec another kernel B (crash dump enabled) in kernel A.
> 
> 4. Save the memory image of kernel A through crash dump (such as "cp
>    /proc/vmcore ~"). Save the "jump buffer pfn".
> 
> 5. Shutdown or reboot
> 
> 
> The restore process with the patch set is as follow:
> 
> 1. Boot a kernel C
> 
> 2. Kexec another kernel D (crash dump enabled) in kernel C. The memory
>    area used by kernel D must be a subset of memory area used by
>    kernel B.
> 

If one compiles the kernel C to boot from reserved memory area (subset
of memory area used by kernel B), then I can skip the step of kexecing
from C to D? (COFIG_PHYSICAL_START)

Alternatively, can we give hint to kernel C to run from a specified address
at run time with the help of command line parameters. What I mean boot-loader
can load the kernel at any address, but kernel will move itself to run
from a different location depending on command line parameter.  For example,
let say kernel_run_addr = 0x1000000. This parameter will tell the kernel
to move itself to 16MB address and run from there. I think it can be made
to work with little work in existing setup of relocatable kernel.

Kernel run address can be put by some user space script which will save
the hibernated image of original kernel. So after saving the /proc/vmcore,
script can modify the boot loader config file to append the right
command line to the kernel (kernel_run_addr).

After hibernation, user will shutdown/reboot. Next time the kernel boots
it will load at 16MB addr (because of kernel_run_addr) and then it can
restore the previously saved image.

We shall have to get rid of (kernel_run_addr) parameter from command
line while resuming. One can restore the image (krestore) and then edit
the boot loader config file to get rid of command line param, kernel_run_addr.

In this scheme, with the help of relocatable kernel, we can use a single
kernel for everything. (A, B, C, D). We will also avoid additional kexec
from kernel C to kernel D.

I think in the long run we shall have to work out so that a user does
not have to maintain multiple kernels. 

Does this make sense?

Thanks
Vivek
