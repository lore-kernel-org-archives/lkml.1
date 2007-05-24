Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXEXTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXEXTtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXEXTtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:49:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41822 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXEXTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:49:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com,
       iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	<20070524102702.bca37396.akpm@linux-foundation.org>
Date: Thu, 24 May 2007 13:42:58 -0600
In-Reply-To: <20070524102702.bca37396.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 24 May 2007 10:27:02 -0700")
Message-ID: <m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 24 May 2007 11:07:56 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
>
>> So I guess I found the answer to my own question. msi_free_irqs was apparently
> added
>> in 2.6.22-something. I don't find it in 2.6.21.2 or anywhere else. So somebody
> broke a
>> couple of things.
>> The most noticable is cciss hangs after turning on interrupts. The reason for
> that is
>> the kernel now looks at my array of MSI-X vectors in reverse order. We have 4
> ways of
>> generating an interrupt on Smart Array hw. They are:
>> 
>> #       define DOORBELL_INT     0
>> #       define PERF_MODE_INT    1
>> #       define SIMPLE_MODE_INT  2
>> #       define MEMQ_MODE_INT    3
>> 
>> For INTx these four lines are OR'ed together and run to one interrupt
> pin. MSI-X
>> breaks this hardware OR'ing so we must register either all 4 or at the least
> the
>> correct interrupt. When I first submitted the MSI/X support I was registering
> all 4.
>> Someone changed that to only register a single MSI-X vector. That worked fine
> until
>> 2.6.22-something. 
>> Now it appears that the kernel is looking at the array in reverse order. IOW,
> I must
>> register PERF_MODE_INT in order for cciss to work. That's messed up. Anybody
> want to
>> `fess up to making these changes? :)
>> I'll keep working this, but I'm going to undo someones change when I figure
> out where
>> it's broke.
>> 
>
> I'd guess that you're referring to Michael's changes.  If you can identify
> the offending code in a less vague fashion, more confident answers can
> be given ;)
>
> I canot find any sign of anyone altering the IRQ handling in cciss.c after
> your initial MSI-support merge.  But that's perhaps isn't what you meant.
> it's all rather foggy.  Please either quote file-n-line, or grab a copy
> of git-blame.

Or perhaps git-bisect to find the offending patch.

I don't recall seeing anything that looked to bad but there was a fair
amount of change needed to get the last bit of portability into the msi
code, so it is possible something slipped through.

Possibly someone changed the default enable or disable state?

....

Which reminds me.  Now that we have a reasonable list, we really need
to reduce pci_enable_msix:

- int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec);
+ int pci_enable_msix(struct pci_dev* dev, int nvec);

And just have drivers that use more the one irq walk the list off of pci_dev
of all of the msi irqs.  I did a little review a while ago and only
0-(nvec -1) are allocated and the are always in order in entries so it
shouldn't be to bad to generate a patch for that case, and not having
to worry about out of order or holes in the irq allocator would be
good.

Eric
