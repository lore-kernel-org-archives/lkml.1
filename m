Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYHNVEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYHNVEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHNVEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:04:31 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48224 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYHNVEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:04:30 -0400
Date: Thu, 14 Aug 2008 22:03:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
In-Reply-To: <48A48879.2000309@goop.org>
Message-ID: <Pine.LNX.4.64.0808142104080.29719@blonde.site>
References: <1218697362.26014.9.camel@localhost.localdomain>
 <Pine.LNX.4.64.0808141347480.11013@blonde.site> <48A48879.2000309@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Jeremy Fitzhardinge wrote:
> Hugh Dickins wrote:
> > In both cases it's handling a page fault: I'm curious as to what kind
> > of vma this fault is occurring on.  Could you devise a way of getting
> > us /proc/<pid>/maps output, together with the faulting address, when
> > it hits one of these BUGs?  Or should I try to put together a patch
> > for that?
> 
> It's a /dev/fb0 mapping:
> 
> open("/dev/fb0", O_RDWR)                = 8
> ...
> mmap(NULL, 2097152, PROT_READ|PROT_WRITE, MAP_SHARED, 8, 0) = 0x7fed69a08000
> 
> The fault is 1 page into this mapping:
> 
> WARNING: at /home/jeremy/hg/xen/paravirt/linux/fs/buffer.c:711
> __set_page_dirty+0x7e/0x113()
> kernel BUG at /home/jeremy/hg/xen/paravirt/linux/lib/radix-tree.c:473!
> radix_tree_tag_set+0x17/0x9b
> CR2: 00007fed69a09000 CR3: 000000000cbc4000 CR4: 0000000000002620
>     ^^^^^^^^^^^^^^^^
> Process X (pid: 1357, threadinfo ffff88000b048000, task ffff88000cb2ecc0)

Brilliant, thanks a lot, Jeremy.  That fits, I'd been inching towards
forming the thought that it was likely to involve a block or char device
(rather than a directory, which is what had prompted the patch).

I'd thought about them when making the patch, but quickly decided that
a device node may live in a tmpfs (and usually does with udev), but
redirects off to somewhere else entirely.

If I open /dev/sda and mmap it, then I don't expect to see pages of
shmem, I expect to see pages from my disk.  Though if I open /dev/zero
and mmap it, that character device does happen to be the one which
comes back and delivers pages of shmem.

Now if I open /dev/fb0 here and mmap it as you did, and try to write
to it through those pages, I see nothing bad happening: I don't know
for sure what pages it's making available to me, but I hope they're
pages belonging to that driver.

tmpfs doesn't associate its shmem_file_operations with a device node,
so there wouldn't be a way to mmap it, unless the device driver gives
the struct file its own file_operations, including an .mmap method.

It looks like your fb driver is providing a backing_dev_info which
tells vma_wants_writenotify that it wants mapping_cap_account_dirty:
hmm, I suppose the default one would do that, though shmem provided
one which says not.  But not providing any address_space_operations
with a .set_page_dirty which would keep it out of trouble.

Before my patch, the device node happened to stay pointing to
shmem_aops, whose set_page_dirty was safe; now it's getting
default behaviour, and hitting these problems.

As you can see, I'm still groping towards the right answer.
The driver probably needs to provide its own backing_dev_info
(or point to a suitable default), and its own address_space_ops,
and perhaps more (there should be examples elsewhere).  But whether
it is actually wrong, or whether I was wrong to mess it up, I've
not yet decided.

An additional useful input would be: what happens if you replace
that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node in
one of your disk filesystems?  I rather expect that to cause the same
trouble, which would argue that the driver is wrong and shmem right.

Hugh
