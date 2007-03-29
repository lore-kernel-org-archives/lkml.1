Return-Path: <linux-kernel-owner+w=401wt.eu-S934386AbXC3BTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386AbXC3BTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 21:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbXC3BTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 21:19:41 -0400
Received: from [198.99.130.12] ([198.99.130.12]:55760 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934386AbXC3BTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 21:19:33 -0400
Date: Thu, 29 Mar 2007 14:29:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH] UML - fix I/O hang when multiple devices are in use
Message-ID: <20070329182920.GB8065@c2.user-mode-linux.org>
References: <20070328020247.GA12299@c2.user-mode-linux.org> <200703290236.44324.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703290236.44324.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 02:36:43AM +0200, Blaisorblade wrote:
> > Sometimes you need to. I'd probably just remove the do_ubd check and
> > always recall the request function when handling completions, it's
> > easier and safe.

If I'm understanding this correctly, this is what happens now.  There
is still the flag check and return if the queue is being run, but I
don't see the advantage of removing that.

> Anyway, the main speedups to do on the UBD driver are:
> * implement write barriers (so much less fsync) - this is performance killer 
> n.1

You mean preventing the upper layers from calling fsync?

> * possibly to use the new 2.6 request layout with scatter/gather I/O, and 
> vectorized I/O on the host

Yeah, this is something I've thought about on occassion but never
done.

> * while at vectorizing I/O using async I/O

I have that, but haven't merged it since I see no performance benefit
for some reason.

> * to avoid passing requests on pipes (n.2) - on fast disk I/O becomes 
> cpu-bound.

Right - I cooked up a scheme a while ago that had the requests on a
list, being removed from one end and added to the other, with some
minimal number of bytes going across the pipe to ensure a wakeup if
the other side was possibly asleep.  But I never implemented it.

> * using futexes instead of pipes for synchronization (required for previous 
> one).

Yup - for this, we either need to test the host for futuxes and use
pipes as a fallback or give up on 2.4 as the host.

> I forgot one thing: remember ubd=mmap? Something like that could have been
> done using MAP_PRIVATE, so that write had still to be called explicitly but
> unchanged data was shared with the host.

> Once a page gets dirty but is then cleaned, sharing it back is
> difficult - but even without that good savings could be
> achievable. That's to explore for the very future though.

Interesting idea.  That does avoid the formerly fatal mmap problem.
If you unmap it, the private copy goes away because it lost its last
reference, and if you map it again, you get the shared version.

That's a lot of mapping and unmapping though.  I wonder if just
calling mmap would cause the COWed page to be dropped...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
