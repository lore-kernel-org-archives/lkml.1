Return-Path: <linux-kernel-owner+w=401wt.eu-S2993138AbXEBTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993138AbXEBTN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993136AbXEBTN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:13:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37206 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993138AbXEBTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:13:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com>
	<20070502005140.b94500ff.akpm@linux-foundation.org>
	<20070502084617.GY26598@holomorphy.com>
	<20070502100600.GZ26598@holomorphy.com> <4638BC3E.9080708@goop.org>
	<20070502163244.GA26598@holomorphy.com>
	<m1k5vrw3h0.fsf@ebiederm.dsl.xmission.com>
	<20070502175220.GB26598@holomorphy.com>
Date: Wed, 02 May 2007 13:13:14 -0600
In-Reply-To: <20070502175220.GB26598@holomorphy.com> (Bill Irwin's message of
	"Wed, 2 May 2007 10:52:20 -0700")
Message-ID: <m1bqh3vy2d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:

> On Wed, May 02, 2007 at 09:28:46AM -0700, Jeremy Fitzhardinge wrote:
>>>> I think this should be fixed now.  Eric made all those writes
>>>> unconditional (to fix a problem with PSE superpages not being created). 
>>>> The patch is in Andi's queue.
>
> Bill Irwin <bill.irwin@oracle.com> writes:
>>> It needs verification with the testcase from this thread.
>
> On Wed, May 02, 2007 at 11:16:27AM -0600, Eric W. Biederman wrote:
>> Sounds reasonable.
>> However there is no reason to suspect it won't fix this case because
>> unconditional writes are what we have always done, and we have always
>> kept swapper_pg_dir from early boot as well.
>> In essence my patch I sent out to Andi was a partial revert.
>
> It would not be so far out to be aware of what pagetable entries were
> carried over from the initial swapper_pg_dir and explicitly clobber
> them (for instance, modifying their protection bits while otherwise
> retaining them).

And that is actually what we do, but without paying attention, when
setting up the identity mappings.

> On Wed, May 02, 2007 at 11:16:27AM -0600, Eric W. Biederman wrote:
>> It isn't slated to go in until nextround but I also rewrote the early
>> page table setup in C.  Allowing set_fixmap to work in the early
>> kernel, and fix problems of not having enough memory mapped to build
>> the identity mappings, because we are then updating the page table
>> we have also in the PAE case.
>
> I'm not sure when we run into those problems, though I understand what
> they are. I suppose it would be good to resolve them.

The nasty one is if you have a kernel sized just right.  All you get
from the early page tables of allocatable memory is the low 640K.  If
you have PSE disabled (because PAGEALLOC_DEBUG is enabled) up only
have enough pages in the mapping to setup a 256M identity mapping unsing
4K pages ouch.

Another issue is that we have boot_ioremap, and bt_ioremap for different
stages of the boot.  Enabling fixmap early solves that.

Then there is my personal hobby horse.  Using new fangled hardware with
memory mapped I/O registers for debugging.  You need to be able to modify
the page table to use it so you might as well setup the fixmap entries
and then you have something that can be used as long as you care to
leave the hardware enabled.

Eric
