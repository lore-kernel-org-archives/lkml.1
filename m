Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbXGJGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbXGJGsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXGJGsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:48:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35735 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbXGJGsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:48:07 -0400
Date: Tue, 10 Jul 2007 12:18:17 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Dan Aloni <da-x@monatomic.org>, Neil Horman <nhorman@redhat.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710064817.GC5471@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706145804.GA31409@localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> > Hello,
> > 
> > does anybody know a _reliable_ way to determine the version the kernel
> > that produced a vmcore file? This means not scanning for a specific
> > string or something like that which can fail on random memory.
> > 
> > Would it make sense to add a ELF PT_NOTE section in the vmcore?
> > 
> > Thanks for input!
> 
> (I'm sorry if this E-Mail needlessly turned into a long RFC 
> but I had to bring this up when I bumped into this question on 
> LKML)
> 
> Actually, instead of another ELF PT_NOTE section for this 
> information and other things, kdump is currently going into 
> another direction, described below.
> 
> Redhat has a makedumpinfo util which they intend to use as slim
> kernel-version-independent utility on kdump rootfs in order to
> save /proc/vmcore in a compact manner.
> 
> Normally makedumpinfo would require access to the vmlinux file 
> that the crashed kernel was originated from. However instead of 
> depending on vmlinux, it is possible to generate a small textual
> "CONFIGFILE" that looks like this, for example (generated using
> makedumpinfo -g):
> 
> OSRELEASE=2.6.20.3
> PAGESIZE=4096
> SYMBOL(mem_map)=ffffffff806cf5d8
> SYMBOL(init_uts_ns)=ffffffff805f8be0
> SYMBOL(_stext)=ffffffff80200f20
> SYMBOL(node_online_map)=ffffffff80651bc0
> SYMBOL(contig_page_data)=ffffffff80600e80
> SIZE(page)=56
> SIZE(pglist_data)=3712
> SIZE(zone)=1152
> SIZE(free_area)=24
> SIZE(list_head)=16
> OFFSET(page.flags)=0
> OFFSET(page._count)=8
> OFFSET(page.mapping)=24
> OFFSET(page.lru)=40
> OFFSET(pglist_data.node_zones)=0
> OFFSET(pglist_data.nr_zones)=3576
> OFFSET(pglist_data.node_mem_map)=3584
> OFFSET(pglist_data.node_start_pfn)=3600
> OFFSET(pglist_data.node_spanned_pages)=3616
> OFFSET(zone.free_pages)=0
> OFFSET(zone.free_area)=408
> OFFSET(zone.vm_stat)=872
> OFFSET(zone.spanned_pages)=1064
> OFFSET(free_area.free_list)=0
> OFFSET(list_head.next)=0
> OFFSET(list_head.prev)=8
> LENGTH(zone.free_area)=11
> SRCFILE(pud_t)=include/asm/page.h
> 
> It contains enough information in order to make a compact kernel
> dump (makedumpinfo needs to go over the struct page arrays). As
> you see, it also contains the kernel version.
> 

But this will not solve Bernhard's problem where looking at a vmcore
he wants to know which vmlinux (kernel version with time stamp) has
generated this vmcore. So adding a ELF NOTE should help.

> However, this file needs to be passed somehow to the rootfs
> of the kdump kernel. This poses a chicken-and-egg problem on 
> my setup where the initramfs of the first kernel contains 
> a staticlu linked version of the kexec executable along with a
> kdump kernel to be loaded before mount rootfs and running 
> init. 
> 

Why are you loading kdump kernel from first kernel's initramfs?
I guess to enable the dump capture as soon as possible so if some
driver panics() you can capture the dump?

Can't we modify the initramfs generation process (mkinitrd) to take
care of this situation?. By the way, how is second kernel's initramfs
is generated currently? The moment we start packing a file which contains
the debuginfo for first kernel, initramfs of second kernel becomes dependent
on first kernel and to me its not a good approach.

A dump kernel and its initrd should be independent of the crashing kernel.

Neil/Keni'chi, how is this taken care in current RHEL5 build? Is second
kernel's initramfs dependent on first kernel if one is doing filtering
in second kernel from initramfs?

Thanks
Vivek
