Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZDMWfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZDMWfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZDMWfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:35:32 -0400
Received: from thunk.org ([69.25.196.29]:59309 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZDMWfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:35:32 -0400
Date: Mon, 13 Apr 2009 18:35:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090413223526.GB32182@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu> <20090412130105.GB20281@elte.hu> <20090412172344.GC10547@mit.edu> <20090413213124.GB8514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413213124.GB8514@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 11:31:24PM +0200, Ingo Molnar wrote:
> Cool. [ And i guess you'll like the per tracepoint filter 
> expressions too :-) ]

I haven't played with them yet, but I was looking over the source code
at them (since they aren't documented yet :-).  It looks like at the
moment only integer matches are allowed, right?  That's a bit of an
issue for me, since one of the things I'd really like to be able to do
is filter based on devname (i.e., sda2).  (Most of the time we only
want to collect information for a particular block device or
filesystem.)

Actually, the fact that I'm having to drop some 32 bytes for each jbd2
and ext4 trace log for the bdevname in the ring buffer is really for
the birds.  What I really want to do is just to drop in the dev_t, and
then for the tracing infrastructure to have an efficient (cached) way
of taking the dev_t and turning that back into struct block_device at
TP_printk time so we can print the bdevname when it's needed.  We
deifnitely don't want to be calling bdget() in fs/block_dev.c each
time we print a line in the tracing buffer!  I'm guessing that's
something the blktrace tracer would find handy as well.

Of course having more kernel code play with dev_t's directly isn't
considered politically correct in some circles, but tough.  :-)  We
can't exactly drop a pointer to a struct block_device in the trace
buffer, since there's no guarantee it will still be valid when we read
it out.  Dropping in a dev_t is exactly what we want.  It would be
nice though if there was a way to specify a major/minor number as the
filter predicate for the dev_t, and not to have the user generate the
MAJOR/MINOR encoding.  So some way of parsing "MKDEV(8, 4)" as the
input to the filter predicate would probably be a really good thing to
do.

						- Ted
