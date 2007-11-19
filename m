Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbXKSW4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbXKSW4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXKSWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:55:55 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:52055 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXKSWzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:55:53 -0500
Date: Mon, 19 Nov 2007 14:48:46 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       wcohen@redhat.com, robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071119224845.GA27766@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071114.152134.266510129.davem@davemloft.net> <18235.40110.831730.847548@cargo.ozlabs.ibm.com> <20071114.172722.71465976.davem@davemloft.net> <20071119.050843.48408777.davem@davemloft.net> <18242.900.101842.261763@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18242.900.101842.261763@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, Nov 20, 2007 at 08:43:32AM +1100, Paul Mackerras wrote:
> David Miller writes:
> 
> > As a result I've found that perfmon2 is quite nice and allows
> > incredibly useful and powerful tools to be written.  The syscalls
> > aren't that bad and really I see not reason to block it's inclusion.
> > 
> > I rescind all of my earlier objections, let's merge this soon :-)
> 
> Strongly agree.  However, I think we need to add structure size
> arguments to most of the syscalls so we can extend them later.
> 
Yes, that is one way. It works well if you only extend structures at the end.
Given that you need to obtain the file descriptor first via a pfm_create_context
call, an alternative could be that you pass a version number to that call to
identify the version the application is requesting.

> Also, something I've been meaning to mention to Stephane is that the
> use of the cast_ulp() macro in perfmon is bogus and won't work on
> 32-bit big-endian platforms such as ppc32 and sparc32.  On such

I don't like those cast_ulp() macros. They were put there to avoid compiler
warnings on some architectures. Clearly with the big-endian issue, we need
to find something else. The bitmap*() macros make unsigned long *.

The interface uses fixed size type to ensure ABI compatibility between
32 and 64 bit modes. This way there is no need to marhsall syscall arguments
for a 32-bit app running on a 64-bit host.

Looks like we will have to use bytes (u8) instead.  This may have some
performance impact as well. Several bitmaps are used in the context/interrupt
routines. Even with u8, there is still a problem with the bitmap*() macros.
Now, only a small subset of the bitmap() macros are used, so it may be okay
to duplicate them for u8.

What do you think?

> platforms you can't take a pointer to an array of u64, cast it to
> unsigned long * and expect the kernel bitmap operations to work
> correctly on it.  At the least you also need to XOR the bit numbers
> with 32 on those platforms.  Another alternative is to define the
> bitmaps as arrays of bytes instead, which eliminates all byte ordering
> and wordsize problems (but makes it more tricky to use the kernel
> bitmap functions directly).
> 

-- 

-Stephane
