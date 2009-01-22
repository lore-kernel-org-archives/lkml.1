Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZAVVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZAVVYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZAVVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:24:00 -0500
Received: from mx1.suse.de ([195.135.220.2]:40732 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZAVVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:23:59 -0500
Message-ID: <4978E3D6.1090903@suse.com>
Date: Thu, 22 Jan 2009 16:23:34 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] Page table corruption from commit	9542ada803198e6eba29d3289abb39ea82047b92.
References: <49780D3D.5030406@suse.com> <20090122083149.GB7438@elte.hu>
In-Reply-To: <20090122083149.GB7438@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> * Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> Hi Suresh -
>>
>> I'm running into the following dump on one of my development nodes. I've 
>> bisected it down to commit 9542ada803198e6eba29d3289abb39ea82047b92. The 
>> SUSE hwinfo tool can reproduce this readily, at least on my system. I'd 
>> be happy to try any test fixes.
>>
>> Here's from the bisection run, 2.6.27-rc6.
> 
> Could you try the current -tip tree please?
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> There's a number of fixes in there that i think will fix your crash. In 
> particular:
> 
>   9597134: x86: fix PTE corruption issue while mapping RAM using /dev/mem

Yep. That change fixed the corruption, but I still get the other
warning. It originates with mainline commit
5899329b19100c0b82dc78e9b21ed8b920c9ffb3. I get another warning at
the bisect site, but it seems secondary. It doesn't occur in tip, though.

- -Jeff

In tip:
- ------------[ cut here ]------------
WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ipv6 af_packet fuse loop dm_mod tg3 shpchp sg ppdev i2c_amd756 i2c_amd8111 rtc_cmos rtc_core parport_pc amd_rng serio_raw pcspkr button pci_hotplug rtc_lib parport sr_mod k8temp i2c_core cdrom floppy ohci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon
Pid: 5841, comm: hwinfo Not tainted 2.6.29-rc2-tip-vanilla #19
Call Trace:
 [<ffffffff80241f6f>] warn_slowpath+0xb1/0xed
 [<ffffffff802b6bc4>] ? vm_unmap_aliases+0x175/0x185
 [<ffffffff8022be04>] ? change_page_attr_set_clr+0x13e/0x33a
 [<ffffffff804a3a40>] ? _spin_lock+0x17/0x1a
 [<ffffffff802b54c3>] ? __purge_vmap_area_lazy+0x173/0x183
 [<ffffffff8022d3dd>] reserve_pfn_range+0x5b/0x26d
 [<ffffffff8022d63a>] track_pfn_vma_new+0x4b/0xb8
 [<ffffffff802aba68>] remap_pfn_range+0xb5/0x50e
 [<ffffffff8022a8a7>] ? ioremap_change_attr+0x26/0x28
 [<ffffffff8022d9ff>] ? phys_mem_access_prot_allowed+0x100/0x1a9
 [<ffffffff802c9639>] ? __dentry_open+0x174/0x265
 [<ffffffff803cc136>] mmap_mem+0x75/0x9d
 [<ffffffff802b0d08>] mmap_region+0x2a3/0x52a
 [<ffffffff802b129c>] do_mmap_pgoff+0x30d/0x370
 [<ffffffff804a372e>] ? __down_write_nested+0x45/0xe1
 [<ffffffff8021057c>] sys_mmap+0x92/0xce
 [<ffffffff8020c42a>] system_call_fastpath+0x16/0x1b
- ---[ end trace e793dff9eb62b2bd ]---


At the bisect site:

- ------------[ cut here ]------------                                            
WARNING: at arch/x86/mm/pat.c:619 reserve_pfn_range+0x4c/0x231()                
Modules linked in: ipv6 af_packet fuse loop dm_mod ppdev sg tg3 i2c_amd8111 parport_pc sr_mod i2c_amd756 rtc_cmos shpchp amd_rng button rtc_core parport floppy i2c_core serio_raw cdrom pcspkr rtc_lib k8temp pci_hotplug ohci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon                                        
Pid: 5642, comm: hwinfo Not tainted 2.6.28-rc8-vanilla #44                      
Call Trace:                                                                     
 [<ffffffff802425e6>] warn_on_slowpath+0x58/0x7d                                
 [<ffffffff8022c8c0>] ? change_page_attr_set_clr+0x136/0x32e                    
 [<ffffffff804916ed>] ? _spin_lock+0x17/0x1a                                    
 [<ffffffff802ae099>] ? __purge_vmap_area_lazy+0x171/0x181                      
 [<ffffffff8022b269>] ? pagerange_is_ram+0x31/0x5c                              
 [<ffffffff8022de48>] reserve_pfn_range+0x4c/0x231                              
 [<ffffffff8022e076>] track_pfn_vma_new+0x49/0xb3                               
 [<ffffffff802a4741>] remap_pfn_range+0xa4/0x4dc                                
 [<ffffffff8022cbe5>] ? _set_memory_wb+0x22/0x24                                
 [<ffffffff8022b3b8>] ? ioremap_change_attr+0x26/0x28                           
 [<ffffffff8022e4cb>] ? phys_mem_access_prot_allowed+0x100/0x1a9                
 [<ffffffff803c2804>] mmap_mem+0x75/0x9d                                        
 [<ffffffff802a988f>] mmap_region+0x297/0x506                                   
 [<ffffffff802a9e0b>] do_mmap_pgoff+0x30d/0x370                                 
 [<ffffffff804913e7>] ? __down_write_nested+0x45/0xdc                           
 [<ffffffff80211108>] sys_mmap+0x92/0xce                                        
 [<ffffffff8020c2ca>] system_call_fastpath+0x16/0x1b                            
