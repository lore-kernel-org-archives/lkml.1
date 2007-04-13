Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXDMIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXDMIZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXDMIZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:25:55 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:31758 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752920AbXDMIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:25:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=jeVlzwYDd0f+GFjMFooAlpxoCGsK5gzer4d1T7cjBbEv7X98KiuSBBh7ImPa+Ym/gNQxsB4Nb72X3OXkejuttxpai/FJ84BD9/wTSNMsBTjohvwNvZLMh6IarJdKwgKyq5Ix3GBAcRqhZqicycs14e9RSGsqJeWz0pYri0iJreQ=  ;
X-YMail-OSG: PvSMJHUVM1nlx4aDN_mauZq3jh2KJHQvcfhBJHbNMOqj5eofkiizZHjqmQ3ar45hsklP2t5fCQ--
Message-ID: <461F3E8A.9010902@yahoo.com.au>
Date: Fri, 13 Apr 2007 18:25:46 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org> <461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org>
In-Reply-To: <20070413081338.GA27675@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Apr 13, 2007 at 06:03:45PM +1000, Nick Piggin wrote:
> 
>>Yeah good point ;) I just meant the wider "we".
>>
>>With all the problems kprobes has, something like poking deep into
>>kernel internals seems like a good thing to use it for instead of
>>hardcoding that stuff into the kernel. If not, then why did we even
>>merge it in the first place?
> 
> 
> It's very nice to poke deep into the kernel for development purposes.
> For example for the spu scheduler work I'm doing currently I have
> a module using kprobes (note the systemtap crap because it's big, bloated,
> in and odd language, and does a lot of really wrong things in it's runtime).

OK, I pick systemtap because I don't know any better... but kprobes
is what I mean for the kernel interface.


> This module allows me to put probes into various places in the scheduler
> and writes them into a ringbuffer with timestampts allowing me to
> trace what's going on there.  This is really neat.  Unfortunately it
> breaks as soon as I do some major reshuffling because then the points
> it hooks up to are not there anymore.  That's perfectly fine for my
> setup, because _I_ know what I have to change when it breaks, and can
> easily fix that.  Now imagine a similar module to trace pagecache activity
> used by a third-party monitoring tool.  We now get a major change to
> the pagecache (say to make it lockless), and the probes just break.  In
> the est case it just doesn't work anymore, in the worst case it crashes
> the kernel.  Now if the app vendor at least gave me their source I
> could at least fix it to not crash, but there's a fair enough chance
> they poke into bits that simply aren't there anymore.
> 
> Now if we have a proper user interface with real code behing it we can
> have a defined interface.  If the interface is bad enough (or just too
> lowlevel) we might have the last problem of stastistic that were there
> once to go away aswell, but we can deal with that gracefully by declaring
> parts of the stats volatile and make sure people don't mess with them.
> 
> To summarize, I really love kprobes to ease my debugging work, but using
> it for any kind of production code is a total nightmare.

OK, well Matt's stuff that he needs doesn't have to be kprobes at all,
and yes if lots of people want the same thing then we could distribute
it with the kernel.

But at least make it into its own module with a debugfs interface or
something. I mean, exposing a PG_name-to-nr and page count pfn and flags
as a supposedly formal proc interface doesn't sound nice to me. Page
flags does not tell you what is going on in the VM, it gives you a tiny
window into "something". Between reading a /proc/pid/ pfn and finding
the pfn's page flags, it could be used for something completely different
anyway.


>>We could distribute some systemtap scripts, and even distribute some
>>basic useful ones like this sort of page info in the kernel source
>>tree.
> 
> 
> We could not really distribute systemtap scripts with the kernel.
> systemtap is a bloody complicated piece of shit outside the kernel
> tree that breaks all the time we change kernel internals.  We could
> provide useful kprobes modules, a proper tracing system (ltt-ng-lite)
> and surrounding infrastucture.

OK ;)

-- 
SUSE Labs, Novell Inc.
