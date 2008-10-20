Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYJTKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYJTKGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYJTKGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:06:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53835 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYJTKGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:06:47 -0400
Date: Mon, 20 Oct 2008 11:06:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Albert Cahalan <acahalan@gmail.com>
Cc: adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
Message-ID: <20081020100643.GA22647@csn.ul.ie>
References: <787b0d920810200218o5f26ee7bj9f8c0e71606dd5cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <787b0d920810200218o5f26ee7bj9f8c0e71606dd5cb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/10/08 05:18), Albert Cahalan didst pronounce:
> Adding " (hpagesize=4096kB)" onto the end of a filename is as vile
> as adding " (deleted)" onto the end. If anything is going to change
> in this area, it should be the elimination of " (deleted)". These
> tags are perfectly legitimate in filenames.
> 

I dropped that change altogether in the last series because of concerns like
this. It did have the potential to grow to something weird looking.

> Looping on stat() while chopping off suspected tags is dreadful.
> Besides just being gross, it's slow.
> 

You're probably right. It's a bit weird that it's what you have to do to
figure out if the file in /proc/PID/maps is really there or not.

> gdb will tolerate up to 7 flags, procps will tolerate up to 31 flags,
> and both will tolerate anything without a '/' before the filename.
> 

Understood.

> Obviously, every author of a /proc-based tool has been forced to
> take a random guess at the ABI. The /proc/*/smaps is so gross and
> that I put off writing a parser for years.
> 

I intend to take a stab at it for the purposes of teaching pmap to print
the pagesizes if the smaps change gets picked up.

> What you can probably get away with:
> 
> After the "rwxp" stuff you can add 3 more flags. (gdb limit)
> You could use 'L' for locked pages, 'R' for swap reservation,
> and 'D' for deleted files. It's probably much better to save
> space though, since gdb will crash if you add too many flags.
> Three characters can be 18 bits if you base-64 encode them,
> being careful to avoid the '/' character. (adding 0x30 works)
> 

Ok, noted in case I ever decide to tackle the (deleted) removal. It's
not something I feel strongly about though.

> Right before the filename, you can add anything except a '/'.
> You could add a few columns of numbers or a second flags field.
> 

My fear was about parsers that hard-coded what number field stored the
filename. If a column was added for pagesize for example, then parsers
would think the pagesize was the filename.

> Not that it matters on such a slow-ass file format, but you
> can make parsing faster if you encode the page size in one byte.
> Simply add 0x30 to the page shift, then print that byte. Note that
> this would let you cram the page size into the flags field.
> 

Now, that is an interested idea, albeit it's not one that is easily
human-readable and would need a second parser like pmap but that's ok. If
parsing smaps turns into a total pain in the ass or the performance overhead
of calculating PSS when reading the pagesize becomes a problem, then I'll
try this option. Thanks a lot for that idea.

> BTW, I'm thinking that the /proc/*/*maps files fail when the
> lines exceed 4096 bytes. The pathname may legitimately be that
> long, plus it can be backslash escaped, plus there is all the
> junk on the beginning.
> 

Yes. While it's unlikely to be exceeded, a file could be 4096 bytes long
and the other fields will then cause a problem. It was because of things
like this, I was ok with dropping the idea of adding (attribute[=value])
from the end of the filename.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
