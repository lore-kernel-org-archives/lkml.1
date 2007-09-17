Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXIQXyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXIQXyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 19:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbXIQXyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 19:54:15 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:56721 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbXIQXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 19:54:14 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of free memory leads to NFS hang
References: <874phtkk25.fsf@hades.wkstn.nix>
	<20070917223600.GA30350@fieldses.org>
From: Nix <nix@esperi.org.uk>
Emacs: freely redistributable; void where prohibited by law.
Date: Tue, 18 Sep 2007 00:54:07 +0100
In-Reply-To: <20070917223600.GA30350@fieldses.org> (J. Bruce Fields's message of "Mon, 17 Sep 2007 18:36:00 -0400")
Message-ID: <87zlzkkfvk.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Sep 2007, J. Bruce Fields stated:
> On Mon, Sep 17, 2007 at 11:23:46PM +0100, Nix wrote:
>> A while later we start seeing runs of malloc failures, which I think
>> correlated with the unexplained pauses in NFS response:
>
> Actually, they're nothing to do with malloc failures--the message
> printed here is misleading, and isn't even an error; it gets printed
> whenever an upcall to mountd is made.

Indeed, with more debugging, all the failures I see come from the call
to exp_find(), which is digging out exports...

>                                        The problem is almost certainly a
> problem with kernel<->mountd communication--the kernel depends on mountd
> to answer questions about exported filesystems as part of the fh_verify
> code.

Ah! I keep forgetting that mountd isn't just used at mount time: damned
misleading names, grumble.

Restarting mountd clears the problem up temporarily, so you are
definitely right.

> commit dd087896285da9e160e13ee9f7d75381b67895e3
> Author: J. Bruce Fields <bfields@citi.umich.edu>
> Date:   Thu Jul 26 16:30:46 2007 -0400

Aha! I'm on 3b55934b9baefecee17aefc3ea139e261a4b03b8, over a month older.

>     On a recent Debian/Sid machine, I saw libc retrying stdio writes that
>     returned write errors.

Debian Sid recently upgraded to glibc 2.6.x, as did I... earlier
versions of glibc will have had this behaviour too, but it may have been
less frequent.

>     I don't know whether this libc behavior is correct or expected, but it
>     seems safest to add the __fpurge() (suggested by Neil) to ensure data is
>     thrown away.

It is expected, judging from my reading of the
code. stdio-common/vfprintf.c emits single chars using the outchar()
macro, and strings using the outstring() macro, using functions in libio
to do the job. The string output routine then calls _IO_file_xsputn(),
which, tracing through libio's jump tables and symbol aliases, ends up
calling _IO_new_file_xsputn() in libio/fileops.c. (I've only just
started to understand libio. It's basically undocumented as far as I can
tell, but it's deeply nifty. Think of stdio, only made entirely out of
hookable components. :) )

(Actual writing then thunks down through _IO_new_do_write() and
new_do_write() in the same file, which finally calls __write().  If
there's any kind of error this returns EOF after some opaque messing
about with a _cur_column value, which is as far as I can tell never
used!)

The code which calls new_do_write() looks like this:

,----[ libio/fileops.c:_IO_new_file_xsputn() ]
|  if (do_write)
|    {
|      count = new_do_write (f, s, do_write);
|      to_do -= count;
|      if (count < do_write)
|        return n - to_do;
|    }
`----

This code handles partial writes followed by errors by returning a
suitable nonzero value, and immediate errors by returning -1.

In either case the buffer will have been filled as much as possible by
that point, and will still be filled when (vf)printf() is next called.


This behaviour is, IIRC, mandated by the C Standard: I can find no
reference in the Standard to streams being flushed on error, only
on fclose(), fflush(), or program termination.


I'm upgrading now: thank you!

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
