Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbYFKQeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbYFKQeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYFKQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:34:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYFKQeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:34:08 -0400
Date: Wed, 11 Jun 2008 12:30:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 2/2] kexec jump -v11: save/restore device state
Message-ID: <20080611163026.GG6450@redhat.com>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213082106.22608.30.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 03:15:06PM +0800, Huang, Ying wrote:
> This patch implements devices state save/restore before after kexec.
> 
> 
> This patch together with features in kexec_jump patch can be used for
> following:
> 
> - A simple hibernation implementation without ACPI support. You can
>   kexec a hibernating kernel, save the memory image of original system
>   and shutdown the system. When resuming, you restore the memory image
>   of original system via ordinary kexec load then jump back.
> 
> - Kernel/system debug through making system snapshot. You can make
>   system snapshot, jump back, do some thing and make another system
>   snapshot.
> 
> - Cooperative multi-kernel/system. With kexec jump, you can switch
>   between several kernels/systems quickly without boot process except
>   the first time. This appears like swap a whole kernel/system out/in.
> 
> - A general method to call program in physical mode (paging turning
>   off). This can be used to invoke BIOS code under Linux.
> 
> 
> The following user-space tools can be used with kexec jump:
> 
> - kexec-tools needs to be patched to support kexec jump. The patches
>   and the precompiled kexec can be download from the following URL:
>        source: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-src_git_kh10.tar.bz2
>        patches: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-patches_git_kh10.tar.bz2
>        binary: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec_git_kh10
> 
> - makedumpfile with patches are used as memory image saving tool, it
>   can exclude free pages from original kernel memory image file. The
>   patches and the precompiled makedumpfile can be download from the
>   following URL:
>        source: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-src_cvs_kh10.tar.bz2
>        patches: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-patches_cvs_kh10.tar.bz2
>        binary: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile_cvs_kh10
> 
> - An initramfs image can be used as the root file system of kexeced
>   kernel. An initramfs image built with "BuildRoot" can be downloaded
>   from the following URL:
>        initramfs image: http://khibernation.sourceforge.net/download/release_v10/initramfs/rootfs_cvs_kh10.gz
>   All user space tools above are included in the initramfs image.
> 
> 
> Usage example of simple hibernation:
> 
> 1. Compile and install patched kernel with following options selected:
> 
> CONFIG_X86_32=y
> CONFIG_RELOCATABLE=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PM=y
> 
> 2. Build an initramfs image contains kexec-tool and makedumpfile, or
>    download the pre-built initramfs image, called rootfs.gz in
>    following text.
> 
> 3. Prepare a partition to save memory image of original kernel, called
>    hibernating partition in following text.
> 
> 4. Boot kernel compiled in step 1 (kernel A).
> 
> 5. In the kernel A, load kernel compiled in step 1 (kernel B) with
>    /sbin/kexec. The shell command line can be as follow:
> 
>    /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
>      --mem-max=0xffffff --initrd=rootfs.gz
> 
> 6. Boot the kernel B with following shell command line:
> 
>    /sbin/kexec -e
> 
> 7. The kernel B will boot as normal kexec. In kernel B the memory
>    image of kernel A can be saved into hibernating partition as
>    follow:
> 
>    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
>    echo $jump_back_entry > kexec_jump_back_entry
>    cp /proc/vmcore dump.elf
> 
>    Then you can shutdown the machine as normal.
> 
> 8. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
>    root file system.
> 

One of the concerns raised by hibernation people in the past was to use
single boot loader entry to boot normally as well while resuming a kernel.

So in this case a user either needs to maintain two boot-loader entries
or modify it on the fly. I wished there was a better way to handle that.

I am more interested in ability to have multiple kernel loaded in RAM
and capability to switch between them. Allows me to take non-disruptive
core dumps and somebody wanted to snapshots the kernels. That should
still work.


[..]
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -125,6 +125,12 @@ void machine_kexec(struct kimage *image)
>  	/* Interrupts aren't acceptable while we reboot */
>  	local_irq_disable();
>  
> +	if (image->preserve_context) {
> +#ifdef CONFIG_X86_IO_APIC
> +		disable_IO_APIC();
> +#endif

I think it would be a good idea to put some kind of comment here. We
need to put APICs in legacy mode so that we can get timer interrupts
in second kernel. kexec/kdump paths already have calls to
disable_IO_APIC() in one form or other. kexec jump path also needs one.

Thanks
Vivek
