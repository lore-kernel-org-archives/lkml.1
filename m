Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXGKUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXGKUuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXGKUuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:50:32 -0400
Received: from lollipop.listbox.com ([208.210.124.78]:56033 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXGKUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:50:31 -0400
Date: Wed, 11 Jul 2007 15:29:50 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jim.houston@ccur.com, Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: DEFINE_IDR() and the layer cache
Message-ID: <20070711202950.GF17955@localdomain>
References: <200707112027.30490.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707112027.30490.fenkes@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joachim-

Joachim Fenkes wrote:
>
> idr_init(), when called for the first time, sets up the layer
> cache. idr_get_new() and friends expect the cache to exist. Now, what happens
> if the first call to idr_get_new() targets an idr initialized using
> DEFINE_IDR() before idr_init() has been called at least once? Could this
> happen?

unnamed_dev_init() is the first caller of idr_init() and it happens to
be called before the first use of idr_get_new():

[    0.831907]  [<c010615a>] dump_stack+0x16/0x18
[    0.831945]  [<c01c2714>] idr_init+0x3c/0x9c
[    0.831985]  [<c038cab8>] unnamed_dev_init+0xd/0xf
[    0.832027]  [<c037b987>] start_kernel+0x307/0x341
[    0.832068]  [<00000000>] 0x0
[    0.832149]  =======================
[    0.832881] Mount-cache hash table entries: 512
[    0.833432]  [<c010615a>] dump_stack+0x16/0x18
[    0.833470]  [<c01c298f>] idr_get_new_above_int+0x43/0x222
[    0.833541]  [<c01c2b7b>] idr_get_new+0xd/0x28
[    0.833605]  [<c0169243>] set_anon_super+0x36/0xa0
[    0.833667]  [<c01696be>] sget+0x234/0x2c9
[    0.833722]  [<c016a01e>] get_sb_single+0x24/0x8e
[    0.833781]  [<c01a2468>] sysfs_get_sb+0x1c/0x1e
[    0.833867]  [<c0169b63>] vfs_kern_mount+0x41/0x70
[    0.833927]  [<c0169ba8>] kern_mount+0x16/0x18
[    0.833984]  [<c038e494>] sysfs_init+0x57/0xa5
[    0.834026]  [<c038cfe3>] mnt_init+0xc5/0x1cb
[    0.834064]  [<c038cce8>] vfs_caches_init+0x141/0x152
[    0.834104]  [<c037b996>] start_kernel+0x316/0x341
[    0.834144]  [<00000000>] 0x0
[    0.834174]  =======================

It does seem fragile, though.  AFAICT there's no guarantee that a
DEFINE_IDR user couldn't call idr_get_new() before unnamed_dev_init()
runs.

Also, init_id_cache() in idr.c is racy wrt itself.  If the first two
uses of idr_init() occur concurrently, the code could attempt to
create idr_layer_cache twice.

