Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbYKFPBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbYKFPBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYKFPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:01:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:36917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbYKFPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:01:19 -0500
Date: Thu, 6 Nov 2008 07:01:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106070157.065b2dcc@infradead.org>
In-Reply-To: <1225983052.7803.4623.camel@twins>
References: <20081105094902.27ec4b39@infradead.org>
	<1225976138.7803.4485.camel@twins>
	<20081106060624.58a0f967@infradead.org>
	<1225981141.7803.4577.camel@twins>
	<20081106063108.02b4813d@infradead.org>
	<1225983052.7803.4623.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 15:50:52 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-11-06 at 06:31 -0800, Arjan van de Ven wrote:
> > On Thu, 06 Nov 2008 15:19:01 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > a syscall tracer will exactly not tell you which file(name) was
> > > > being fsync()'d which was the whole point.
> > > 
> > > It will tell you the process and the fd, and when you have those
> > > two its a simple step to find the actual file.
> > 
> > actually process+fd is absolutely useless; the typical useage is
> > 
> > fd = open(file)
> > write(fd, <> )
> > fsync(fd);
> > close(fd);
> > 
> > by the time userland gets the data the fd is closed. And heck, even
> > the program may have exited.
> > Really, the fd number is only useful for the program itself, not for
> > any outside part, and especially, later in time.
> 
> The syscall tracer will also have told you about that open.

ok so now you're turning a simple problem into "also track all open,
openat, dup, dup2, close, unix domain fs passing etc". That doesn't
sound like an improvement to me.
And even the "open/fd" family isn't enough, because the open will be
relative pathnames, so I now also need to second guess the PWD, and
then follow a chain of "chdir" calls as well and then resolve the
".."'s in the path. And follow symlinks that may no longer be the same
symlink it used to be. Etc. Etc.

No sorry, this really is not a viable approach.

And that goes beyond the fsync tracer. Anybody who thinks that syscall
tracing is the right approach needs to seriously think about it; it
really looks like the same problem as with audit... it started out with
a bad hack that did it at the syscall level but it was likewise shown
to just not be the right level. I am rather certain that the same will
be shown for tracing.



> 
> Anyway, do_fsync() doesn't catch all sync actions (although I suspect
> it catches most). We still have the mythical sync_file_range() that
> Andrew still wants a real program to use.

a normal sync() I don't need any help for.. it has no filename and I
already know who's calling it with what latency.

> 
> And then there are things like sync and umount that do syncs too. But
> I suspect you might not be interested in those.

I already know all I need about those.... again it's the fsync() that
is specific, and I need to know the specifics to help the user figure
out what is going on.
(and in case you worry that there's not going to be a user for this
tracer, I already wrote the latencytop side of the code for this one, 
so I know I can use the current format)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
