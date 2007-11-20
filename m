Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbXKTU75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbXKTU75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764009AbXKTU7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:59:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:48917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763066AbXKTU7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:59:44 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 21:59:36 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de> <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711202159.36377.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Right so I could move the kernel to
> 
> #define __PAGE_OFFSET     _AC(0xffff810000000000, UL)
> #define __START_KERNEL_map_AC(0xfffffff800000000, UL)

That is -31GB unless I'm miscounting. But it needs to be >= -2GB
(31bits) 

Right now it is at -2GB + 2MB,  because it is loaded at physical +2MB
so it's convenient to identity map there. In theory you could avoid that
with some effort, but that would only buy you 2MB and would also
break some early code and earlyprintk I believe.

> > You could in theory move the modules, but then you would need to implement
> > a full PIC dynamic linker for them  first and also increase runtime overhead
> > for them because they would need to use a GOT/PLT.
> 
> Why is it not possible to move the kernel lower while keeping bit 31 1?

The kernel model relies on 32bit sign extension. This means bits [31;63] have
to be all 1
 
> > I suspect all of this  would cause far more overhead all over the kernel than 
> > you could ever save with the per cpu data in your fast paths.
> 
> Moving the kernel down a bit seems to be trivial without any of the weird 
> solutions.

Another one I came up in the previous mail would be to do the linker reference
variable allocation in [0;2GB] positive space; but do all real references only
%gs relative. And keep the real data copy on some other address. That would
be a similar trick to the old style x86-64 vsyscalls. It gets fairly
messy in the linker map file though.

-Andi
