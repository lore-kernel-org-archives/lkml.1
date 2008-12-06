Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYLFHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYLFHUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYLFHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:20:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYLFHUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:20:32 -0500
Date: Fri, 5 Dec 2008 23:20:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
Message-Id: <20081205232016.366765e2.akpm@linux-foundation.org>
In-Reply-To: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Dec 2008 17:59:22 +1100 Nick Andrew <nick@nick-andrew.net> wrote:

> REQUEST FOR COMMENTS ...
> 
> Here is a set of two patches + a demo patch to enable recursive processing
> of a printf format string in vsnprintf(), which is used by printk().
> 
> Specifically, when called like this:
> 
>     printk(KERN_INFO "He said: %v, and I said: %s\n", fmt, args, "no");

Yeah, there's no way to shut gcc up.  You'll have to use %p.

> the format string 'fmt' will be processed using the supplied args ('args'
> is a va_list) and the resulting string will be 1 kernel message.
> 
> This is useful in functions which sit between kernel code and printk and
> prepend or append to a kernel message. For example, from sound/core/misc.c
> 
> void snd_verbose_printk(const char *file, int line, const char *format, ...)
> {
>         va_list args;
> 
>         if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
>                 char tmp[] = "<0>";
>                 tmp[1] = format[1];
>                 printk("%sALSA %s:%d: ", tmp, file, line);
>                 format += 3;

That's racy.  Two threads can fight over tmp[1].  It should do:

		printk("<%c>ALSA %s:%d: ", format[1], tmp, file, line);

(I didn't know that you can even modify literal strings - shouldn't
they be in read-only storage?)

>         } else {
>                 printk("ALSA %s:%d: ", file, line);
>         }
>         va_start(args, format);
>         vprintk(format, args);
>         va_end(args);
> }
> 
> Making 2 calls to printk for a single output line is undesirable
> because the output is only guaranteed to be contiguous within a
> single call to printk. Other code works around this by pre-processing
> the format string into its own buffer, like drivers/cpufreq/cpufreq.c
> 
> void cpufreq_debug_printk(unsigned int type, const char *prefix,
>                         const char *fmt, ...)
> {
>         char s[256];
>         va_list args;
>         unsigned int len;
>         unsigned long flags;
> 
>         WARN_ON(!prefix);
>         if (type & debug) {
>                 spin_lock_irqsave(&disable_ratelimit_lock, flags);
>                 if (!disable_ratelimit && debug_ratelimit
>                                         && !printk_ratelimit()) {
>                         spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
>                         return;
>                 }
>                 spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
> 
>                 len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
> 
>                 va_start(args, fmt);
>                 len += vsnprintf(&s[len], (256 - len), fmt, args);
>                 va_end(args);
> 
>                 printk(s);
> 
>                 WARN_ON(len < 5);
>         }
> }
> 
> (using 256 bytes of stack) and drivers/scsi/arm/fas216.c
> 
> fas216_do_log(FAS216_Info *info, char target, char *fmt, va_list ap)
> {
>         static char buf[1024];
> 
>         vsnprintf(buf, sizeof(buf), fmt, ap);
>         printk("scsi%d.%c: %s", info->host->host_no, target, buf);
> }
> 
> (using 1024 bytes of stack)

Look closer.  It uses no stack, but is racy.

> and then issuing a single call to printk at
> the end. On 4th December Matt Mackall posted a patch to the list which
> essentially changed functions like the latter two into a type which
> calls printk (or vprintk) 2 or 3 times.
> 
> I propose doing away with 2-and-3-printk code by enabling printk's
> formatting function (vsnprintf) to process format strings with a '%'
> directive (%v at the moment). When processing a format string, if %v
> is seen then two arguments will be retrieved: the sub-format and
> va_list args. These are used to recurse back into the processing
> function, process that format and arguments, and return to the
> original format string and continue to process it and its arguments.
> With recursion all the formatting is done into the same buffer
> (i.e. 1024 byte printk_buf in kernel/printk.c) saving stack space
> and eliminating double-handling of the formatted strings.
> 
> I'm looking for feedback on this method.
> 
> The first patch prepares vsnprintf() by splitting it into two functions;
> the inner function is suitable for recursion. The inner function needs
> to know buf (start of buffer), str (current position within buffer)
> and end (first character beyond end of buffer) at all times. 'buf'
> is there because it has to be able to process a %n directive, which
> requires calculation of the total number of characters (potentially)
> written. The function also needs to be able to recurse into formats
> which can't be expanded because they are beyond the end of the buffer,
> because it needs to return the total number of characters which 'would
> be' written, even if it can't write them.
> 
> The second patch adds the recursion on '%v', it's very simple.
> 
> The third patch is a sample net_printk() function which shows the
> recursion working on a handful of messages from net/socket.c ...
> 
> void net_printk(char *level, char *fmt, ...) {
>    va_list ap;
>    va_start(ap, fmt);
> 
>    printk("%sNET: %v\n", level, fmt, ap);
>    va_end(ap);
> }
> 
> The only problem I've come up against so far is that actually using
> '%v' causes gcc to warn thusly:
> 
> net/socket.c: In function ___net_printk___:
> net/socket.c:183: warning: unknown conversion type character ___v___ in format
> net/socket.c:183: warning: too many arguments for format
> 
> I haven't been able to find any way to tell gcc that '%v' is actually
> alright and the alternative is to turn off printf format/argument
> checking which is also not desirable.
> 
> To keep gcc quiet, the problem can be hacked around with another extension
> to '%p', however 2 arguments must be taken so the specifier would look
> like one of these:
> 
> %pV%s       ... printk("%s: %pV%s\n", "NET", args, fmt);
> 
> %s%pV       ... printk("%s: %s%pV\n", "NET", fmt, args);
> 
> The former one is easier to parse because it won't upset %s parsing
> but the arguments look bad. I prefer to see fmt first.
> 
> Comments please,
> Nick.
> 
>  lib/vsprintf.c |  114 +++++++++++++++++++++++++++++++++++++++-----------------
>  net/socket.c   |   27 ++++++++++---

mutter.

Tejun had a thing a while ago which was kinda intended to solve the
same problem.  iirc his approach added a lot more code (bad), but
didn't go and add strange new semantics to printk.

Is this really a big enough problem to justify the effort?

We have a lot of trouble educating developers about core kernel
infrastructure, particularly new stuff.  Many, perhaps most developers
will still go off and cheerily do local hacks.  These go into the tree,
because the people who merge that code _do_ know about the
infrastructure, but they just merge stuff without looking at it.

IOW, for this to be halfway as useful as you expect, we need a
look-out-for-local-printk-hacks maintainer.

