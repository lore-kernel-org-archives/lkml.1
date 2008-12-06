Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYLFIar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYLFIar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 03:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLFIag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 03:30:36 -0500
Received: from vps1.tull.net ([66.180.172.116]:60895 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750779AbYLFIaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 03:30:35 -0500
Date: Sat, 6 Dec 2008 19:30:30 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
Message-ID: <20081206083030.GF5957@mail.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081205232016.366765e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205232016.366765e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 11:20:16PM -0800, Andrew Morton wrote:
> On Sat, 06 Dec 2008 17:59:22 +1100 Nick Andrew <nick@nick-andrew.net> wrote:
> 
> > REQUEST FOR COMMENTS ...
> > 
> > Here is a set of two patches + a demo patch to enable recursive processing
> > of a printf format string in vsnprintf(), which is used by printk().

> > (using 256 bytes of stack) and drivers/scsi/arm/fas216.c
> > 
> > fas216_do_log(FAS216_Info *info, char target, char *fmt, va_list ap)
> > {
> >         static char buf[1024];
> > 
> >         vsnprintf(buf, sizeof(buf), fmt, ap);
> >         printk("scsi%d.%c: %s", info->host->host_no, target, buf);
> > }
> > 
> > (using 1024 bytes of stack)
> 
> Look closer.  It uses no stack, but is racy.

Ok, static. And that's 1024 bytes you won't get back, unless you
apply Matt Mackall's patch which changes the function to this:

static void
fas216_do_log(FAS216_Info *info, char target, char *fmt, va_list ap)
{
        printk("scsi%d.%c: ", info->host->host_no, target, buf);
        vprintk(fmt, ap);
}

(looks like he made a mistake in that one)

which allows a race condition on the kernel log, and then you apply
my patch, to get this:


static void
fas216_do_log(FAS216_Info *info, char target, char *fmt, va_list ap)
{
        printk("scsi%d.%c: %v", info->host->host_no, target, fmt, ap);
}


> Tejun had a thing a while ago which was kinda intended to solve the
> same problem.  iirc his approach added a lot more code (bad), but
> didn't go and add strange new semantics to printk.

I'm not trying to solve a huge problem (e.g. as Jason Baron's dynamic
debug does), just a small problem. Why do tasks have to choose
between double-buffering their messages and making multiple calls
to printk?

I was really pleased to discover that the processing of multiple
format strings could be performed in the _same_ buffer, so
the cost for doing so reduces to a couple of stack vars.

Subsystems seem to like putting functions in front of printk()
to prepend or append output. Matt Mackall found 27 functions
which look to be doing just that. My patch makes those functions
cleaner, and it might be usable to give more subsystems a
message prefix defined in one place, rather than repeated in
each call to printk().

> Is this really a big enough problem to justify the effort?

Seeing kernel messages corrupted like this really annoys me:

	checking if image is initramfs...<6>Switched to high resolution mode on CPU 0
	it is

I don't know if logcheck is figuring out that that first line is
actually two independent kernel messages.

> We have a lot of trouble educating developers about core kernel
> infrastructure, particularly new stuff.

There's Documentation/printk-formats.txt at least. If any change
gets committed, I expect that file to be updated accordingly.

> Many, perhaps most developers
> will still go off and cheerily do local hacks.  These go into the tree,
> because the people who merge that code _do_ know about the
> infrastructure, but they just merge stuff without looking at it.
> 
> IOW, for this to be halfway as useful as you expect, we need a
> look-out-for-local-printk-hacks maintainer.

If my patch makes it in, it will be followed by fixes to all
those local hacks. We might discover some common element so they
can be made non-local. Once a better way to interface to printk
becomes prevalent, it will probably be reused. And if it's not,
then it affects only the one subsystem.

Nick.
