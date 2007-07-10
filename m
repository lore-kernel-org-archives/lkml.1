Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbXGJNUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbXGJNUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXGJNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:20:35 -0400
Received: from mail.suse.de ([195.135.220.2]:51386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbXGJNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:20:33 -0400
Date: Tue, 10 Jul 2007 15:20:31 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710132031.GE22862@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain> <20070709204938.GA21663@suse.de> <20070710044546.GA2240@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710044546.GA2240@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Dan Aloni <da-x@monatomic.org> [2007-07-10 06:45]:
> > > 
> > > Not exactly. Let me describe the procedure in greater detail.
> > > Basically, it would go like this:
> > > 
> > > 1. <normal bootloader boot>
> > > 2. <normal initramfs>
> > > 3. embed_configfile /proc/kcore.info /vmlinux-kdump
> > > 4. kexec -l vmlinux-kdump <....>
> > > 5. <boot continues>
> > > 6. <crash>
> > > 7. <kdump kernel boot>
> > > 8. <kdump initramfs runs>
> > > 9. makedumpfile -i /proc/vmcore.info <....>
> > 
> > I don't see why an additional tool would be needed here. kexec already
> > modifies symbols, so why not adding the functionality into kexec? The
> > advantage would be that there's no on-disk modification necessary.
> 
> Actually, 'embed_configfile /proc/kcore.info /vmlinux-kdump' makes
> no on-disk modification, since it is all contained in initramfs (we
> step out of initramfs in stage 5). 

Well, that assumes that you load the kdump kernel in the initrd of the
normal kernel. That's not always the case. For example, in SUSE the
kdump kernel is loaded as init script in the normal boot process.
Also, e.g. when testing, you may load the kdump kernel again. So you
would always need to copy the kdump kernel, modify it with
embed_configfile and then run kexec.

I think extending kexec to perform this task is more user friendly.

> BTW another option would be containing the whole CONFIGFILE as a 
> vmlinux-specific ELF note, to be easily read from /proc/vmcore.
> You'd still need some util like embed_configfile at build time 
> in order to integrate it, and you'd also need to modify 
> makedumpfile so it can use it. Actually this sounds quite better
> to me. I'll try to prepare patches both for makedumpfile and the 
> kernel and see how easy it is.

Well, in our kernel RPMs there's also a CONFIGFILE which can be
located on disk based on the version. (If a user builds the kernel
manually, then he probably builds it with -g anyway because if he
doesn't, he cannot run makedumpfile.)

The inclusion of the CONFIGFILE can be done by kexec when loading the
kdump kernel, either from a file or from the compiled-in
/proc/kcore.info file. I don't see a reason why a tool should modify
the vmlinux file for kdump on-disk.  Actually, I like the idea of
including a ELF note that contains CONFIGFILE.

Currently, we still have another problem: On x86_64, if the kernel is
relocatable, we only can use bzImage, not vmlinux kexec because of a
GDB bug that doesn't get attention by the GDB developers although I
found out the patch that broke GDB in that way ... But: That would
require that embed_configfile must also be able to modify bzImage
which is very problematic. Adding a ELF in kexec that could be read in
the /proc/vmcore hasn't that problem.



Thanks,
   Bernhard
