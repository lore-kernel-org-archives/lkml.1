Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXCAJZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXCAJZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbXCAJZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:25:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXCAJZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:25:43 -0500
Date: Thu, 1 Mar 2007 10:18:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Kevin O'Connor" <kevin@koconnor.net>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Zach Brown <zach.bro@NONE.mta.everyone.net>
Subject: Re: [patch 02/12] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070301091840.GA3313@elte.hu>
References: <20070228213938.GA945@elte.hu> <20070228214117.GB2305@elte.hu> <20070301030533.GA26381@double.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301030533.GA26381@double.lan>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin O'Connor <kevin@koconnor.net> wrote:

> I'd like to propose a simpler userspace API for syslets.  I believe 
> this revised API is just as capable as yours (anything done purely in 
> kernel space with the existing API can also be done with this one).
> 
> An "atom" would look like:
> 
> struct syslet_uatom {
> 	u32		nr;
> 	u64		ret_ptr;
> 	u64		next;
> 	u64		arg_nr;
> 	u64		args[6];
> };
> 
> The sys_nr, ret_ptr, and next fields would be unchanged.  The args 
> array would directly store the arguments to the system call.  To 
> optimize the case where only a few arguments are necessary, an 
> explicit argument count would be set in the arg_nr field.

i dont see the advantage of arg_nr - if the arguments are direct then 
the best way is to just fetch them all, not to do testing upon arg_nr. 
Furthermore, regarding the indirect pointers, they are quite essential 
for some uses, see:

  http://lkml.org/lkml/2007/2/28/292

> Of course, the above lacks the syscall return testing capabilities in 
> your atoms.  To obtain that capability, one could add a new syscall:
> 
> long sys_syslet_helper(long flags, long *ptr, long inc, u64 new_next)

yes. But a 'flags' field is handy anyway, to signal things like 
NOCOMPLETE or SYSLET_SYNC/SYSLET_ASYNC (a flags field is always useful 
in such structures). So the condition testing comes 'for free' in 
essence.

but ... as you can see it with sys_umem_add(), i like the addition of 
helper syscalls - i just think that this particular one wouldnt be too 
helpful.

> I would also change the event ring notification system.  Instead of 
> building that support into all syslets, one could introduce an "add to 
> head" syscall specifically for that purpose.  If done this way, 
> userspace could arrange for this new sys_addtoring call to always be 
> the last uatom executed in a syslet.  This would make the support 
> optional - those userspace applications that prefer to use a futex or 
> signal as an event system could arrange to have those system calls as 
> the last one in the chain instead. [...]

the problem is signals: a syslet has to return to user-space upon 
signals or upon a stop condition. So to notify about the precise place 
of stoppage, the notification ring is a 'built in' property.

(nevertheless, as i mentioned it in a prior mail, i'll create separate 
ring syscalls, because they are useful for other stuff too.)

> For example, the open & stat case could be done with a chain like the 
> following:
> 
> atom1: &atom3->args[1] = sys_open(...)
> atom2: sys_syslet_helper(SYSLET_BRANCH_ON_NON_POSITIVE,
>                          &atom3->args[1], 0, atom4)

i dont see a huge conceptual difference between having the syslet helper 
in flags versus having it in a separate syscall. Other than yours has 
twice the number of atoms.

> It is also possible to use sys_syslet_helper to push a return value to 
> multiple syslet parameters (for example, propagating an fd from open 
> to multiple reads).  For example:
> 
> atom1: &atom3->args[1] = sys_open(...)
> atom2: &atom4->args[1] = sys_syslet_helper(0, &atom3->args[1], 0, 0)
> atom3: sys_read([arg1 filled in atom1], ...)
> atom4: sys_read([arg1 filled in atom2], ...)

try to do this in FIO. You'd have to create many extra atoms to push the 
fd into the argument fields - instead of just sharing the variable. 
Sharing is /good/. These 'simplifications' complicate the whole syslet 
programming model down to being near unusable.

> Although this is a bit ugly, I must wonder how many times one would 
> build chains complex enough to require it.

take a look at FIO.

	Ingo
