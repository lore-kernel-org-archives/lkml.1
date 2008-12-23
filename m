Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYLWAge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYLWAge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYLWAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:36:26 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53397 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYLWAgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:36:25 -0500
Date: Tue, 23 Dec 2008 00:35:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Yuri Tikhonov <yur@emcraft.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, paulus@samba.org, wd@denx.de, dzu@denx.de,
       yanok@emcraft.com, miltonm@bga.com, viro@zeniv.linux.org.uk,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH] mm/shmem.c: fix division by zero
In-Reply-To: <200812190844.57996.yur@emcraft.com>
Message-ID: <Pine.LNX.4.64.0812230016510.13610@blonde.anvils>
References: <200812190844.57996.yur@emcraft.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Yuri Tikhonov wrote:
> 
> The following patch fixes division by zero, which we have in
> shmem_truncate_range() and shmem_unuse_inode(), if use big
> PAGE_SIZE values (e.g. 256KB on ppc44x).
> 
> With 256KB PAGE_SIZE the ENTRIES_PER_PAGEPAGE constant becomes
> too large (0x1.0000.0000), so this patch just changes the types
> from 'ulong' to 'ullong' where it's necessary.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

Sorry for the slow reply, but I'm afraid I don't like spattering
around an increasing number of unsigned long longs to fix that division
by zero on an unusual configuration: I doubt that's the right solution.

It's ridiculous for shmem.c to be trying to support a wider address
range than the page cache itself can support, and it's wasteful for
it to be using 256KB pages for its index blocks (not to mention its
data blocks! but we'll agree to differ on that).

Maybe it should be doing a kmalloc(4096) instead of using alloc_pages();
though admittedly that's not a straightforward change, since we do make
use of highmem and page->private.  Maybe I should use this as stimulus
to switch shmem over to storing its swap entries in the pagecache radix
tree.  Maybe we should simply disable its use of swap in such an
extreme configuration.

But I need to understand more about your ppc44x target to make
the right decision.  What's very strange to me is this: since
unsigned long long is the same size as unsigned long on 64-bit,
this change appears to be for a 32-bit machine with 256KB pages.
I wonder what market segment that is targeted at?

Hugh
