Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYL3Wrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYL3Wrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYL3Wrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:47:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44889 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYL3Wrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:47:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
References: <20081218211543.GB10681@wotan.suse.de>
	<20081229151731.2a2c5a02.akpm@linux-foundation.org>
	<20081230040118.GA27679@wotan.suse.de>
	<20081230061344.GA28281@elte.hu> <20081230102831.GB3189@wotan.suse.de>
Date: Tue, 30 Dec 2008 14:41:53 -0800
In-Reply-To: <20081230102831.GB3189@wotan.suse.de> (Nick Piggin's message of
	"Tue, 30 Dec 2008 11:28:31 +0100")
Message-ID: <m1bput4766.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: npiggin@suse.de, ijc@hellion.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Tue, Dec 30, 2008 at 07:13:44AM +0100, Ingo Molnar wrote:
>> 
>> * Nick Piggin <npiggin@suse.de> wrote:
>> 
>> > On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
>> > > On Thu, 18 Dec 2008 22:15:43 +0100
>> > > Nick Piggin <npiggin@suse.de> wrote:
>> > > 
>> > > > Hi,
>> > > > 
>> > > > I've debugged a problem where i386+pae systems with more than a few CPUs
>> > > > blow up at boot in the kmap_atomic code.
>> > > 
>> > > ping?
>> > 
>> > No further progress here, I'm waiting on input for how to fix this 
>> > "nicely". Meantime, clearing the early fixmap pte I guess works, but you 
>> > lose a page... is it possible to put it into .initdata or is there some 
>> > issue with that? (I guess on a PAE kernel, 4K isn't a big deal).
>> 
>> yeah, 4K shouldnt be a big deal. Mind sending a patch for this?
>
> How's this?
> --
>
> The early fixmap pmd entry inserted at the very top of the KVA is casing the
> subsequent fixmap mapping code to not provide physically linear pte pages over
> the kmap atomic portion of the fixmap (which relies on said property to
> calculate
> pte address).
>
> This has caused weird boot failures in kmap_atomic much later in the boot
> process (initial userspace faults) on a 32-bit PAE system with a larger number
> of CPUs (smaller CPU counts tend not to run over into the next page so don't
> show up the problem).
atomic>
> Solve this by attempting to clear out the page table, and copy any of its
> entries to the new one. Also, add a bug if a nonlinear condition is encounted
> and can't be resolved, which might save some hours of debugging if this fragile
> scheme ever breaks again...
>
> Putting swapper_pg_fixmap into initdata is an exercise left for the reviewer...

Ok.  I see what is going on now.  We have exceeded 512 fixmap entries, causing
the fixmap entries to consume more than 2MB of the address space.   Which broke
the assumption that the fixmap entries are all contiguous.

Ditching the swapper_pg_fixmap has some problems.

This appears to break early_printk to a usb debug port, which calls
set_fixmap_nocache and expects the mapping to last.

This looks like it will have problems with Xen and other environments
where we come in with a pre-populated page table, possibly unmapping
something important.

one_page_table_init relies on alloc_bootmem_low_pages for it's memory allocation
so we do not have a guarantee that we will have contiguous memory even without
this.

I see three ways we can address this.
- Grow swapper_pg_fixmap to cover the entire fixmap range.
  This trivially and without problems gives an atomic guarantee,
  and should allow removal of code that sets up the fixmaps later
  in C, except in weird cases like Xen.

- Decide it is worth optimizing kmap_atomic_prot some more.
  Have a kmap_pte per cpu.
  Cache line align the kmap pte entries so we don't get conflicts
  per cpu, at which point we should be guaranteed the all 13 of
  them will be physically contiguous.

- Not support more than 32 cpus on x86_32.

I suspect it might even be worth writing a version of one_page_table_init
that would guarantee discontiguous pages.  So we can flush out these
kinds of fragile assumptions.  

Eric

