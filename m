Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXGJEqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXGJEqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXGJEqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:46:05 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:45220 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXGJEqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:46:04 -0400
Date: Tue, 10 Jul 2007 07:45:46 +0300
From: Dan Aloni <da-x@monatomic.org>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, nhorman@redhat.com, bwalle@suse.de
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710044546.GA2240@localdomain>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain> <20070709204938.GA21663@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709204938.GA21663@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 10:49:38PM +0200, Bernhard Walle wrote:
> Hi,
> 
> * Dan Aloni <da-x@monatomic.org> [2007-07-09 13:41]:
> > > > A patch that I am working on will make it possible to integrate
> > > > the output of 'makedumpinfo -g' into vmlinux as the final build
> > > > stage of the kernel. This information will be presented itself
> > > > as /proc/kcore.info for the first kernel throughout its entire
> > > > execution.
> > > 
> > > That sounds good. But I doubt that kernel developers like the idea of
> > > needing another utility in the build process ...
> > 
> > I don't think it would add much complexity to build process as it 
> > is now, just like the other tools that transparently do post-linking 
> > modifications. As far as the developer is concerned, there's just
> > the vmlinux and/or bzImage files that get emitted at the end.
> 
> I didn't complain about the complexity but about the requirement of an
> additional tool. However, I think it will be configurable.

Yes, I suppose it should be.
 
> > > > Then inside initramfs of the first kernel, a small 
> > > > util will modify the vmlinux file of the kdump kernel before it
> > > > gets loaded so that another special file appearing as 
> > > > /proc/vmcore.info under the kdump kernel will present the same
> > > > info. 
> > > 
> > > Where do you get the info from? If you're in the kdump initrd,
> > > then the kdump kernel is already loaded. Do you want to attach the
> > > info from the crashed kernel to the initrd of the kdump kernel?
> > 
> > Not exactly. Let me describe the procedure in greater detail.
> > Basically, it would go like this:
> > 
> > 1. <normal bootloader boot>
> > 2. <normal initramfs>
> > 3. embed_configfile /proc/kcore.info /vmlinux-kdump
> > 4. kexec -l vmlinux-kdump <....>
> > 5. <boot continues>
> > 6. <crash>
> > 7. <kdump kernel boot>
> > 8. <kdump initramfs runs>
> > 9. makedumpfile -i /proc/vmcore.info <....>
> 
> I don't see why an additional tool would be needed here. kexec already
> modifies symbols, so why not adding the functionality into kexec? The
> advantage would be that there's no on-disk modification necessary.

Actually, 'embed_configfile /proc/kcore.info /vmlinux-kdump' makes
no on-disk modification, since it is all contained in initramfs (we
step out of initramfs in stage 5). 

BTW another option would be containing the whole CONFIGFILE as a 
vmlinux-specific ELF note, to be easily read from /proc/vmcore.
You'd still need some util like embed_configfile at build time 
in order to integrate it, and you'd also need to modify 
makedumpfile so it can use it. Actually this sounds quite better
to me. I'll try to prepare patches both for makedumpfile and the 
kernel and see how easy it is.

> Another issue: Some parameters of makedumpfile (currently the page
> size) are read from the running system. If you build the configuration
> file while building the kernel, you always have the .config which
> contains the page size. So it would be possible to extend the
> makedumpfile utility to read that parts from a .config, and that would
> remove a dependency that page size of the running kernel matches the
> page size of the building kernel. On IA64, that's not always the case.

That needs to be changed.. the part in makedumpfile that generates 
the CONFIGFILE shouldn't depend on the running kernel at all. As 
Ken'ichi suggests we don't need to have 'OSRELEASE=' in the 
CONFIGFILE (instead, peeking inside init_uts_ns from /proc/vmcore
is enough). For PAGESIZE, it can be replaced by readmem() of some
variable such as:

         unsigned int image_page_size = PAGE_SIZE;

With the system I propose for generation and delivery of the 
CONFIGFILE, it would be impossible to pass an incorrect CONFIGFILE
since the kernel will already contain its own CONFIGFILE generated
during build time (assuming it didn't get corrupted in the crash,
it's quite far-fetched...).

> > BTW I think there could be a confusion between makedumpfile's 
> > CONFIGFILE and the .config file, so we should pick a different 
> > name for it...
> 
> Aggreed. Your suggestion? :)

Ken'ichi's "mkdfinfo" works for me.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
