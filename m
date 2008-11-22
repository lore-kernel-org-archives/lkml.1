Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYKVBvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYKVBvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYKVBvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:51:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:49082 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979AbYKVBvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:51:01 -0500
Date: Sat, 22 Nov 2008 10:49:27 +0900
To: Ian.Campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1227277292.7186.32.camel@zakaz.uk.xensource.com>
References: <1226938566.18916.80.camel@zakaz.uk.xensource.com>
	<20081119112015I.fujita.tomonori@lab.ntt.co.jp>
	<1227277292.7186.32.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081122104919X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 14:21:32 +0000
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Wed, 2008-11-19 at 11:19 +0900, FUJITA Tomonori wrote:
> > 
> > The problem that I talked about in the previous mail:
> > 
> > >       max_slots = mask + 1
> > >                   ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
> > >                   : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
> > 
> > Since the popular value of the mask is 0xffffffff. So the above code
> > (mask + 1 ?) works wrongly if the size of mask is 32bit (well,
> > accidentally the result of max_slots is identical though).
> 
> I've just been looking at this again and I don't think it is an accident
> that this evaluates to the correct value when mask + 1 == 0.
> 
> The patch which adds the "mask + 1 ? ... : 1UL << ..." stuff is:
> 
>         commit b15a3891c916f32a29832886a053a48be2741d4d
>         Author: Jan Beulich <jbeulich@novell.com>
>         Date:   Thu Mar 13 09:13:30 2008 +0000
>         
>             avoid endless loops in lib/swiotlb.c
>             
>             Commit 681cc5cd3efbeafca6386114070e0bfb5012e249 ("iommu sg merging:
>             swiotlb: respect the segment boundary limits") introduced two
>             possibilities for entering an endless loop in lib/swiotlb.c:
>             
>              - if max_slots is zero (possible if mask is ~0UL)
>              [...]
> 
> I think the existing code is the nicest way to handle this corner case
> and it is necessary anyway to handle the ~0UL case on 64 bit.

Ah, I vaguely remember this patch. The ~0ULL mask didn't happen here
(nobody uses it) so the possibility was false. IMHO, if we use this
code on 32bit architectures, the mask should be u64 and the overflow
should be handled explicitly. But as you pointed out, looks like that
this patch takes account of the overflow.

Thanks,
