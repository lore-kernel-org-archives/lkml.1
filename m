Return-Path: <linux-kernel-owner+w=401wt.eu-S1031588AbXEAFfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031588AbXEAFfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031593AbXEAFfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:35:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49887 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031588AbXEAFfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:35:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <ak@suse.de>, Mark Lord <lkml@rtr.ca>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
References: <20070501557.815359000@suse.de>
	<20070501035829.1C93D13CAF@wotan.suse.de>
	<20070501043735.GR31925@holomorphy.com>
Date: Mon, 30 Apr 2007 23:35:27 -0600
In-Reply-To: <20070501043735.GR31925@holomorphy.com> (William Lee Irwin, III's
	message of "Mon, 30 Apr 2007 21:37:35 -0700")
Message-ID: <m1vefdyulc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> writes:

> On Tue, May 01, 2007 at 05:58:29AM +0200, Andi Kleen wrote:
>> From: ebiederm@xmission.com
>> When in PAE mode we require that the user kernel divide to be
>> on a 1G boundary.  The 2G/2G split does not have that property
>> so require !X86_PAE
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  arch/i386/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> What on earth?
>
> config PAGE_OFFSET
>         hex
>         default 0xB0000000 if VMSPLIT_3G_OPT
>         default 0x78000000 if VMSPLIT_2G
>         default 0x40000000 if VMSPLIT_1G
>         default 0xC0000000
>
> This appears to have been introduced by:
> commit 975b3d3d5b983eb60706d35f0d24cd19f6badabf
> Author: Mark Lord <lkml@rtr.ca>
> Date:   Wed Feb 1 03:06:11 2006 -0800
>     [PATCH] VMSPLIT config options
>
> There's some sort of insanity going on here. Since when is 0x78000000
> a 2GB/2GB split? Mark, dare I ask what you were thinking? That should
> be VMSPLIT_2G_OPT for 2GB laptops analogously to VMSPLIT_3G_OPT, if
> nothing else, as it's certainly not 2GB/2GB.

It makes a little more sense when you realize all of the options
were originally !X86_PAE.  So they were designed with highmem
disabled.

> These VMSPLIT config options vs. PAE are foul as they're now done in
> any event. If they were done properly, they'd properly set up the pmd
> within which the division point between user and kernelspace falls.

They were designed to avoid highmem a totally different design point.

> This patch, I suppose, stops people from shooting themselves in the
> foot, but (IMHO) the VMSPLIT patches shouldn't have been merged
> without handling the partial pmd case. 2MB/4MB resolution is enough
> granularity for any reasonable purpose, so split ptes aren't worth the
> effort, but this nonsense with PAE vs. VMSPLIT is just preposterous.
> If you're going to play the VMSPLIT game at all, handle split pmd's.

What I find telling is that I fixed this based on code review not
based on bug reports.

> I'll see what else is pending in the i386 pagetable arena and clear
> this up if there aren't other objections (this is where Andi gets to
> complain that things are too complex already and preemptively NAK to
> save me the effort, if it's not seen to be desirable). Eric, your patch
> is a reasonable stop-gap measure for the original deficiency.

Frankly rather then putting much effort into this I suspect we should
just delete these options entirely.  We are long past the point where
they matter.

Eric
