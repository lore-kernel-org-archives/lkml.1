Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbXJXM0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbXJXM0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbXJXMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:25:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8541 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbXJXMZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:25:46 -0400
Date: Wed, 24 Oct 2007 14:25:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Message-ID: <20071024122542.GW14671@kernel.dk>
References: <471E110C.20404@linux.vnet.ibm.com> <20071023184419.GD14671@kernel.dk> <20071024115436.GT32058@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024115436.GT32058@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Andy Whitcroft wrote:
> On Tue, Oct 23, 2007 at 08:44:20PM +0200, Jens Axboe wrote:
> > On Tue, Oct 23 2007, Kamalesh Babulal wrote:
> > > Hi,
> > > 
> > > Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> > > over the AMD box
> > > 
> > > Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
> > >  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > > PGD 10185b067 PUD 10075b067 PMD 0 
> > > Oops: 0002 [1] SMP 
> > > CPU 3 
> > > Modules linked in:
> > > Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
> > > RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > > RSP: 0000:ffff810181edf948  EFLAGS: 00010002
> > 
> > Can you check where gart_map_sg+0x26c is at? Make sure you have
> > CONFIG_DEBUG_INFO defined, then do:
> > 
> > $ gdb vmlinux
> > $ l *gart_map_sg+0x26c
> 
> Ok, this problem still seems to be about in 2.6.24-rc1.  Here is the gdb
> output from that version, the panic (also below) seems the same:
> 
> (gdb) l *gart_map_sg+0x26c
> 0xffffffff8022011e is in gart_map_sg (arch/x86/kernel/pci-gart_64.c:433).
> 428                     goto error;
> 429             out++;
> 430             flush_gart();
> 431             if (out < nents) {
> 432                     sgmap = sg_next(sgmap);
> 433                     sgmap->dma_length = 0;
> 434             }
> 435             return out;
> 436
> 437     error:
> 
> So it seems sg_next has returned 0.

Interesting. Can you add a

        printk("mapped %d of %d\n", out, nents);

prior to that sg_next() call and reproduce?

-- 
Jens Axboe

