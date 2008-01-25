Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYAYSxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYAYSxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYAYSxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:53:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:46475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbYAYSxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:53:42 -0500
Date: Fri, 25 Jan 2008 10:52:13 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125185213.GA23475@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 10:44:59AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 24 Jan 2008, Greg KH wrote:
> > 
> > Here are a pretty large number of kobject, documentation, and driver
> > core patches against your 2.6.24 git tree.
> 
> I've merged it all, but it causes lots of scary warnings:
> 
>  - from the purely broken ones:
> 
> 	ehci_hcd: no version for "struct_module" found: kernel tainted.
> 
>  - to the scary ones:
> 
> 	sysfs: duplicate filename 'ehci_hcd' can not be created
> 	WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> 	Pid: 610, comm: insmod Tainted: GF       2.6.24-gb47711bf #28
> 	
> 	Call Trace:
> 	 [<ffffffff802bd63c>] sysfs_add_one+0x54/0xbd
> 	 [<ffffffff802bdbc0>] create_dir+0x4f/0x87
> 	 [<ffffffff802bdc2d>] sysfs_create_dir+0x35/0x4a
> 	 [<ffffffff803154c8>] kobject_get+0x12/0x17
> 	 [<ffffffff80315607>] kobject_add_internal+0xd9/0x194
> 	 [<ffffffff8031579c>] kobject_add_varg+0x54/0x61
> 	 [<ffffffff80261efe>] __alloc_pages+0x66/0x2ee
> 	 [<ffffffff80315321>] kobject_init+0x42/0x82
> 	 [<ffffffff80315843>] kobject_init_and_add+0x9a/0xa7
> 	 [<ffffffff802722c0>] __vmalloc_area_node+0x111/0x135
> 	 [<ffffffff8025546b>] mod_sysfs_init+0x6e/0x83
> 	 [<ffffffff802561e8>] sys_init_module+0xa3d/0x1833
> 	 [<ffffffff8028ebd5>] dput+0x1c/0x10b
> 	 [<ffffffff8020b3be>] system_call+0x7e/0x83
> 
> and the problem seems to be that it does all these checks even for modules 
> that will never be loaded, because I use my own kernel, but with the 
> default Fedora initrd (which is trying to load modules for stuff that I 
> already have built in).
> 
> Very annoying.

That's really wierd, I don't see that at all here just running with your
2.6.24 + my git tree and lots of USB drivers built into the kernel also
(like ehci_hcd).

I'll try to reproduce it on your merged git tree now...

> Can we please do that *after* the module loading symbol checks have run, 
> so that when you try to load a module that will not load, it won't 
> complain about these silly things?
> 
> (You can probably trigger this by simply trying to load a module that was 
> compiled for another kernel version - it will fail fine, but in failing it 
> will then generate all these incorrect warnings!)
> 
> Now it incorrectly taints my kernel, for no good reason.

$ cat /proc/sys/kernel/tainted
0

Odd...

$ uname -r
2.6.24-ge374a2bf-dirty

Strange, I thought that the uname id would show the git version that you
were running, but that doesn't show a valid id.  But that's probably a
different issue in the build system somewhere...

thanks,

greg k-h
