Return-Path: <linux-kernel-owner+w=401wt.eu-S1945920AbXBPPYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945920AbXBPPYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945916AbXBPPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:24:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47556 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945911AbXBPPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:24:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<20070216124117.GB4218@elte.hu>
Date: Fri, 16 Feb 2007 08:23:18 -0700
In-Reply-To: <20070216124117.GB4218@elte.hu> (Ingo Molnar's message of "Fri,
	16 Feb 2007 13:41:17 +0100")
Message-ID: <m1bqjudt3t.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> So I propose we remove all assumptions from the code that we actually 
>> have an array of irqs.  That will allow for irq_desc to be dynamically 
>> allocated instead of statically allocated saving memory and reducing 
>> kernel complexity.
>
> hm. I'd suggest to do this without changing request_irq() - and then we 
> could avoid the 'massive, every driver affected' change, right?

It is a different aspect of the problem.  But we have significant
problematic inconsistencies in what drivers are doing.  I know at
least one driver put an irq into an unsigned char, and passed it
to user space that way.

So I think the driver change is very much worth doing because a
pointer is a token that is much harder to abuse, than an unsigned
int where you think you know how it works and so can take some
liberties.

> i.e. because we'll (have to) have an nr_to_desc() and desc_to_nr() 
> mapping facility anyway, lets just not change the driver APIs massively. 
> There dont seem to be that many drivers that assume that irq_desc[] is 
> an array - are there?

We will have to have desc_to_nr().  I don't know about nr_to_desc().
Even if we do nr_to_desc() probably will just be a linked list walk.

There are a lot of drivers and other pieces of the kernel that don't
believe an irq is an unsigned int, and just using an unsigned int
makes killing the array an expensive operation because operations
go from O(1) to O(N).  Now that isn't something anyone on a small
machine is likely to care about (N < 32).  I have no problem
staggering the change.   But I see a lot of benefit in going the whole
way.

> otherwise, in terms of the irqchips infrastructure and the API between 
> genirq and the irqchip arch-level drivers, this change makes quite a bit 
> of sense i think.

Sounds good, and that is certainly the level to start.

Eric



