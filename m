Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbXH0GSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbXH0GSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 02:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXH0GR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 02:17:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:28811 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbXH0GR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 02:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,310,1183359600"; 
   d="scan'208";a="288604066"
Subject: Re: [RFC][PATCH 0/2 -mm] kexec based hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: vgoyal@in.ibm.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070827050027.GB9809@in.ibm.com>
References: <1188177245.3247.36.camel@caritas-dev.intel.com>
	 <20070827050027.GB9809@in.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Aug 2007 14:18:49 +0800
Message-Id: <1188195529.3247.82.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 27 Aug 2007 06:17:52.0772 (UTC) FILETIME=[0006F440:01C7E872]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 10:30 +0530, Vivek Goyal wrote:
> On Mon, Aug 27, 2007 at 09:14:05AM +0800, Huang, Ying wrote:
> > Kexec base hibernation has some potential advantages over uswsusp and
> > TuxOnIce (suspend2). Some most obvious advantages are:
> > 
> > 1. The hibernation image size can exceed half of memory size easily.
> > 
> > 2. The hibernation image can be written to and read from almost
> >    anywhere, such as USB disk, NFS.
> > 
> > 3. It is possible to eliminate freezer from kexec based hibernation
> >    implementation.
> > 
> > 4. Based on kexec/kdump implementation, the kernel code needed is
> >    less.
> > 
> > 
> > This patch set implements a prototype of kexec based hibernation. The
> > kernel functionalities added are as follow:
> > 
> > 1. Jumping from kexeced kernel back to original kernel. This is used
> >    by hibernation to save/load necessary state in original kernel and
> >    jumping back to original kernel after restore the memory of
> >    original kernel.
> > 
> > 2. Add writing support to /dev/oldmem. This is used by hibernation to
> >    restore the memory of original kernel.
> > 
> > 
> > The hibernation process with the patch set is as follow:
> > 
> > 1. Boot a kernel A
> > 
> > 2. Work under kernel A
> > 
> > 3. Kexec another kernel B (crash dump enabled) in kernel A.
> > 
> > 4. Save the memory image of kernel A through crash dump (such as "cp
> >    /proc/vmcore ~"). Save the "jump buffer pfn".
> > 
> > 5. Shutdown or reboot
> > 
> > 
> > The restore process with the patch set is as follow:
> > 
> > 1. Boot a kernel C
> > 
> > 2. Kexec another kernel D (crash dump enabled) in kernel C. The memory
> >    area used by kernel D must be a subset of memory area used by
> >    kernel B.
> > 
> 
> If one compiles the kernel C to boot from reserved memory area (subset
> of memory area used by kernel B), then I can skip the step of kexecing
> from C to D? (COFIG_PHYSICAL_START)

Yes. I think so.

> Alternatively, can we give hint to kernel C to run from a specified address
> at run time with the help of command line parameters. What I mean boot-loader
> can load the kernel at any address, but kernel will move itself to run
> from a different location depending on command line parameter.  For example,
> let say kernel_run_addr = 0x1000000. This parameter will tell the kernel
> to move itself to 16MB address and run from there. I think it can be made
> to work with little work in existing setup of relocatable kernel.
> 
> Kernel run address can be put by some user space script which will save
> the hibernated image of original kernel. So after saving the /proc/vmcore,
> script can modify the boot loader config file to append the right
> command line to the kernel (kernel_run_addr).
> 
> After hibernation, user will shutdown/reboot. Next time the kernel boots
> it will load at 16MB addr (because of kernel_run_addr) and then it can
> restore the previously saved image.
> 
> We shall have to get rid of (kernel_run_addr) parameter from command
> line while resuming. One can restore the image (krestore) and then edit
> the boot loader config file to get rid of command line param, kernel_run_addr.
> 
> In this scheme, with the help of relocatable kernel, we can use a single
> kernel for everything. (A, B, C, D). We will also avoid additional kexec
> from kernel C to kernel D.
> 
> I think in the long run we shall have to work out so that a user does
> not have to maintain multiple kernels. 

Only one relocatable kernel image is needed. In fact, I use one
relocatable kernel image in testing during development.

> Does this make sense?

Yes, this is a sensible optimization. But I think it may be better to
make bootloader load kernel D directly into a specified memory location.
For example, we can add a option to "kernel" command of grub. 

And, I think we can do more in bootloader. Such as we can prepare two
kernel command line for one grub menu item, one for normal kernel, the
other for restore kernel. After hibernating successfully, the effective
kernel command line is switched.

Best Regards,
Huang Ying
