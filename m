Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXEYFHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXEYFHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXEYFHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:07:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbXEYFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:07:24 -0400
Date: Thu, 24 May 2007 22:07:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: young dave <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
In-Reply-To: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, young dave wrote:

> I can't call it oops, right?

Yes sure. This is a problem in the NTFS layer. It writes 2 bytes
after the allocated size.

> I navagated the ntfs inode.c, and found a possible bug, replaced
> kmalloc with kzalloc,
> because the ntfschar size is 2.  then the kernel doesn't warning
> again. and the slub debug info also disappeared.

The kzalloc does not increase the size. So I suspect that the bug
did not trigger again after the change.

> 
> This patch works for me:
> 
> diff -udr linux/fs/ntfs/inode.c linux.new/fs/ntfs/inode.c
> --- linux/fs/ntfs/inode.c	2007-05-25 12:46:27.000000000 +0000
> +++ linux.new/fs/ntfs/inode.c	2007-05-25 12:45:31.000000000 +0000
> @@ -136,11 +136,10 @@
> 
> 		BUG_ON(!na->name);
> 		i = na->name_len * sizeof(ntfschar);
> -		ni->name = kmalloc(i + sizeof(ntfschar), GFP_ATOMIC);
> +		ni->name = kzalloc(i + sizeof(ntfschar), GFP_ATOMIC);

Is this ntfs_init_locked_inode?
				
>  Bytes b4 0xc2959e28:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a
>    Object 0xc2959e38:  24 00 51 00 00 00 6b a5
>   Redzone 0xc2959e40:  00 00 cc cc

First two bytes after the object overwritten. The allocation for this 
object should have been two bytes longer.

> Last alloc: ntfs_init_locked_inode+0x9e/0x110 jiffies_ago=5140 cpu=0 pid=1604

This is the function that allocated a too short object.

