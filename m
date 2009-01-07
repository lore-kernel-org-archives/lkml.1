Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZAGUuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZAGUuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZAGUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:50:36 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50412 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbZAGUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:50:35 -0500
Date: Wed, 7 Jan 2009 20:50:30 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Crutcher Dunnavant <crutcher+kernel@datastacks.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sysrq loglevel
Message-ID: <20090107205030.GE12402@shadowen.org>
References: <20090107123725.GC2520@shadowen.org> <20090107112539.972e60e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107112539.972e60e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:25:39AM -0800, Andrew Morton wrote:
> On Wed, 7 Jan 2009 12:37:58 +0000 Andy Whitcroft <apw@canonical.com> wrote:
> 
> > It seems that we deliberatly manage the console_loglevel while handling a
> > sysrq request.  Raising it to 7 to emit the sysrq command header, and then
> > lower it before processing the command itself.  When booting the kernel
> > 'quiet' this means that we only see the header of the command and not its
> > output on the console, the whole thing is in dmesg and thereby in syslog
> > (if it is working).
> 
> I always thought it was fairly stupid.  Wouldn't we get the same effect
> by tossing that code and switching those printks to KERN_EMERG?

I believe it is different as the level is still KERN_INFO and that is
what the consumers of /proc/kmsg will see, and that might affect where
they are logged to.

> > void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
> > [...]
> >         console_loglevel = 7;
> >         printk(KERN_INFO "SysRq : ");
> > [...]
> >                         printk("%s\n", op_p->action_msg);
> >                         console_loglevel = orig_log_level;
> >                         op_p->handler(key, tty);
> > [...]
> > 
> > Is this intentional?  I can see arguments both ways.  One way to look at
> > it would be that I asked for the output so I should get it regardless.
> > The other side might be that consoles can be really slow (serial or
> > something) and so only outputting it there if logging is enabled
> > generally is sane.
> > 
> > Obviously we can work round this at the moment using sysrq-7 to up the
> > loglevel before the command and sysrq-4 after to restore quiet.
> > 
> > What do people think.  If we are happy with the status quo then I will
> > spin a documentation patch to point out this behaviour and the work
> > around.  Else I will happily spin a patch to fix it.
> > 
> 
> There is a legitimate use case, I think: to emit the sysrq command's
> output into the log bufffer and not to the console[s].  So you can do
> 
> 	echo t > /proc/sysrq-trigger
> 	dmesg -s 1000000 > foo

Yeah I agree.  I will spin a documentation patch to capture this
reasoning so we don't end up asking again in a years time.

-apw
