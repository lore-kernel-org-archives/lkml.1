Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab0BDP6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:58:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932878Ab0BDP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:58:49 -0500
Date: Thu, 4 Feb 2010 07:57:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ben Hutchings <ben@decadent.org.uk>
cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable-review@kernel.org
Subject: Re: [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
In-Reply-To: <1265272174.2952.20.camel@localhost>
Message-ID: <alpine.LFD.2.00.1002040749390.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost>  <1265256174.2952.11.camel@localhost>  <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Feb 2010, Ben Hutchings wrote:
> > 
> > So you _should_ have a combination of
> >  - 221af7f87 ("Split 'flush_old_exec' into two functions")
> >  - 05d43ed8a ("x86: get rid of the insane TIF_ABI_PENDING bit")
> >  - 7ab02af42 ("Fix 'flush_old_exec()/setup_new_exec()' split")
> > 
> > (and there are also additional sparc/ppc versions of that TIF_ABI_PENDING 
> > bit removal, but they shouldn't matter on your system)
> 
> Thanks.  If all the necessary patches are all in the stable queue then
> we can pick them from there.

Yeah, they are all there. Please do report if that fixes your 64-bit 
kernel with 32-bit user space issues (I tested that case, but I don't have 
a full 32-bit environment, so I only tested it on a fairly simple 
test-case that showed the pre-patch problem that the series fixes).

Btw, that 221af7f87 commit (even with the fix) is kind of nasty in that it 
changes semantics without then fixing up the users in the same commit. 
Normally we wouldn't accept anything like that, but it was supposed to 
only change semantics for a case that was already broken, and is pretty 
rare (the transition from 32-bit to 64-bit and vice versa).

Splitting them up was supposed to make it clearer what was going on and 
tint he original version the first patch didn't change semantics. And in 
fact, the split-up did indeed then help me chase down the bug that showed 
up on Microblaze, because it broke an architecture that shouldn't have 
been affected at all ;)

But pretty it wasn't. My bad. It would have been much better if we'd have 
fixed this earlier than -rc6, but the bugreport that reported this came in 
around -rc5. Unlucky timing (because the problem has been around for a 
looong time).

		Linus
