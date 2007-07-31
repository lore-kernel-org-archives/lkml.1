Return-Path: <linux-kernel-owner+w=401wt.eu-S1765150AbXGaVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765150AbXGaVhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXGaVhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:37:06 -0400
Received: from waste.org ([66.93.16.53]:35394 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbXGaVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:37:04 -0400
Date: Tue, 31 Jul 2007 16:37:18 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: /proc/$pid/pagemap troubles
Message-ID: <20070731213718.GW11115@waste.org>
References: <1185914174.18414.184.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185914174.18414.184.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 01:36:14PM -0700, Dave Hansen wrote:
> Since the pagemap code has a little header on it to help describe the
> format, I wrote a little c program to parse its output.  I get some
> strange results.  If I do this:
> 
> 	fd = open("/proc/1/pagemap", O_RDONLY);
> 	count = read(fd, &endianness, 1);
> 
> count will always be 4.  

Known bug, fixed in my pending and not-currently-working update. It
ought to return 0 for short reads.
 
> hexdump gets similar, but even worse results:
>         
>         qemu:~# strace hexdump -C /proc/self/pagemap 
>         ...
>         read(0, "\1\f\4\4\377\377\377\377\377\377\377\377\377\377\377\377"..., 16) = 20
>         read(0, 0x804d39c, 4294967292)          = -1 EFAULT (Bad address)
>         --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>         +++ killed by SIGSEGV +++
> 
> Note that the kernel returns 20 to the read request of 16.  I think the
> kernel is actually copying over something important in hexdump's memory
> which is adjacent to the buffer and causing it to segfault.

Also fixed.

> The code is basically organized not to output the right thing for any
> unaligned access, and it apparently gets confused about exactly what
> userspace has asked for.  I think this is largely due to its overwriting
> of "count" in pagemap_read().
> 
> So, a couple of questions.  Don't we need to support non-sizeof(unsigned
> long)-aligned reads?

Why? We should obviously never return more data than we were asked for
(that's clearly a bug), but lots of things refuse to read or write
stuff that isn't well sized and aligned.

> Do we _really_ need that header in each and every file?

Well there's either a header or there isn't.

> > * first byte:   0 for big endian, 1 for little
> 
> Do we ever have cases where userspace and kernel differ in their
> endianness?  Or, are you hoping to dump these files raw on one
> architecture and parse them on another?

Potentially, yes.

> > * second byte:  page shift (eg 12 for 4096 byte pages)
> 
> This might actually (in theory) change on a per-process basis, so it
> makes sense.  But, it seems more global to the process that just pagemap
> output.  Would this always be the same as getpagesize()?   Or, should it
> always map 1:1 with the amount of memory mapped by a kernel pte_t.  I
> _think_ these can be slightly different because we have 64k PAGE_SIZE on
> ppc64, but allow mappings to happen in 4k 
> 
> > * third byte:   entry size in bytes (currently either 4 or 8)
> 
> This one really boils down to "what is the kernel's sizeof(unsigned
> long)" because we'll always store pfns in those.  It seems like we
> should have a better way to go fetch that.
> 
> > * fourth byte:  header size
> 
> If we can get rid of the other three this, of course, goes away.

True. But the variable-sized header lets us add other stuff later.

-- 
Mathematics is the supreme nostalgia of our time.
