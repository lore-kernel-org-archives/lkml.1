Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJ0GW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJ0GW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYJ0GWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:22:21 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:63028 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYJ0GWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:22:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,491,1220193000"; 
   d="scan'208";a="218930768"
Date: Mon, 27 Oct 2008 17:22:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Claudio Martins <ctpm@ist.utl.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Order 0 page allocation failure under heavy I/O load
Message-ID: <20081027062216.GH11948@disturbed>
Mail-Followup-To: Claudio Martins <ctpm@ist.utl.pt>,
	linux-kernel@vger.kernel.org
References: <20081026225723.GO18495@disturbed> <200810270547.31123.ctpm@ist.utl.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810270547.31123.ctpm@ist.utl.pt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 06:47:31AM +0100, Claudio Martins wrote:
> On Sunday 26 October 2008, Dave Chinner wrote:
> 
> > The host will hang for tens of seconds at a time with both CPU cores
> > pegged at 100%, and eventually I get this in dmesg:
> >
> > [1304740.261506] linux: page allocation failure. order:0, mode:0x10000
> > [1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64
> 
>  Hello,
> 
>  Have you tried to increase vm.min_free_kbytes to something higher, that is 
> >=30000?

No, because I've found the XFS bug the workload was triggering so
I don't need to run it anymore.

I reported the problem because it appears that we've reported an
allocation failure without very much reclaim scanning (64 pages in
DMA zone, 0 pages in DMA32 zone), and there is apparently pages
available for allocation in the DMA zone:

1304740.262136] Node 0 DMA: 160*4kB 82*8kB 32*16kB 11*32kB 8*64kB 4*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8048kB

So it appears that memory reclaim has not found the free pages it
apparently has available....

Fundamentally, I/O from a single CPU to a single disk on a machine
with 2GB RAM should not be able to cause allocation failures at all,
especially when the I/O is pure data I/O to a single file. Something
in the default config is busted if I can do that, and that's why
I reported the bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
