Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXKTMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXKTMLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXKTMLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:11:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:33757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXKTMLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:11:09 -0500
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 13:01:24 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <200711200416.32954.ak@suse.de> <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201301.25373.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 04:50, Christoph Lameter wrote:
> On Tue, 20 Nov 2007, Andi Kleen wrote:
> > I might be pointing out the obvious, but on x86-64 there is definitely
> > not 256TB of VM available for this.
>
> Well maybe in the future.

That would either require more than 4 levels or larger pages
in page tables.

> One of the issues that I ran into is that I had to place the cpu area
> in between to make the offsets link right.

Above -2GB, otherwise you cannot address them

If you can move all the other CPUs somewhere else it might work.

But even then 16MB/cpu max is unrealistic. Perhaps 1M/CPU 
max -- then 16k CPU would be 128GB which could still fit into the existing
vmalloc area.

>
> However, it would be best if the cpuarea came *after* the modules area. We
> only need linking that covers the per cpu area of processor 0.
>
> So I think we have a 2GB area right?

For everything that needs the -31bit offsets; that is everything linked

> 1GB kernel
> 1GB - 1x per cpu area (128M?) modules?
> cpu aree 0
> ---- 2GB limit
> cpu area 1
> cpu area 2
> ....
>
> For that we would need to move the kernel down a bit. Can we do that?

The kernel model requires kernel and modules and everything else
linked be in negative -31bit space. That is how the kernel code model is 
defined.

You could in theory move the modules, but then you would need to implement
a full PIC dynamic linker for them  first and also increase runtime overhead
for them because they would need to use a GOT/PLT.

Or you could switch kernel over to the large model, which is very costly
and has toolkit problems.

Or use the UML trick and run the kernel PIC but again that causes
overhead.

I suspect all of this  would cause far more overhead all over the kernel than 
you could ever save with the per cpu data in your fast paths.

-Andi
