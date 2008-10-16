Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYJPTRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYJPTRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYJPTRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:17:12 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36984 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbYJPTRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:17:11 -0400
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <alpine.LFD.2.00.0810151630050.3288@nehalem.linux-foundation.org>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <alpine.LFD.2.00.0810151630050.3288@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: Contractor at HP
Date: Thu, 16 Oct 2008 13:17:20 -0600
Message-Id: <1224184640.2215.293.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 23:40 +0000, Linus Torvalds wrote:
> 
> On Wed, 15 Oct 2008, Bob Montgomery wrote:
> >
> > This patch changes the initialization of the GART to set the DISGARTCPU
> > bit in the GART Aperture Control Register (AMD64_GARTAPERTURECTL).
> > Setting the bit prevents requests from the CPUs from accessing the
> > GART.  In other words, CPU memory accesses to the aperture address
> > range will not cause the GART to perform an address translation.
> > The aperture area is currently being unmapped at the kernel level
> > with set_memory_np() in gart_iommu_init to prevent accesses from the
> > CPU [...]
> 
> Would this allow us to get rid of that particular hackup code sequence
> entirely? Or do we still need them for other chip versions etc?

Short answer: I don't know.  Here's some of what I don't know enough
about:

The GART aperture is typically overlaid over a real memory area, so it
effectively wastes the 64MB (or whatever) of RAM underneath it.  When
you disable CPU side access in the GART itself, the kernel once again
should "see" that RAM and presumably use it.  But, it wouldn't be
general purpose RAM, because it couldn't be used for DMA (since any
accesses from the IO side would be GART'd off to somewhere else).
Would that make it overly hacky?

It appears to be possible for a BIOS to set up a valid aperture that
does not overlay real memory.   Mine never does, so I get dmesgs like:

[    0.000999] Node 0: aperture @ 20000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000

But if it did set up over a hole, would the current code still call
set_memory_np for an address that wasn't RAM in the e820 map?  Would
that be a problem or a NOP?   

> 
> I get the feeling that the people cc'd are kdump people, not iommu/gart
> people, which is a bit sad.

Noted. Thanks to Ingo for the cc's.   Chandru was cc'd because he was
the only other person I knew who had seen the problem, and he tested the
fix first on 2.6.27-rc8.

> 
>                 Linus

Bob Montgomery

