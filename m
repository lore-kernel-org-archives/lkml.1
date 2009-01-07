Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbZAGT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbZAGT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbZAGTZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:25:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbZAGTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:25:49 -0500
Date: Wed, 7 Jan 2009 11:25:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Crutcher Dunnavant <crutcher+kernel@datastacks.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sysrq loglevel
Message-Id: <20090107112539.972e60e2.akpm@linux-foundation.org>
In-Reply-To: <20090107123725.GC2520@shadowen.org>
References: <20090107123725.GC2520@shadowen.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 12:37:58 +0000 Andy Whitcroft <apw@canonical.com> wrote:

> It seems that we deliberatly manage the console_loglevel while handling a
> sysrq request.  Raising it to 7 to emit the sysrq command header, and then
> lower it before processing the command itself.  When booting the kernel
> 'quiet' this means that we only see the header of the command and not its
> output on the console, the whole thing is in dmesg and thereby in syslog
> (if it is working).

I always thought it was fairly stupid.  Wouldn't we get the same effect
by tossing that code and switching those printks to KERN_EMERG?

> void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
> [...]
>         console_loglevel = 7;
>         printk(KERN_INFO "SysRq : ");
> [...]
>                         printk("%s\n", op_p->action_msg);
>                         console_loglevel = orig_log_level;
>                         op_p->handler(key, tty);
> [...]
> 
> Is this intentional?  I can see arguments both ways.  One way to look at
> it would be that I asked for the output so I should get it regardless.
> The other side might be that consoles can be really slow (serial or
> something) and so only outputting it there if logging is enabled
> generally is sane.
> 
> Obviously we can work round this at the moment using sysrq-7 to up the
> loglevel before the command and sysrq-4 after to restore quiet.
> 
> What do people think.  If we are happy with the status quo then I will
> spin a documentation patch to point out this behaviour and the work
> around.  Else I will happily spin a patch to fix it.
> 

There is a legitimate use case, I think: to emit the sysrq command's
output into the log bufffer and not to the console[s].  So you can do

	echo t > /proc/sysrq-trigger
	dmesg -s 1000000 > foo


