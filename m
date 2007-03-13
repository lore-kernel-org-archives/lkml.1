Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXCMTcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXCMTcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933623AbXCMTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:32:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49381 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbXCMTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:32:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
Date: Tue, 13 Mar 2007 13:31:52 -0600
In-Reply-To: <b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	(Catalin Marinas's message of "Mon, 12 Mar 2007 15:07:39 +0000")
Message-ID: <m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Catalin Marinas" <catalin.marinas@gmail.com> writes:

> On 09/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> If I can manage to focus on this, it looks like the information I need to
>> start fixing this.
>
> I had a look at the second leak reported it seems to be caused by the
> same proc_set_tty() call but, in this case, there is no
> disassociate_tty() call for the task (and the patch I posted is not
> enough). Maybe something like below (no thourough testing):
>
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index db91398..ea6ca7d 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -3854,7 +3854,14 @@ EXPORT_SYMBOL(tty_devnum);
>
> void proc_clear_tty(struct task_struct *p)
> {
> +	struct tty_struct *tty;
> +
> 	spin_lock_irq(&p->sighand->siglock);
> +	tty = p->signal->tty;
> +	if (tty) {
> +		put_pid(tty->session);
> +		put_pid(tty->pgrp);
> +	}
> 	p->signal->tty = NULL;
> 	spin_unlock_irq(&p->sighand->siglock);
> }

This patch can't be right.  Not the way proc_clear_tty is called
once for each process in the session, plus we aren't clearing
tty->session and tty->pgrp here. 

If the above patch works it's a fluke.

Still it is the right general area of the code.  I've just started
looking at this it is going to take me a bit to come up to speed on
this code again and see what silly thing is missing.

Eric
