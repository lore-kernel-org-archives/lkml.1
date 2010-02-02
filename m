Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0BBPvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:51:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab0BBPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:51:05 -0500
Date: Tue, 2 Feb 2010 07:50:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michal Simek <michal.simek@petalogix.com>
cc: LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions -
 221af7f87b97431e3ee21ce4b0e77d5411cf1549
In-Reply-To: <4B67FB74.4030409@petalogix.com>
Message-ID: <alpine.LFD.2.00.1002020726290.3664@localhost.localdomain>
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B67FB74.4030409@petalogix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Michal Simek wrote:
> 
> Would it be possible to cc me or send that patches to linux-next? I am doing
> every day tests and report results on my site. I would be able to catch up
> bugs earlier.

Normally, that would happen, but this patch got applied early _literally_ 
because I wanted it to hit -rc6 rather than wait any longer. So it had 
only a day or two of discussion, and probably just a few hours from the 
final version.

That said, I think I may have found the cause.

Peter: look at setup_new_exec(), and realize that it got moved _down_ to 
after all the personality setting. So far, so good, that was the 
intention, but look at what it does:

	current->flags &= ~PF_RANDOMIZE;

and look at how fs/binfmt_elf.c does it not just after the personality 
setting, but also after

	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
		current->flags |= PF_RANDOMIZE;

so it looks like you may have moved it down too much.

I think you did that because you wanted to do that

	arch_pick_mmap_layout(current->mm);

in setup_new_exec(). Which makes total sense, but it all means that the 
whole preparatory patch did way more than my initial one (which put 
setup_new_exec() right after flush_old_exec())

In fact, it looks like PF_RANDOMIZE never gets set with the new code, but 
I didn't check if it might not happen somewhere else.

But while I doubt that clearing PF_RANDOMIZE will break anything, the 
movement also affects other thigns. Lookie here:

        if (elf_read_implies_exec(loc->elf_ex, executable_stack))
                current->personality |= READ_IMPLIES_EXEC;

also happens before setup_new_exec(), and then setup_new_exec() does

	current->personality &= ~bprm->per_clear;

where that per_clear mask may be PER_CLEAR_ON_SETID. Which contains 
READ_IMPLIES_EXEC.

So we now always clear READ_IMPLIES_EXEC for setuid applications.

Anyway, I'm not sure this is it, but that's two examples of something that 
did change unintentionally. 

Michael, mind trying this (UNTESTED!) patch? It makes conceptual sense, 
and moves some more of the flushing of the old process state up to 
"flush_old_exec()" rather than doing it late in "setup_new_exec()".

(I suspect we should also move the signal/fd flushing there, but I doubt 
it matters)

		Linus

---
 fs/exec.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 675c3f4..0790a10 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -961,6 +961,11 @@ int flush_old_exec(struct linux_binprm * bprm)
 		goto out;
 
 	bprm->mm = NULL;		/* We're using it now */
+
+	current->flags &= ~PF_RANDOMIZE;
+	flush_thread();
+	current->personality &= ~bprm->per_clear;
+
 	return 0;
 
 out:
@@ -997,9 +1002,6 @@ void setup_new_exec(struct linux_binprm * bprm)
 	tcomm[i] = '\0';
 	set_task_comm(current, tcomm);
 
-	current->flags &= ~PF_RANDOMIZE;
-	flush_thread();
-
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
 	 * some architectures like powerpc
@@ -1015,8 +1017,6 @@ void setup_new_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
-	current->personality &= ~bprm->per_clear;
-
 	/*
 	 * Flush performance counters when crossing a
 	 * security domain:
