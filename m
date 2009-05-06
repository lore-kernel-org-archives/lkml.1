Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZEFCAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZEFCAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZEFCAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:06 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57439 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbZEFCAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:05 -0400
Message-ID: <4A00EF23.4050302@snapgear.com>
Date: Wed, 06 May 2009 12:00:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
References: <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com>
In-Reply-To: <3662.1241530861@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Howells wrote:
> Greg Ungerer <gerg@snapgear.com> wrote:
> 
>> BUG: failure at mm/nommu.c:518/add_nommu_region()!
> 
> Can you find out some more information about the region in question, perhaps
> with the attached patch?

Yep, last part of the boot log now:

...
uclinux[mtd]: RAM probe address=0x168fc0 size=0xd7000
Creating 1 MTD partitions on "RAM":
0x000000000000-0x0000000d7000 : "ROMfs"
TCP cubic registered
NET: Registered protocol family 17
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
Freeing unused kernel memory: 44k freed (0x152000 - 0x15c000)
___ REGION ERROR ___
18b790-191db0
fs=romfs file=init
BUG: failure at mm/nommu.c:532/add_nommu_region()!
Kernel panic - not syncing: BUG!


> Also if you can check to see whether the region is within the ROMFS image.

Yes, it is. As per the uclinux/mtd trace output (at top of trace
above). The start physical address of the ROMFS is 0x168fc0, and
it will end at 0x23ffc0.

Regards
Greg




> David
> ---
> diff --git a/mm/nommu.c b/mm/nommu.c
> index cdc6f60..ba9e230 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -515,7 +515,18 @@ static void add_nommu_region(struct vm_region *region)
>  
>  	validate_nommu_regions();
>  
> -	BUG_ON(region->vm_start & ~PAGE_MASK);
> +	if (region->vm_start & ~PAGE_MASK) {
> +		printk(KERN_ERR "___ REGION ERROR ___\n");
> +		printk(KERN_ERR "%lx-%lx\n", region->vm_start, region->vm_end);
> +		printk(KERN_ERR "fs=%s file=%s\n",
> +		       region->vm_file ?
> +		       region->vm_file->f_path.dentry->d_inode->i_sb->s_type->name :
> +		       "*anon*",
> +		       region->vm_file ?
> +		       region->vm_file->f_path.dentry->d_name.name :
> +		       (const unsigned char *) "*anon*");
> +		BUG();
> +	}
>  
>  	parent = NULL;
>  	p = &nommu_region_tree.rb_node;
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
