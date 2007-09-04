Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbXIDRHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbXIDRHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXIDRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:06:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34295 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbXIDRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:06:57 -0400
Date: Tue, 4 Sep 2007 09:58:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Marco Berizzi <pupilla@hotmail.com>
cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       mel@skynet.ie
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
 <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
 <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007, Marco Berizzi wrote:

> After a week uptime I got this error. I hope it
> will be useful for you.

Yes indeed but this is a different type of failure. Looks like a higher 
allocation failure in the networking code. Someone created objects that
required an order 2 allocations that failed.

> SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1

Slub is restricted to order 0 and 1 allocs.

>   PREFETCH window: e5c00000-e7cfffff
> NET: Registered protocol family 2
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> TCP bind hash table entries: 8192 (order: 3, 32768 bytes)

Hmmmm.

> eth2:  setting full-duplex.
> swapper: page allocation failure. order:2, mode:0x4020
>  [<c013b21d>] __alloc_pages+0x1ed/0x2e0
>  [<c014ee3b>] allocate_slab+0x4b/0x90
>  [<c014eef2>] new_slab+0x32/0x150
>  [<c014f47b>] __slab_alloc+0xcb/0x120
>  [<c014f429>] __slab_alloc+0x79/0x120
>  [<c02b0183>] tcp_collapse+0x113/0x3b0

tcp_collapse? This is due to a network configuration that required an
order 2 kmalloc block. Jumbo frames?

