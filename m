Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0CFTlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:41:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33335 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0CFTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:41:18 -0500
Date: Sat, 6 Mar 2010 19:36:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100306193649.GB13262@n2100.arm.linux.org.uk>
References: <1267316072.23523.1842.camel@pasglop> <1267333263.2762.11.camel@mulgrave.site> <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com> <20100303215437.GF2579@ucw.cz> <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com> <20100304135128.GA12191@atrey.karlin.mff.cuni.cz> <1267712512.31654.176.camel@mulgrave.site> <20100304142704.GB6622@n2100.arm.linux.org.uk> <1267872443.8894.1443.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267872443.8894.1443.camel@mulgrave.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 04:17:23PM +0530, James Bottomley wrote:
> On a fault in of exec data, we first try to get the page out of the page
> cache.  If it's not present, we put the faulting process to sleep and
> fetch it in from storage.  When we do the read, on the PIO path, the
> kernel alias for the page becomes dirty.  Some time later, we place the
> page into the user space (updating the pte entry that caused a fault).
> At this point, we'll call both flush_icache_page() and
> update_mmu_cache() ... this is where the I/D resolution should be done.

No - this is where things get extremely icky.

The problem at this point occurs on SMP architectures.  As soon as you
update the PTE entry, it is visible to other threads of the application.
If you do I-cache handling after updating the PTE, then there is a window
where another CPU can execute the page:

CPU0			CPU1
			speculatively prefetches from page N via kernel
			mapping, loads garbage into I-cache
attempts to execute P
page fault
page N allocated
set_pte_at
			executes P
			*splat*
flush I-cache
