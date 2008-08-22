Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYHVTyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYHVTyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYHVTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:54:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:12986 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYHVTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Wbc5v7I/yv1BTWEE7/Hirra3Zb/Se69ekCRen7fRPuRmKUBs0+5m65BO9wPcXjQI8G
         RsGCtaLwAtDwrH+d+BntPejngHIgsZcl46B0Bwke/4GuS9JInnIABiNSMVuO2X7TrQTh
         mATCPnj7IAq3TYg4eYihx0JhmLKzh8nLdk0xs=
Message-ID: <19f34abd0808221254i5212c6c6g823060699adca16@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:54:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 9:24 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I was trying out
>
> commit 9a2d43b7566caeeeb414aa628bc2759028897dbb
> Date:   Tue Jul 15 21:21:43 2008 +0200
>
> ..as part of the debugging of a different issue, but I got this:
>
> __alloc_bootmem_core(): zero-sized request
> ------------[ cut here ]------------
> kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/mm/bootmem.c:247!
[...]

Don't know how much it helps, but I tried this patch:

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 8d9f60e..56298cb 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -244,7 +244,7 @@ __alloc_bootmem_core(struct bootmem_data *bdata, unsigned lo
ng size,

        if (!size) {
                printk("__alloc_bootmem_core(): zero-sized request\n");
-               BUG();
+               return ZERO_SIZE_PTR;
        }
        BUG_ON(align & (align-1));

...and I got this (it was apparently a bad idea ;-)):

__alloc_bootmem_core(): zero-sized request
Dentry cache hash table entries: -2147483648 (order: -13, 0 bytes)
__alloc_bootmem_core(): zero-sized request
Inode-cache hash table entries: -2147483648 (o -13, 0 bytes)
Bad page state in process 'swapper'
page:000000f0 flags:0x00000000 mapping:00000000 mapcount:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 0, comm: swapper Not tainted 2.6.26-00014-g9a2d43b-dirty #36
 [<c01823b0>] bad_page+0x90/0xd0
 [<c018351b>] free_hot_cold_page+0x21b/0x230
 [<c018357a>] free_hot_page+0xa/0x10
 [<c01835ab>] __free_pages+0x2b/0x40
 [<c01849d2>] __free_pages_bootmem+0x82/0xa0
 [<c082baeb>] free_all_bootmem_core+0xfb/0x1d0
 [<c082bbcd>] free_all_bootmem+0xd/0x10
 [<c08268fa>] mem_init+0x7a/0x3a0
 [<c082e612>] ? inode_init_early+0x62/0xb0
 [<c082e408>] ? vfs_caches_init_early+0x18/0xb0
 [<c08159fa>] start_kernel+0x25a/0x390
 [<c0815180>] ? unknown_bootoption+0x0/0x210
 [<c0815008>] __init_begin+0x8/0x10
 =======================
list_add corruption. next->prev should be prev (0000000c), but was
00000000. (next=00000000).
------------[ cut here ]------------
kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/lib/list_debug.c:27!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
