Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYHQOmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYHQOmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 10:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYHQOl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 10:41:56 -0400
Received: from saeurebad.de ([85.214.36.134]:38309 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYHQOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 10:41:55 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mm: make unmap_vmas() handle non-page-aligned boundary addresses
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	<sNRO-BDDjQL.A.spE.VazpIB@albercik>
	<Pine.LNX.4.64.0808170036400.25704@blonde.site>
	<87fxp4pi0r.fsf_-_@skyscraper.fehenstaub.lan>
	<Pine.LNX.4.64.0808171151190.13521@blonde.site>
	<8763pzygod.fsf@skyscraper.fehenstaub.lan>
	<Pine.LNX.4.64.0808171359010.24614@blonde.site>
Date: Sun, 17 Aug 2008 16:41:31 +0200
In-Reply-To: <Pine.LNX.4.64.0808171359010.24614@blonde.site> (Hugh Dickins's
	message of "Sun, 17 Aug 2008 14:24:00 +0100 (BST)")
Message-ID: <87bpzrd7qc.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hugh Dickins <hugh@veritas.com> writes:

> On Sun, 17 Aug 2008, Johannes Weiner wrote:
>> Hugh Dickins <hugh@veritas.com> writes:
>> 
>> I will try and help debugging this further.
>
> Thanks!
>
>> > You're right that those pgd_addr_end() etc. loops have an implicit
>> > and fragile dependence on the page alignment of addr and end.  They
>> > were written that way to maximize efficiency and be homogeneous
>> > across the levels, while handling the wrapped end 0 case.  But both
>> > fast gup and pagewalk have stumbled on those assumptions recently.
>> 
>> Yeah, especially since they could cause silent page table corruption :(
>
> Silent?  I guess those'll be the cases we've not heard about ;)

Or we couldn't associate the problem with the source :)

>> In this respect, I still think that my patch has a point.  Because yes,
>> the looping depends on page aligned boundaries, but we don't check for
>> this required dependency and values leading to overruns are able to pass
>> through, as explained above.
>
> I don't think the patch you sent had a lot of point: if there is a 
> problem, it extends way beyond just the entry to unmap_vmas(); and
> really it's not the well-established loops we have to worry about,
> it's where people add new ones without thinking about alignment.

The loops might have been there for long but the usage and input is
prone to change.

For example remap_pfn_range is used by drivers and it has the same
alignment requirements.  Perhaps an explicit comment in the kerneldoc?

Iff there is even a problem with all these things, still looking through
callsites, rereading your mails and thinking about it..  Hey, this thing
is big and I try hard to get a clue ;)

> If we put alignment BUG_ONs at the start of every such loop,
> yes, that would help the new ones to follow the same pattern.
> Or if we put alignment VM_BUG_ONs inside p?d_addr_next(), that
> might help too - I say VM_BUG_ONs because we don't really want
> to slow down the usual config, though that would then miss any
> cases of vma corruption in the wild.
>
> But even if we did so, it looks like we go for a long while only
> testing the page-aligned cases anyway (which, barring corruption,
> is always the case coming from vm_start and vm_end: the exceptions
> are things like fault addresses or atypical I/O sizes), which
> would not BUG anyway.  As soon as someone does try the unaligned,
> we veer off to an unbounded loop and hit something nasty quite
> noisily, don't we?

Yeah, I think so.

> I do think there's a message about review and testing here, but
> not a great case for BUGs.  Well, you didn't BUG, you enforced
> alignment; but if the input is wrong, you cannot tell whether
> to round up or round down in there, so better to BUG or WARN.

Agreed.  Well, in the unmap_vmas() case you can not unmap partial pages,
so you would probably be able to guess correct.  But I agree it should
be up to the callsite.

	Hannes
