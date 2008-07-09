Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYGIVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYGIVBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYGIVBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:01:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYGIVBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:01:39 -0400
Date: Wed, 9 Jul 2008 23:01:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709210120.GB4298@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709131405.54f9d49b@infradead.org> <m1y74ax0fi.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y74ax0fi.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Wed, 09 Jul 2008 13:00:19 -0700
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> 
> >> I just took a quick look at how stack_protector works on x86_64.
> >> Unless there is some deep kernel magic that changes the segment
> >> register to %gs from the ABI specified %fs CC_STACKPROTECTOR is
> >> totally broken on x86_64.  We access our pda through %gs.
> >
> > and so does gcc in kernel mode.
> 
> Some gcc's in kernel mode.  The one I tested with doesn't.

yes - stackprotector enabled distros build with kernel mode enabled gcc.

> >> Further -fstack-protector-all only seems to detect against buffer 
> >> overflows and thus corruption of the stack.  Not stack overflows.  
> >> So it doesn't appear especially useful.
> >
> > stopping buffer overflows and other return address corruption is not 
> > useful? Excuse me?
> 
> Stopping buffer overflows and return address corruption is useful.  
> Simply catching and panic'ing the machine when the occur is less 
> useful. [...]

why? I personally prefer an informative panic in an overflow-suspect 
piece of code instead of a guest root on my machine.

I think you miss one of the fundamental security aspects here. The panic 
is not there just to inform the administrator - although it certainly 
has such a role.

It is mainly there to _deter_ attackers from experimenting with certain 
exploits.

For the more sophisticated attackers (not the script kiddies - the ones 
who can do serious economic harm) their exploits and their attack 
vectors are their main assets. They want their exploits to work on the 
next target as well, and they want to be as stealth as possible.

For a script kiddie crashing a box is not a big issue - they work with 
public exploits.

This means that the serious attempts will only use an attack if its 
effects are 100% deterministic - they wont risk something like a 50%/50% 
chance of a crash (or even a 10% chance of a crash). Some of the most 
sophisticated kernel exploits i've seen had like 80% of their code 
complexity in making sure that they dont crash the target box. They were 
more resilient code than a lot of kernel code we have.

> [...] We aren't perfect but we have a pretty good track record of 
> handling this with old fashioned methods.

That's your opinion. A valid counter point is that more layers of 
defense, in a fundamentally fragile area (buffers on the stack, return 
addresses), cannot hurt. If you've got a firewall that is only 10% busy 
even under peak load it's a valid option to spend some CPU cycles on 
preventive measures.

A firewall _itself_ is huge overhead already - so there's absolutely no 
valid technical reason to forbid a firewall from having something like 
stackprotector built into its kernel. (and into most of its userspace) 

We could have caught the vsplice exploit as well with stackprotector - 
but our security QA was not strong enough to keep it from slowly 
regressing. (without anyone noticing) That's fixed now in 
tip/core/stackprotector.

	Ingo
