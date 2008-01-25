Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYAYSpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYAYSpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYAYSpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:45:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbYAYSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:45:06 -0500
Date: Fri, 25 Jan 2008 10:44:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: <20080125071127.GA4860@kroah.com>
Message-ID: <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jan 2008, Greg KH wrote:
> 
> Here are a pretty large number of kobject, documentation, and driver
> core patches against your 2.6.24 git tree.

I've merged it all, but it causes lots of scary warnings:

 - from the purely broken ones:

	ehci_hcd: no version for "struct_module" found: kernel tainted.

 - to the scary ones:

	sysfs: duplicate filename 'ehci_hcd' can not be created
	WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
	Pid: 610, comm: insmod Tainted: GF       2.6.24-gb47711bf #28
	
	Call Trace:
	 [<ffffffff802bd63c>] sysfs_add_one+0x54/0xbd
	 [<ffffffff802bdbc0>] create_dir+0x4f/0x87
	 [<ffffffff802bdc2d>] sysfs_create_dir+0x35/0x4a
	 [<ffffffff803154c8>] kobject_get+0x12/0x17
	 [<ffffffff80315607>] kobject_add_internal+0xd9/0x194
	 [<ffffffff8031579c>] kobject_add_varg+0x54/0x61
	 [<ffffffff80261efe>] __alloc_pages+0x66/0x2ee
	 [<ffffffff80315321>] kobject_init+0x42/0x82
	 [<ffffffff80315843>] kobject_init_and_add+0x9a/0xa7
	 [<ffffffff802722c0>] __vmalloc_area_node+0x111/0x135
	 [<ffffffff8025546b>] mod_sysfs_init+0x6e/0x83
	 [<ffffffff802561e8>] sys_init_module+0xa3d/0x1833
	 [<ffffffff8028ebd5>] dput+0x1c/0x10b
	 [<ffffffff8020b3be>] system_call+0x7e/0x83

and the problem seems to be that it does all these checks even for modules 
that will never be loaded, because I use my own kernel, but with the 
default Fedora initrd (which is trying to load modules for stuff that I 
already have built in).

Very annoying.

Can we please do that *after* the module loading symbol checks have run, 
so that when you try to load a module that will not load, it won't 
complain about these silly things?

(You can probably trigger this by simply trying to load a module that was 
compiled for another kernel version - it will fail fine, but in failing it 
will then generate all these incorrect warnings!)

Now it incorrectly taints my kernel, for no good reason.

		Linus
