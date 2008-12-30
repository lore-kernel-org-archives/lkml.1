Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbYL3G1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbYL3G1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYL3G1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:27:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57002 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYL3G1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:27:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
References: <20081218211543.GB10681@wotan.suse.de>
	<20081229151731.2a2c5a02.akpm@linux-foundation.org>
	<20081230040118.GA27679@wotan.suse.de>
Date: Mon, 29 Dec 2008 22:22:12 -0800
In-Reply-To: <20081230040118.GA27679@wotan.suse.de> (Nick Piggin's message of
	"Tue, 30 Dec 2008 05:01:18 +0100")
Message-ID: <m1tz8m41yj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: npiggin@suse.de, ijc@hellion.org.uk, mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
>> On Thu, 18 Dec 2008 22:15:43 +0100
>> Nick Piggin <npiggin@suse.de> wrote:
>> 
>> > Hi,
>> > 
>> > I've debugged a problem where i386+pae systems with more than a few CPUs
>> > blow up at boot in the kmap_atomic code.
>> 
>> ping?
>
> No further progress here, I'm waiting on input for how to fix this
> "nicely". Meantime, clearing the early fixmap pte I guess works, but
> you lose a page... is it possible to put it into .initdata or is
> there some issue with that? (I guess on a PAE kernel, 4K isn't a
> big deal).
>
>  
>> > The problem is that the kmap_atomic pte pages all need to be contiguous
>> > memory because the pte is calculated via the first kmap pte page + an
>> > offset (so as not to have to walk the page tables every time).
>> > 
>> > The fixmap setup code crudely allocates contiguous pte pages, which is fine,
>> > but if it finds an already populated pmd entry, then it will not switch it
>> > to a new, contiguous pte page. So the early fixmap introduces a discontig
>> > page table right in the middle of the kmap atomic fixmaps.

Where is this?

>> > Commenting out the eaarly fixmap setup in head_32.S gets everything working
>> > properly. What would be the best way to fix this? Could we put the early
>> > fixmap page table in initdata, and then have the fixmap setup proper first
>> > clear its corresponding pmd entry?

Why would we want or need to?

>> How come users/testers aren't reporting this?
>
> Because apparently nobody tests 32-bit PAE systems with more than a couple
> of CPUs anymore. This bug comes from HW vendor doing testing of SLES11.

Hmm.

I have taken a quick skim and I am not seeming the part of the code you are
talking about.  Is the problem code in mainline?

I'm guessing it has something to do with reserve_top_address() being called
with a bad value in the normal case.  But I don't see it being called
at all in the normal case.

Eric

