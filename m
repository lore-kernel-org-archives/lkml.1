Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0CEB3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:29:06 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40522 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0CEB3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:29:03 -0500
Date: Fri, 5 Mar 2010 10:28:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
Message-ID: <20100305012823.GD26618@linux-sh.org>
References: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com> <20100304164416.GD13417@n2100.arm.linux.org.uk> <1267727802.6526.545.camel@e102109-lin.cambridge.arm.com> <20100304214435.GJ13417@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304214435.GJ13417@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 09:44:35PM +0000, Russell King - ARM Linux wrote:
> On Thu, Mar 04, 2010 at 06:36:42PM +0000, Catalin Marinas wrote:
> > ARM: Assume new page cache pages have dirty D-cache
> > 
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > There are places in Linux where writes to newly allocated page cache
> > pages happen without a subsequent call to flush_dcache_page() (several
> > PIO drivers including USB HCD). This patch changes the meaning of
> > PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
> > mapped page in update_mmu_cache().
> > 
> > The patch also sets the PG_arch_1 bit in the DMA cache maintenance
> > function to avoid additional cache flushing in update_mmu_cache().
> 
> As I just realised, this is going to subject all pages placed into
> userspace with a D cache flush - even anonymous pages, and those
> which we've been careful to deal with the cache issues already (eg,
> via the COW page copying code.)
> 
> I think all the copypage functions need to set PG_dcache_clean on the
> new pages once their copy has completed.
> 
> I wonder if there's any other anonymous page creating functions which
> could do with a similar treatment...

In the anonymous page case, flush_anon_page() is always called prior to
flush_dcache_page(), so flush_anon_page() could just set PG_dcache_clean
to work around that. That would handle get_user_pages(), too.
