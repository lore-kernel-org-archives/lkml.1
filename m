Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXDDRXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXDDRXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXDDRXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:23:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55818 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXDDRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:23:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Natalie Protasevich <nataliep@google.com>, Andi Kleen <ak@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       auke-jan.h.kok@intel.com
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz>
	<46126EAA.3050000@intel.com>
	<Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz>
	<46128C92.2020908@intel.com>
	<Pine.LNX.4.64.0704031940080.28249@twin.jikos.cz>
	<Pine.LNX.4.64.0704041748330.28249@twin.jikos.cz>
Date: Wed, 04 Apr 2007 11:22:21 -0600
In-Reply-To: <Pine.LNX.4.64.0704041748330.28249@twin.jikos.cz> (Jiri Kosina's
	message of "Wed, 4 Apr 2007 18:10:02 +0200 (CEST)")
Message-ID: <m1r6r0awc2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jikos@jikos.cz> writes:

> On Tue, 3 Apr 2007, Jiri Kosina wrote:
>
>> > we're also having problems reproducing it on that same combination 
>> > (2.6.21-rc4 + my tree), so it points to something in -mm. Since your 
>> > trace is completely different right now it looks like something else 
>> > is fuzzing it up. Since the e1000 changes are in rc5-mm3 as well, that 
>> > might help to narrow it down quickly.
>> I don't know (yet) whether rc5-mm3 was OK in this respect, I didn't boot 
>> it on this machine. I only know that both rc5 and rc5 + e1000 tree are 
>> OK, but rc5-mm4 panics on ifconfig/dhclient on e1000 card immediately on 
>> my system.
>> I will start bisection when I get back to the respective machine 
>> (tomorrow) and will let you know.
>
> And the bisection winner is
>
> 	i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch
>
> I don't immediately see how it could be causing it, so adding CCs which 
> are listed in the patch.

Weird.  I will have to look at that in a little more detail.

Do you know if this problem happens on x86_64?
What does your .config look like?
What does /proc/interrupts look like?
What kind of hardware you running this kernel on?
Can anyone else reproduce this?

The oops clearly shows something using -1 and calling that as an
address I don't know why, but I'm guessing I have triggered a memory
stomp somewhere.  I think this is the first time I have seen a small
negative number causing a NULL pointer dereference.

That patch looks innocuous enough that either:
- I just missed changing something I should have.
- Your configuration has an increase in NR_IRQS and that triggered
  something.
- The patch simply permuted things so a memory stomp now happens
  on the e1000 data structures instead of somewhere else.
- Something doesn't like large irq numbers.

This work is essentially a backport from x86_64 so if your hardware
is 64bit capable testing that should be a fairly easy test, and be
able to rule out large irq numbers as the culprit.

Until I get a good look at -mm I'm going to have a hard time guessing.
But a roving memory stomp is my best guess.


Eric
