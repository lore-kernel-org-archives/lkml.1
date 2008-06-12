Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYFLAvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYFLAvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYFLAvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:51:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:32794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYFLAvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:51:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,627,1204531200"; 
   d="scan'208";a="258708154"
Subject: Re: [PATCH -mm 2/2] kexec jump -v11: save/restore device state
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080611163026.GG6450@redhat.com>
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
	 <20080611163026.GG6450@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 12 Jun 2008 08:53:39 +0800
Message-Id: <1213232019.21353.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 12 Jun 2008 00:51:03.0756 (UTC) FILETIME=[63F010C0:01C8CC26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 12:30 -0400, Vivek Goyal wrote:
[...]
> > Usage example of simple hibernation:
> > 
> > 1. Compile and install patched kernel with following options selected:
> > 
> > CONFIG_X86_32=y
> > CONFIG_RELOCATABLE=y
> > CONFIG_KEXEC=y
> > CONFIG_CRASH_DUMP=y
> > CONFIG_PM=y
> > 
> > 2. Build an initramfs image contains kexec-tool and makedumpfile, or
> >    download the pre-built initramfs image, called rootfs.gz in
> >    following text.
> > 
> > 3. Prepare a partition to save memory image of original kernel, called
> >    hibernating partition in following text.
> > 
> > 4. Boot kernel compiled in step 1 (kernel A).
> > 
> > 5. In the kernel A, load kernel compiled in step 1 (kernel B) with
> >    /sbin/kexec. The shell command line can be as follow:
> > 
> >    /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
> >      --mem-max=0xffffff --initrd=rootfs.gz
> > 
> > 6. Boot the kernel B with following shell command line:
> > 
> >    /sbin/kexec -e
> > 
> > 7. The kernel B will boot as normal kexec. In kernel B the memory
> >    image of kernel A can be saved into hibernating partition as
> >    follow:
> > 
> >    jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
> >    echo $jump_back_entry > kexec_jump_back_entry
> >    cp /proc/vmcore dump.elf
> > 
> >    Then you can shutdown the machine as normal.
> > 
> > 8. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
> >    root file system.
> > 
> 
> One of the concerns raised by hibernation people in the past was to use
> single boot loader entry to boot normally as well while resuming a kernel.
> 
> So in this case a user either needs to maintain two boot-loader entries
> or modify it on the fly. I wished there was a better way to handle that.

﻿Now it is not needed to have two boot-loader entries, just one is
enough. Step 4 and step 8 can share the same boot-loader entries. The
rootfs.gz can be the normal initramfs or initrd when deployment. In
rootfs.gz, if there is a valid hibernation image, the hibernated system
will be restored, otherwise, normal boot process follows.


> I am more interested in ability to have multiple kernel loaded in RAM
> and capability to switch between them. Allows me to take non-disruptive
> core dumps and somebody wanted to snapshots the kernels. That should
> still work.
> 
> 
> [..]
> > --- a/arch/x86/kernel/machine_kexec_32.c
> > +++ b/arch/x86/kernel/machine_kexec_32.c
> > @@ -125,6 +125,12 @@ void machine_kexec(struct kimage *image)
> >  	/* Interrupts aren't acceptable while we reboot */
> >  	local_irq_disable();
> >  
> > +	if (image->preserve_context) {
> > +#ifdef CONFIG_X86_IO_APIC
> > +		disable_IO_APIC();
> > +#endif
> 
> I think it would be a good idea to put some kind of comment here. We
> need to put APICs in legacy mode so that we can get timer interrupts
> in second kernel. kexec/kdump paths already have calls to
> disable_IO_APIC() in one form or other. kexec jump path also needs one.

OK. I will add it.

Best Regards,
Huang Ying

