Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZJNRLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZJNRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZJNRLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:11:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35235 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbZJNRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:11:33 -0400
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       David Miller <davem@davemloft.net>, Nitin Gupta <ngupta@vflare.org>,
       Nick Piggin <npiggin@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20091013020752.GB5736@linux-sh.org>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
	 <20091012090710.GA29310@n2100.arm.linux.org.uk>
	 <20091012.023744.157085851.davem@davemloft.net>
	 <20091012100023.GC29310@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.0910121634170.7327@sister.anvils>
	 <20091012170312.GB9453@flint.arm.linux.org.uk>
	 <20091013020752.GB5736@linux-sh.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 14 Oct 2009 18:10:29 +0100
Message-Id: <1255540229.15103.50.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 17:10:30.0510 (UTC) FILETIME=[3BA6D8E0:01CA4CF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 11:07 +0900, Paul Mundt wrote:
> On Mon, Oct 12, 2009 at 06:03:12PM +0100, Russell King wrote:
> > On Mon, Oct 12, 2009 at 05:09:53PM +0100, Hugh Dickins wrote:
> > > Sorry to muddy the waters on this, if you and Dave are sure that
> > > you have the right fix, down in your architectures, and that fix
> > > isn't going to hurt your performance significantly.
> > 
> > If I look at the issue from this point of view:
> > 
> > - we are using PG_arch_1 to delay cache handling for the page
> > 
> > - if PG_arch_1 is set on a page, we set it explicitly because we
> >   didn't do some flushing between the allocation of the page and
> >   mapping it into userspace
> > 
> > - if a page with PG_arch_1 set ever gets to userspace, this can
> >   only be because we did the lazy flushing thing
> > 
> > I don't see that there should have been any bearing on whether a page
> > has a mapping or not when we get to update_mmu_cache.  The issue here
> > is that > if PG_arch_1 is set on a page, then we didn't flush it at
> > the time when we believed it was appropriate to do so. <
> > 
> > Tell me I'm wrong (having only just sent it to Linus...)
> 
> Having looked at the ARM fix, in the !mapping case do you not need the
> I-cache flush on vma->vm_flags & VM_EXEC? Or is the presumption that
> flush_icache_page()-type action doesn't need to be undertaken by
> flush_dcache_page()/update_mmu_cache() when there is no page_mapping()?

If I understand Nitin's scenario correctly, I think it should also
invalidate the I-cache.

For executable anonymous pages containing, it's the user app writing the
code (JIT etc.) and it calls an ARM-specific syscall for I and D cache
maintenance. If such page is read back from swap, following Nitin's
scenario, the I-cache would need to be invalidated as well otherwise it
can have stale entries.

-- 
Catalin

