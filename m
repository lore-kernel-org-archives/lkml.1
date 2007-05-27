Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXE0R5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXE0R5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 13:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXE0R5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 13:57:43 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbXE0R5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 13:57:42 -0400
Date: Sun, 27 May 2007 10:57:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Indan Zupancic <indan@nul.nu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-Id: <20070527105718.19e1198d.akpm@linux-foundation.org>
In-Reply-To: <200705271156.22098.ak@suse.de>
References: <200705191443.27161.arvidjaar@mail.ru>
	<200705261802.08573.ak@suse.de>
	<20070527090542.GA18399@uranus.ravnborg.org>
	<200705271156.22098.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 11:56:21 +0200 Andi Kleen <ak@suse.de> wrote:

> 
> > 
> > So section mismatch warnings are more about catching sloopy usage of __init than it is to
> > catch potential kernel oopesen. But the latter is a nice side effect that is appreciated.
> 
> My point was that I cannot recall a single real oops bug found by the compile
> time checking.

There are quite a few of these fixes where you look at it and wonder "ytf
did the kernel ever work"?  I suspect that it's partly a case of the code
reading random junk from where a flag used to be and continuing to work.
CONFIG_DEBUG_PAGEALLOC would have caught it.

Also, simply lack of testing coverage: few people have the correct
hardware, the correct config options and then go and do an rmmod+insmod. 
Even fewer do a CPU hotplug.  Fewer still do a memory hotplug.

But there are a lot of fixes, and a lot of warnings, and they are real bugs.

> We had a few in the past, but since we poison init data after boot they all tended
> to be found quickly anyways.

Sometimes.  But a common pattern is "discover something at boot time and
save it away for later boot-time code".  The storage gets marked __fooinit
and then it turns out that some non-boot-time initialisation code is using
it.

> But the warnings just seem to require endless changes and bogus changes
> (randomly moving code which was actually ok because it only called 
> in the init case).

That would be a false positive.  We do need the various tools to suppress
those so that we can find new bugs as they turn up.

You're right that it's all a complete pain.  But the fault doesn't lie with
the checking code, IMO.  It's just that the whole initdata thing is hard to
get right.  All this fuss for a couple hundred kbytes - any sane
organisation would have killed the whole thing years ago ;)

It'll really get to be fun when some smarty writes us a "non __init symbol
referred to only from __init code" checker.

