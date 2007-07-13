Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXGMFIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXGMFIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXGMFIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:08:39 -0400
Received: from [212.12.190.87] ([212.12.190.87]:32858 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751541AbXGMFIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:08:38 -0400
From: Al Boldi <a1426z@gawab.com>
To: ying.huang@intel.com
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
Date: Fri, 13 Jul 2007 08:08:31 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707130808.31109.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>
> Kexec jump - The first step to kexec base hibernation

Thanks a lot!

> Kexec base hibernation has some potential advantages over uswsusp and
> suspend2. Some most obvious advantages are:
>
> 1. The hibernation image size can exceed half of memory size easily.
> 2. The hibernation image can be written to and read from almost
>    anywhere, such as USB disk, NFS.
>
> This patch implements the functionality of "jumping from kexeced
> kernel to original kernel". That is, the following sequence is
> possible:
>
> 1. Boot a kernel A
> 2. Work under kernel A
> 3. Kexec another kernel B in kernel A
> 4. Work under kernel B
> 5. Jump from kernel B to kernel A
> 6. Continue work under kernel A

Great!

> This is the first step to implement kexec based hibernation. If the
> memory image of kernel A is written to or read from a permanent media
> in step 4, a preliminary version of kexec based hibernation can be
> implemented.

Sounds easy.

> The kernel B is run as a crashdump kernel in reserved memory
> region. This is the biggest constrains of the patch. It is planed to
> be eliminated in the next version. That is, instead of reserving memory
> region previously, the needed memory region is backuped before kexec
> and restored after jumping back.

Actually, backing up from within the normal kernel may produce 
inter-dependency deadlocks.  It's much better to just force-free some memory 
chunk out to swap.

> Another constrains of the patch is that the CONFIG_ACPI must be turned
> off to make kexec jump work. Because ACPI will put devices into low
> power state, the kexeced kernel can not be booted properly under
> it. This constrains can be eliminated by separating the suspend method
> and hibernation method of the devices as proposed earlier in the LKML.
>
> The kexec jump is implemented in the framework of software suspend. In
> fact, the kexec based hibernation can be seen as just implementing the
> image writing and reading method of software suspend with a kexeced
> Linux kernel.
>
> Now, only the i386 architecture is supported. The patch is based on
> Linux kernel 2.6.22, and has been tested on my IBM T42.
>
> Usage:
>
> 1. Compile kernel with following options selected:
>
> CONFIG_X86_32=y
> CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with
> it CONFIG_KEXEC=y
> CONFIG_SOFTWARE_SUSPEND=y
> CONFIG_KEXEC_HIBERNATION=y

What about CONFIG_CRASH_DUMP=y ?
Also CONFIG_PHYSICAL_START=1000000 (=16M instead of default 1M).

> 2. Compile the kexec-tools with kdump and kjump patches added, the
>    kdump patch can be found at:
>
> http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-kdump10.patch
>
>    While, the kexec-tools kjump patch is appended with the mail.
>
> 3. Boot compiled kernel, the reserved crash kernel memory region must
>    be added to kernel command line as following:
>
>    crashkernel=<XX>M@<XX>M
>
>    Where, <XX> should be replaced by the real memory size and position.

Ok, booted with crashkernel=16M@16M.

> 4. Switch hibernation image operations, through shell command as follow:
>
>    echo kexec > /sys/power/hibernation_image_ops

Ok.

> 5. Boot the kexeced kernel as a crashdump kernel, the same kernel can
>    be used if CONFIG_RELOCATABLE=y is selected. The kernel command
>    line option as following must be appended to kernel command line.
>
>    kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`

You mean like:
# kexec -p vmlinux 
        --args-linux 
        --append="root=/dev/sda1 
                  kexec_jump_buf_pfn = `cat /sys/kernel/kexec_jump_buf_pfn`"

# cat c > /proc/sysrq

This loads ok.

> 6. In the kexec booted kernel, switch hibernation image operations, as
>    in 4.

Ok.

> 7. In the kexec booted kernel, trigger the jumping back with following
>    shell command.
>
>    echo <a>:<b> > /sys/power/resume
>
>    Where <a> and <b> is non-negative integer, at least one of them must
>    be non-zero.

This doesn't switch it, but rather reboots my machine.


Thanks!

--
Al

