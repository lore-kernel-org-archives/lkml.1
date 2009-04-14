Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZDNFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZDNFXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZDNFXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:23:04 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:49855 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZDNFXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TEqiOldndl4v6VQDmWVhx9TUsd0OBqzKMCbK8zSPO4p4t/873yq/wUnuBPcRqsLxNZ
         hAMscdacUjgNg7v6bOORE3GMfBAgJsLVxmQYLNuzlP32gw6vhDO0oRBsWrckzf1nLbDo
         leYFkIt5v5QH5m7F0bHPVuczPidt9d/+7wEBs=
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090413225542.GJ8514@elte.hu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu>
	 <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu>
	 <20090412130105.GB20281@elte.hu> <20090412172344.GC10547@mit.edu>
	 <20090413213124.GB8514@elte.hu> <20090413223526.GB32182@mit.edu>
	 <20090413225542.GJ8514@elte.hu>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 00:22:59 -0500
Message-Id: <1239686579.7011.116.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 00:55 +0200, Ingo Molnar wrote:
> * Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Mon, Apr 13, 2009 at 11:31:24PM +0200, Ingo Molnar wrote:
> > > Cool. [ And i guess you'll like the per tracepoint filter 
> > > expressions too :-) ]
> > 
> > I haven't played with them yet, but I was looking over the source 
> > code at them (since they aren't documented yet :-).  It looks like 
> > at the moment only integer matches are allowed, right?  That's a 
> > bit of an issue for me, since one of the things I'd really like to 
> > be able to do is filter based on devname (i.e., sda2).  (Most of 
> > the time we only want to collect information for a particular 
> > block device or filesystem.)
> 
> You can already do:
> 
>  aldebaran:/debug/tracing/events/sched/sched_process_wait> echo "comm == Xorg" > filter 
>  aldebaran:/debug/tracing/events/sched/sched_process_wait> cat filter 
>  comm == Xorg
> 
> But string values depends on the type of the format field - so you 
> cannot do string matches on integer fields.
> 
> For kdev_t matches i think we'll need native support for that type - 
> in addition to the integer/string types. It will come up in other 
> places as well and user-space knows about devices as well.
> 
> > Actually, the fact that I'm having to drop some 32 bytes for each 
> > jbd2 and ext4 trace log for the bdevname in the ring buffer is 
> > really for the birds.  What I really want to do is just to drop in 
> > the dev_t, and then for the tracing infrastructure to have an 
> > efficient (cached) way of taking the dev_t and turning that back 
> > into struct block_device at TP_printk time so we can print the 
> > bdevname when it's needed.  We deifnitely don't want to be calling 
> > bdget() in fs/block_dev.c each time we print a line in the tracing 
> > buffer!  I'm guessing that's something the blktrace tracer would 
> > find handy as well.
> 
> Yeah.
> 
> It could be worked around right now by converting it to an integer 
> but i think what we want is native support for kdev_t, together with 
> all the usual convenience forms of specifying it: sda1 should work 
> the same way as 8:1 or 0801. Even /dev/sda1 should be recognized in 
> a filter expression.
> 

Yeah, I'll make sure the new filter parser can handle all these forms,
but hopefully in a general way that would allow different forms to be
used as predicate values for any special type such as kdev_t.  Maybe a
simple expression matcher that when setting up the filter would map the
matched value expression to some code that would generate the final
filter value to be used in the run-time filter.

Tom

> > Of course having more kernel code play with dev_t's directly isn't 
> > considered politically correct in some circles, but tough.  :-) We 
> > can't exactly drop a pointer to a struct block_device in the trace 
> > buffer, since there's no guarantee it will still be valid when we 
> > read it out.  Dropping in a dev_t is exactly what we want.  It 
> > would be nice though if there was a way to specify a major/minor 
> > number as the filter predicate for the dev_t, and not to have the 
> > user generate the MAJOR/MINOR encoding.  So some way of parsing 
> > "MKDEV(8, 4)" as the input to the filter predicate would probably 
> > be a really good thing to do.
> 
> Yeah, exactly. We already have smarts in init/* to recognize certain 
> device string patterns (for rootdev specification) - that could be 
> factored out (it already is to a large degree) and reused. We dont 
> need full udev enumeration really - we just need the most common 
> variants.
> 
> Regardless of whether it's considered politically correct or not ;-) 
> It's clearly useful.
> 
> 	Ingo

