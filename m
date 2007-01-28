Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXA1VfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXA1VfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbXA1VfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:35:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58093 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbXA1VfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:35:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<1170015805.26655.15.camel@localhost.localdomain>
Date: Sun, 28 Jan 2007 14:34:00 -0700
In-Reply-To: <1170015805.26655.15.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Mon, 29 Jan 2007 07:23:25 +1100")
Message-ID: <m164aqq1iv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> The other big change is that I added a field to irq_desc to point
>> at the msi_desc.  This removes the conflicts with the existing pointer
>> fields and makes the irq -> msi_desc mapping useable outside of msi.c
>
> I'm not even sure we would have needed that with Michael's mecanism in
> fact. One other reason why I prefer it.
>
> Basically, backends like MPIC etc... don't need it. The irq chip
> operations are normal MPIC operations and don't need to know they are
> done on an MSI nor what MSI etc... and thus we don't need it. Same with
> RTAS.

If you get rid of the bass ackwards setup_msi_msg operation they do,
so you can support at least one write_msi_msg call.

> On the other hand, x86 needs it, but then, x86 uses it's own MSI
> specific irq_chip, in which case it can use irq_desc->chip_data as long
> as it does it within the backend.

Most of the uses are within msi.c as the code is currently structured
which means you can't use it that way.

> So I may have missed a case where a given backend might need both that
> irq -> msi_desc mapping -and- use irq_desc->chip_data for other things,
> but that's one thing I was hoping we could avoid with Michael's code.

That is where we are today.  Find a way to remove the code that uses it
and it can go away.

>> The only architecture problem that isn't solvable in this context is
>> the problem of supporting the crazy hypervisor on the ppc RTAS, which
>> asks us to drive the hardware but does not give us access to the
>> hardware registers.
>
> So you are saying that we should use your model while admitting that it
> can't solve our problems...

My approach can solve your problems with a few tweaks just like Michaels
approach would have needed to solve mine.

> I really don't understand why you seem so totally opposed to Michael's
> approach which definitely looks to me like the sane thing to do. Note
> that in the end, Michael's approach isn't -that- different from yours,
> just a bit more abstracted.

1) Because every one tells me it is the greatest thing since sliced bread,
   and when I look it simply doesn't work, and my feeling would be it would
   be a complete retesting effort of all currently supported architectures
   to make Michaels code work.

2) Because it was scrap and replace, which is a horrible way to deal with
   a problem when we have 3 architectures working already.

Honestly I think Michael and I can get along but all of the cheer leaders seem
to be exacerbating the situation.

I do agree Michael's approach isn't that different than mine and I think we
can converge on a single implementation.  To a large extent that is what
my patchset is about.  Moving the current code far enough it is usable,
and a reasonable basis for more work.

I don't write the current code but since I touched it and started cleaning
it up I seem to be stuck with it.  So I will be happy to take care of it
until we get a version that all architectures can use.

Eric
