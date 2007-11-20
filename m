Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXKTUfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXKTUfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbXKTUfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:35:23 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56438 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760531AbXKTUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:35:22 -0500
Date: Tue, 20 Nov 2007 12:35:22 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711201301.25373.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711200416.32954.ak@suse.de>
 <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com>
 <200711201301.25373.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andi Kleen wrote:

> > So I think we have a 2GB area right?
> 
> For everything that needs the -31bit offsets; that is everything linked

Of course.

> > 1GB kernel
> > 1GB - 1x per cpu area (128M?) modules?
> > cpu aree 0
> > ---- 2GB limit
> > cpu area 1
> > cpu area 2
> > ....
> >
> > For that we would need to move the kernel down a bit. Can we do that?
> 
> The kernel model requires kernel and modules and everything else
> linked be in negative -31bit space. That is how the kernel code model is 
> defined.

Right so I could move the kernel to

#define __PAGE_OFFSET     _AC(0xffff810000000000, UL)
#define __START_KERNEL_map_AC(0xfffffff800000000, UL)
#define KERNEL_TEXT_START _AC(0xfffffff800000000, UL) 30 bits = 1GB for kernel text
#define MODULES_VADDR     _AC(0xfffffff880000000, UL) 30 bits = 1GB for modules
#define MODULES_END       _AC(0xfffffff8f0000000, UL)
#define CPU_AREA_BASE     _AC(0xfffffff8f0000000, UL) 31 bits 256MB for cpu area 0
#define CPU_AREA_BASE1	  _AC(0xfffffff900000000, UL) More cpu areas for higher numbered processors
#define CPU_AREA_END	  _AC(0xffffffffffff0000, UL)

> You could in theory move the modules, but then you would need to implement
> a full PIC dynamic linker for them  first and also increase runtime overhead
> for them because they would need to use a GOT/PLT.

Why is it not possible to move the kernel lower while keeping bit 31 1?

> I suspect all of this  would cause far more overhead all over the kernel than 
> you could ever save with the per cpu data in your fast paths.

Moving the kernel down a bit seems to be trivial without any of the weird 
solutions.

