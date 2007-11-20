Return-Path: <linux-kernel-owner+w=401wt.eu-S1763074AbXKTVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074AbXKTVeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbXKTVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:34:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45376 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756076AbXKTVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:33:59 -0500
Date: Tue, 20 Nov 2007 13:33:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711202159.36377.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711201325130.27539@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de>
 <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
 <200711202159.36377.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andi Kleen wrote:

> 
> > 
> > Right so I could move the kernel to
> > 
> > #define __PAGE_OFFSET     _AC(0xffff810000000000, UL)
> > #define __START_KERNEL_map_AC(0xfffffff800000000, UL)
> 
> That is -31GB unless I'm miscounting. But it needs to be >= -2GB
> (31bits) 

The __START_KERNEL_map needs to cover the 2GB that the kernel needs for 
modules and the cpu area 0. The remaining 28GB can be out of range.

> Right now it is at -2GB + 2MB,  because it is loaded at physical +2MB
> so it's convenient to identity map there. In theory you could avoid that
> with some effort, but that would only buy you 2MB and would also
> break some early code and earlyprintk I believe.

My proporsal is -32GB + 2MB. It keeps the arrangement.

> > > You could in theory move the modules, but then you would need to implement
> > > a full PIC dynamic linker for them  first and also increase runtime overhead
> > > for them because they would need to use a GOT/PLT.
> > 
> > Why is it not possible to move the kernel lower while keeping bit 31 1?
> 
> The kernel model relies on 32bit sign extension. This means bits [31;63] have
> to be all 1

32bit sign extension for what? Absolute data references? The addressing 
that I have seen was IP relative. Thus I thought that the kernel could be 
moved lower.

> > > I suspect all of this  would cause far more overhead all over the kernel than 
> > > you could ever save with the per cpu data in your fast paths.
> > 
> > Moving the kernel down a bit seems to be trivial without any of the weird 
> > solutions.
> 
> Another one I came up in the previous mail would be to do the linker reference
> variable allocation in [0;2GB] positive space; but do all real references only
> %gs relative. And keep the real data copy on some other address. That would
> be a similar trick to the old style x86-64 vsyscalls. It gets fairly
> messy in the linker map file though.

The linker references are to per cpu data already in the 0-MAX_CPU_AREA 
range after this patchset. The problem is the relocation of the 
references when the linker calculates the address of a per cpu variable.


F.e. The pda is placed at absolute address 0

In order to access the pda we have to do either



1. A  CPU_PTR(offsetof pda,<cpu>) which is

offsetof pda (so 0) + cpu_area + cpu << area_shift

The compiler currently folds

offsetof pda + cpu_area

and then addds the shift later.

or

2. We use a CPU_xx op with a segment register.

Then we have no need to add cpu area because it is included in the gs 
offset.


So only case 1 is affected which is not used if cpu ops can be used.
There are still critical path uses of that operation so I would really 
like to avoid the explicit calculation.

If we would go the proposed route then the folding of the address would 
have to be replaced by the linker by an explicit calculation.

