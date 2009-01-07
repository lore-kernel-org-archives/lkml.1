Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbZAGVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbZAGVc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZAGVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:32:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41272 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZAGVco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:32:44 -0500
Date: Wed, 7 Jan 2009 22:32:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Message-ID: <20090107213222.GE4597@elte.hu>
References: <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 7 Jan 2009, Matthew Wilcox wrote:
> > 
> > I appreciate this is sample code, but using __get_user() on
> > non-userspace pointers messes up architectures which have separate
> > user/kernel spaces (eg the old 4G/4G split for x86-32).  Do we have an
> > appropriate function for kernel space pointers?  Is this a good reason
> > to add one?
> 
> Yes, you're right. 
> 
> We could do the whole "oldfs = get_fs(); set_fs(KERNEL_DS); .. 
> set_fs(oldfs);" crud, but it would probably be better to just add an 
> architected accessor. Especially since it's going to generally just be a
> 
> 	#define get_kernel_careful(val,p) __get_user(val,p)
> 
> for most architectures.
> 
> We've needed that before (and yes, we've simply mis-used __get_user() on 
> x86 before rather than add it).

for the oldfs stuff we already have probe_kernel_read(). OTOH, that 
involves pagefault_disable() which is an atomic op, so 
__get_user_careful() should be much more lightweight - and we already know 
that the memory range at least _used to_ be a valid kernel address.

(Theoretical race: with memory hotplug that kernel pointer address could 
have gotten unmapped and we could get device memory there - with 
side-effects if accessed. Wont happen in practice.)

	Ingo
