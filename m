Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYBJTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYBJTrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYBJTrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:47:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbYBJTrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:47:23 -0500
Date: Sun, 10 Feb 2008 11:44:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Ray Lee <ray-lk@madrabbit.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
In-Reply-To: <47AF483E.10905@web.de>
Message-ID: <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org>
References: <20080210071304.GA3788@elte.hu>  <20080210104709.GB10790@uranus.ravnborg.org>  <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Feb 2008, Jan Kiszka wrote:
>
> +static int kgdb_get_mem(char *addr, unsigned char *buf, int count)
>  {
> +	if ((unsigned long)addr < TASK_SIZE)
> +		return -EFAULT;
>  
> +	return probe_kernel_read(buf, addr, count);
>  }

Ok, so this is a pretty function after all the cleanups, but I actually 
don't think that "if ((unsigned long)addr < TASK_SIZE)" is really even 
asked for.

Why not let kgdb look at user memory? I'd argue that in a lot of cases, it 
might be quite nice to do, to see what user arguments in memory are etc 
etc (think things like futexes, where user memory contents really do 
matter).

So I'd suggest getting rid of the whole "kgdb_{get|set}_mem()" functions, 
and just using "probe_kernel_{read|write}()" directly instead.

(Not that I necessarily love those names either, but whatever..)

The TASK_SIZE checks make more sense in kgdb_validate_break_address() and 
friends, where it actually does make sense to check that it's really a 
*kernel* address.

But even there, I'm not sure if the right check is to compare against 
TASK_SIZE, since kernel and user memory addresses can in theory be 
distinct (that's why we have "set_fs()" historically, and while it's no 
longer true on x86 and hasn't been in a long time, the kernel conceptually 
allows it - see my previous reply about that whole get_fs/set_fs thing in 
the definition of probe_kernel_read/write).

> +	if (count == 2 && ((long)mem & 1) == 0)
> +		err = probe_kernel_read(tmp, mem, 2);
> +	else if (count == 4 && ((long)mem & 3) == 0)
> +		err = probe_kernel_read(tmp, mem, 4);
> +	else if (count == 8 && ((long)mem & 7) == 0)
> +		err = probe_kernel_read(tmp, mem, 8);
> +	else
> +		err = probe_kernel_read(tmp, mem, count);

There's absolutely no reason to care about the alignment, since if you now 
use "probe_kernel_read()", the sane thing to do is to just do

	err = probe_kernel_read(tmp, mem, count);
	if (!err) {
		while (count > 0) {
			buf = pack_hex_byte(buf, *tmp);
			tmp++;
			count--;
	}

and you're all done. No?

		Linus
