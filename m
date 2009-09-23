Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZIWCm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZIWCm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZIWCmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZIWCmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:42:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: ptrace: sign-extend eax with orig_eax>=0
In-Reply-To: Linus Torvalds's message of  Tuesday, 22 September 2009 18:31:16 -0700 <alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090923024049.AA85913F37@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 19:40:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. This really smells extremely hacky to me.

Agreed.  Anything with a half-page comment about why it's two-thirds
right and only one-third wrong is not what we'd choose when we could
think of better options.

> I see what you're doing, and I understand why, but it all makes me 
> shudder. I think we already do the wrong thing for 'orig_ax', and that we 
> should probably simply test just the low 32 bits of it (looks to be easily 
> done by just making the return type of 'syscall_get_nr()' be 'int') rather 
> than have that special "let's sign-extend orig_ax" code in ptrace.

Yes, that seems mostly equivalent.  By having orig_ax sign-extended in
ptrace unconditionally (i.e. even for 64-bit tasks), you've already said
that the semantics of orig_ax are that you only get 32 bits of meaningful
value in there.  In fact, that's what you said explicitly when we discussed
that change.  There is no reason for syscall_get_nr() not to return int.

I said "mostly equivalent".  The only difference I can see is that
today 64-bit ptrace callers (and core dumps, etc.), can see the high
bits of orig_ax and probably expect to see 64 1 bits in the "no
syscall" case.  So if we punt all the existing sign-extension and say
that orig_ax has only 32 meaningful bits internally in all uses, then
the ABI-preserving change is to make getreg() always sign-extend the
32-bit orig_ax value so -1 is -1LL in userland.

I wonder if you want to say the same thing about all machines generally,
that the syscall number can only have 32 meaningful bits.  That seems
reasonable to me.  Then it would be appropriate to change the type in
asm-generic/syscall.h; that file is never really used, but it sets the
function signatures that other arch's files are written to match.

> I also get the feeling that the TS_COMPAT testing is just hacky to begin 
> with. I think it was broken to do things that way, and I have this gut 
> feel that we really should have hidden the "am I a 32-bit or 64-bit 
> syscall" in that orig_ax field instead (ie make the 64-bit system calls 
> set a bit or whatever). That's the field we've always used for system call 
> flagging, and TS_COMPAT was broken.

On the whole I agree.  hpa and I talked about this very idea last
year.  We never got around to doing anything about it, since the
previous hack at the time had fixed the known bug.  Doing this
internally is probably pretty easy and is nice for all the other cases
with TS_COMPAT checks now.  Unfortunately, it's a userland ABI issue
to change this such that any new special meaning of some orig_ax bits
can be seen by userland so as to help this latest case.

What hpa and I discussed in fact was more than just a 32/64 flag, but
a complete "which entry path" indicator.  i.e. int80 vs sysenter vs
AMD 32-bit "syscall" (if we ever supported that) vs 64-bit "syscall"
vs non-syscall (exception/interrupt) entries.  That would have a bit
or two of information even for 32-bit.  (We figured that limiting an
actual syscall # to 24 bits or so would be fine.)  But the utility of
distinguishing those paths (aside from 32 vs 64 and syscall vs not) is
purely theoretical, which is to say I don't think we even have any
contrived idea what you'd use it for.

> In this example, the problem for ptrace seems to be that TS_COMPAT ends up 
> being that "extra" bit of information that isn't visible in the register 
> set.

Agreed.  All else being equal, I would prefer to have this bit appear in
the regset layout somewhere.  Unfortunately I don't see how we can both
make userland implicitly win by saving and restoring it blindly, and be
ABI-compatible with existing userland that knows the orig_ax meaning today.

> But that's a bigger separate cleanup. In the meantime, I really get the 
> feeling that your patch is nasty, and could be replaced with something 
> like the following instead.. It just sets the TS_COMPAT bit if we use a 
> 32-bit interface to set the system call number to positive (ie "inside 
> system call").

I think I may have been tempted toward that but didn't really consider it.
The only real reason is that TS_* bits are "thread-synchronous" and I
thought there was no precedent for touching them on any task != current.
(Given I understand how ptrace is the special situation where it could be
safe.)  But, in fact, ptrace can already fiddle TS_USEDFPU.  So it's no
worse than that, anyway.  So it's better than bad, it's good!

> THE BELOW IS TOTALLY UNTESTED! I haven't really thought it through. I just 
> reacted very negatively to your patch, and my gut feel is that the code is 
> fundamentally doing something wrong. The below may not work, and may be 
> seriously broken and miss the point, but I think it conceptually comes 
> closer to how things _should_ work.

I agree.


Thanks,
Roland
