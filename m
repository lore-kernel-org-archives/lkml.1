Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYCKVMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYCKVMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYCKVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:11:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYCKVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:11:44 -0400
Date: Tue, 11 Mar 2008 17:10:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080311211004.GA30164@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204773188.4707.109.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:13:08AM +0800, Huang, Ying wrote:
> This is a minimal patch with only the essential features. All
> additional features are split out and can be discussed later. I think
> it may be easier to get consensus on this minimal patch.
> 

Hi Huang,

This patchset is slowly getting better. True that first we need to come
up with minimal infrastructure patch and then think of building more
functionality on top of it.


> This patch provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Jumping between the original kernel and the kexeced kernel.
> 
> - Backup/restore memory used by both the original kernel and the
>   kexeced kernel.
> 
> - Save/restore CPU and devices state before after kexec.
> 
> 
> The features of this patch can be used for as follow:
> 
> - A simple hibernation implementation without ACPI support. You can
>   kexec a hibernating kernel, save the memory image of original system
>   and shutdown the system. When resuming, you restore the memory image
>   of original system via ordinary kexec load then jump back.
> 

The main usage of this functionality is for hibernation. I am not sure
what has been the conclusion of previous discussions.

Rafael/Pavel, does the approach of doing hibernation using a separate
kernel holds promise?

[..]
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
> 3. Boot kernel compiled in step 1 (kernel A).
> 
> 4. In the kernel A, load kernel compiled in step 1 (kernel B) with
>    /sbin/kexec. The shell command line can be as follow:
> 
>    /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
>      --mem-max=0xffffff --initrd=rootfs.gz
> 
> 5. Boot the kernel B with following shell command line:
> 
>    /sbin/kexec -e
> 
> 6. The kernel B will boot as normal kexec. In kernel B the memory
>    image of kernel A can be saved into hibernating partition as
>    follow:
> 
>    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
>    echo $jump_back_entry > kexec_jump_back_entry
>    cp /proc/vmcore dump.elf
> 

Why not store the entry point in dump.elf itself, instead of storing it
in a separate file?

I think this is more like a resumable core file. Something similar to
functionality what qemu does for resuming an already booted kernel image.
So we might have to introduce an ELF_NOTE to mark an image as resumable
core. 

>    Then you can shutdown the machine as normal.
> 
> 7. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
>    root file system.
> 
> 8. In kernel C, load the memory image of kernel A as follow:
> 
>    /sbin/kexec -l --args-none --entry=`cat kexec_jump_back_entry` dump.elf
> 

How the memory segments of dump.elf loaded? Normal kexec way? Memory
segments of dump.elf are first stored somewhere and then moved to
destination at "kexec -e" time?

Does this really work? If we have 4G RAM, what will be the size of
dump.elf? And when we load it back for resuming, do we have sufficient
memory left?

May be we can have a separate load flag (--load-resume-image) to mark
that we are resuming an hibernated image and kexec does not have to
prepare commandline, does not have to prepare zero page/setup page etc.


I have thought through it again and try to put together some of the
new kexec options we can introduce to make the whole thing work. I am 
considering a simple case where a user boots the kernel A and then
launches kernel B using "kexec --load-preseve-context". Now a user
might save the hibernated image or might want to come back to A.

- kexec -l <kernel-image>
        Normal kexec functionality. Boot a new kernel, without preserving
        existing kernel's context.

- kexec --load-preserve-context <kernel-image>
        Boot a new kernel while preserving existing kernel's context.

        Will be used for booting kernel B for the first time.

- kexec --load-resume-image <resumable-core>
        Resumes an hibernated image. Load a ELF64 hibernated image.

	Context of first kernel/boot-loader will not be preserved.

	First kernel will not save cpu states. Will put devices into
	suspended state though so that these can be resumed by resumable
	core

        This option can be used by kboot or kernel C to resume an hibernated
	image.

- kexec --load-resume-entry <entry-point>
        Image is already loaded. Just prepare the entry point so that one
        can enter back to previous image. cpu states will be saved and devices
        will be put to suspended states.

        will be used for A --> B and B ---> A transitions. Both A and B are
        booted. This is just for switching back and forth between A and B.

- kexec -e
        Transition into the new kernel

This patch looks in pretty decent shape. Once there is some sort of
understanding that this approach is promising for hibernation and we
have consensus on high level interface, then we can get into line by 
line review of the patch set. 

Thanks
Vivek