- ---[ end trace a2d1666c2f766ad5 ]---                                            
- ------------[ cut here ]------------                                            
WARNING: at arch/x86/mm/pageattr.c:560 __change_page_attr_set_clr+0x10b/0xc0c() 
CPA: called for zero pte. vaddr = ffff8800f7ff0000 cpa->vaddr = ffff8800f7ff0000
Modules linked in: ipv6 af_packet fuse loop dm_mod ppdev sg tg3 i2c_amd8111 parport_pc sr_mod i2c_amd756 rtc_cmos shpchp amd_rng button rtc_core parport floppy i2c_core serio_raw cdrom pcspkr rtc_lib k8temp pci_hotplug ohci_hcd sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic pata_amd sata_sil libata scsi_mod thermal processor thermal_sys hwmon                                        
Pid: 5645, comm: acpidump Tainted: G        W  2.6.28-rc8-vanilla #44
Call Trace:
 [<ffffffff80242567>] warn_slowpath+0x8c/0xb3
 [<ffffffff8029e248>] ? zone_statistics+0x62/0x67
 [<ffffffff8022bb1b>] ? lookup_address+0x1dd/0x209
 [<ffffffff8029e248>] ? zone_statistics+0x62/0x67
 [<ffffffff8029679b>] ? get_page_from_freelist+0x4e4/0x69e
 [<ffffffff8029e248>] ? zone_statistics+0x62/0x67
 [<ffffffff8029679b>] ? get_page_from_freelist+0x4e4/0x69e
 [<ffffffff8022bc89>] __change_page_attr_set_clr+0x10b/0xc0c
 [<ffffffff80290acb>] ? find_lock_page+0x1e/0x5c
 [<ffffffff8022bb1b>] ? lookup_address+0x1dd/0x209
 [<ffffffff802910e8>] ? filemap_fault+0x1c4/0x31b
 [<ffffffff80290aa9>] ? unlock_page+0x22/0x26
 [<ffffffff802a1013>] ? __do_fault+0x46e/0x4b4
 [<ffffffff804916ed>] ? _spin_lock+0x17/0x1a
 [<ffffffff802ae099>] ? __purge_vmap_area_lazy+0x171/0x181
 [<ffffffff802af79c>] ? vm_unmap_aliases+0x172/0x182
 [<ffffffff8022c8c0>] change_page_attr_set_clr+0x136/0x32e
 [<ffffffff8022b269>] ? pagerange_is_ram+0x31/0x5c
 [<ffffffff8022ccf0>] _set_memory_uc+0x22/0x24
 [<ffffffff8022b3aa>] ioremap_change_attr+0x18/0x28
 [<ffffffff8022df9b>] reserve_pfn_range+0x19f/0x231
 [<ffffffff8022e076>] track_pfn_vma_new+0x49/0xb3
 [<ffffffff802a4741>] remap_pfn_range+0xa4/0x4dc
 [<ffffffff804916ed>] ? _spin_lock+0x17/0x1a
 [<ffffffff8022dcdc>] ? reserve_memtype+0x3e1/0x501
 [<ffffffff8022e480>] ? phys_mem_access_prot_allowed+0xb5/0x1a9
 [<ffffffff803c2804>] mmap_mem+0x75/0x9d
 [<ffffffff802a988f>] mmap_region+0x297/0x506
 [<ffffffff802a9e0b>] do_mmap_pgoff+0x30d/0x370
 [<ffffffff804913e7>] ? __down_write_nested+0x45/0xdc
 [<ffffffff80211108>] sys_mmap+0x92/0xce
 [<ffffffff8020c2ca>] system_call_fastpath+0x16/0x1b
- ---[ end trace a2d1666c2f766ad5 ]---
acpidump:5645 reserve_pfn_range ioremap_change_attr failed uncached-minus for f7ff0000-f7ff1000

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl449YACgkQLPWxlyuTD7JZcwCeL9b6Rqvz5otheyDjLvFi/lPf
E78An20tdqum1+G80ZzTqs7baRDbyhTL
=J7ag
-----END PGP SIGNATURE-----
