Return-Path: <linux-kernel-owner+w=401wt.eu-S1767367AbXCIQoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767367AbXCIQoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767387AbXCIQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:44:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:4670 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767367AbXCIQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XjkeB2IBq2gE5VwCXaxKK+jya01sWRNKE77H9ymcsQVPcUhcC931O74k4mwypDE4gyrTn0mRcb0Er9Ef6hWwvM2VpFXknIF4qtHib5MnDo2haBF1rhF01zAIr9W/xxuZroryoEhN3xSSyqmPnl3YnTwaYU1MgjkzntEf4IdpnAc=
Message-ID: <b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
Date: Fri, 9 Mar 2007 16:44:41 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

For a longer explanation, see the second part of this e-mail. In
short, the patch below seems to fix this particular leak. I'm not sure
that's the correct/complete fix as I seem to still get a 2nd report.
Any info is welcomed.

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e453268..4e33dc2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1375,6 +1375,9 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	read_unlock(&tasklist_lock);

+	put_pid(tty->session);
+	put_pid(tty->pgrp);
+
 	tty->flags = 0;
 	tty->session = NULL;
 	tty->pgrp = NULL;

On 08/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
> > The /sbin/init application calls sys_clone() a few times but only one
> > leak is reported (see below). Looking at the reported pid object (at
> > 0xc7c14500), count is 2 and nr is 296 but no process with pid 296
> > exists any more.
[...]
> > unreferenced object 0xc7c14500 (size 36):
> >  comm "init", pid 245, jiffies 4294939289
> >  backtrace:
> >    [<c0070c18>] kmem_cache_alloc
> >    [<c003a528>] alloc_pid
> >    [<c0026468>] do_fork
> >    [<c00153b0>] sys_clone
> >    [<c0010f80>] ret_fast_syscall
>
> I think this is the path that all pid structures come from so
> unfortunately that doesn't help tracing this problem down.

No, indeed, but that's the only thing kmemleak can report. Anyway, I
got some more information now, after adding several printk's:

The difference from other pid objects is that this one (with nr 296)
is passed as a parameter to proc_set_tty(). The __proc_set_tty()
function increments the pid->count twice via get_pid(), and, with two
other get_pid calls, the pid->count for this object gets to 5 (1 being
the initial value). The prints below are function name, struct pid
address (different from the runs yesterday though), pid->nr and
pid->count (after get_pid incrementing). It also show the return
address and symbol (the calling function):

  alloc_pid: c7c149d8, 296, 1
  get_pid: c7c149d8, 296, 2
    return: c0122d64 (proc_set_tty+0x34/0x54)
  get_pid: c7c149d8, 296, 3
    return: c0122d64 (proc_set_tty+0x34/0x54)
  get_pid: c7c149d8, 296, 4
    return: c002b328 (do_exit+0x2e4/0x7f8) - this is actually the get_pid
      in disassociate_ctty but it is reported like this because of get_pid
      inlining
  get_pid: c7c149d8, 296, 5
    return: c0124a0c (tty_vhangup+0x14/0x18)

On the exit path (see below), however, put_pid is called twice before
free_pid and once via release_task -> detach_pid -> free_pid -> ... ->
__rcu_process_callbacks -> delayed_put_pid -> put_pid. Note that
free_pid is called with pid->nr == 3 and the last put_pid gets called
with nr == 3 as well (but it decrements it to 2 and that's what I find
at that memory location). In the trace below, the pid->count is
printed before put_pid modifies it:

  put_pid: c7c149d8, 296, 5
    return: c0124b5c (disassociate_ctty+0x14c/0x230)
  put_pid: c7c149d8, 296, 4
    return: c0124ba8 (disassociate_ctty+0x198/0x230)
  detach_pid: c7c149d8, 296, 3
    return: c002a230 (release_task+0x1c0/0x358)
  detach_pid: c7c149d8, 296, 3
    return: c002a248 (release_task+0x1d8/0x358)
  detach_pid: c7c149d8, 296, 3
    return: c002a254 (release_task+0x1e4/0x358)
  free_pid: c7c149d8, 296, 3
    return: c003a990 (detach_pid+0xac/0xc8)
  ...
  delayed_put_pid: c7c149d8, 296, 3
    return: c003af68 (__rcu_process_callbacks+0x19c/0x25c)
  put_pid: c7c149d8, 296, 3
    return: c003a8cc (delayed_put_pid+0x54/0x6c)

In the above disassociate_ctty() function the code below (line 1542)
doesn't seem to get called:

	tty = get_current_tty();
	if (tty) {
		put_pid(tty->session);
		put_pid(tty->pgrp);
		tty->session = NULL;
		tty->pgrp = NULL;
	} else {

and I get the following error if TTY_DEBUG_HANGUP is defined - "error
attempted to write to tty [0x00000000] = NULL".

It looks like the tty_vhangup() call in in disassociate_ctty() sets
current->signal->tty to NULL in the do_each_pid_task loop in
do_tty_hangup (p->signal->tty = NULL). The second call to
get_current_tty() in disassociate_ctty() return NULL and therefore no
put_pid on tty->session and tty->pgrp (which are also set to NULL in
the previous function).

Regards.

-- 
Catalin
