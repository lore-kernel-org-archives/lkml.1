Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbYCCRfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbYCCRfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbYCCRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:22:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39083 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783AbYCCRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:22:36 -0500
Date: Mon, 3 Mar 2008 09:22:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Message-ID: <20080303172230.GB12453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080303120842.GA28369@elf.ucw.cz> <Pine.LNX.4.44L0.0803031023550.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803031023550.3611-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:42:35AM -0500, Alan Stern wrote:
> On Mon, 3 Mar 2008, Pavel Machek wrote:
> 
> > Hi!
> > 
> > > > Alan thinks that `subj` is correct...
> > > 
> > > More precisely, reads and writes of pointers are always atomic.  That 
> > > is, if a write and a read occur concurrently, it is guaranteed that the 
> > > read will obtain either the old or the new value of the pointer, never 
> > > a mish-mash of the two.  If this were not so then RCU wouldn't work.
> 
> Right, Paul?

Yep, as long as they aligned naturally, e.g., 32-bit pointers to a
four-byte boundary, 64-bit pointers to an eight-byte boundary.

Note that this is a backdoor agreement between the Linux kernel and gcc.
The C/C++ standard does -not- require atomic reads or writes for anything
other than a volatile sig_atomic_t.  In fact, there are a lot of things
that C/C++ doesn't guarantee, which is why Linux makes use of so many
of gcc's non-standard extensions.  ;-)

> > Ok, so linux actually atomicity of long?

Yep, same alignment rules as pointers.  Ah, and the alignment is
covered below.  Very good!

> > If so, this should probably be applied...
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
> > index 4ef2450..0a7d180 100644
> > --- a/Documentation/atomic_ops.txt
> > +++ b/Documentation/atomic_ops.txt
> > @@ -21,6 +21,9 @@ local_t is very similar to atomic_t. If 
> >  updated by one CPU, local_t is probably more appropriate. Please see
> >  Documentation/local_ops.txt for the semantics of local_t.
> >  
> > +long (and int and void *) can be used instead of atomic_t, if all you
> > +need is atomic setting and atomic reading.
> > +
> >  The first operations to implement for atomic_t's are the initializers and
> >  plain reads.
> 
> Yes indeed.  This fact doesn't seem to be documented anywhere, but it 
> is clearly a requirement of the kernel.  I would make the text a little 
> more explicit, see below.
> 
> Alan Stern
> 
> -------------------------------------------------------
> 
> 
> Atomicity of reads of write for pointers and integral types (other than 
> long long) should be documented.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/Documentation/atomic_ops.txt
> ===================================================================
> --- usb-2.6.orig/Documentation/atomic_ops.txt
> +++ usb-2.6/Documentation/atomic_ops.txt
> @@ -21,6 +21,21 @@ local_t is very similar to atomic_t. If 
>  updated by one CPU, local_t is probably more appropriate. Please see
>  Documentation/local_ops.txt for the semantics of local_t.
> 
> +For all properly-aligned pointer and integral types other than long
> +long, the kernel requires simple reads and writes to be atomic with
> +respect to each other.  That is, if one CPU reads a pointer value at
> +the same time as another CPU overwrites the pointer, it is guaranteed
> +that the reader will obtain either the old or the new value of the
> +pointer, never some mish-mash combination of the two.  Likewise, if
> +one CPU writes a long value at the same time as another CPU does, it
> +is guaranteed that one or the other of the values will end up stored
> +in memory, not some mish-mash combination of bits.
> +
> +Thus, if all you need is atomicity of reading and writing then you can
> +use plain old ints, longs, or pointers; you don't need to use
> +atomic_t.  (But note: This guarantee emphatically does not apply to
> +long long values or unaligned values!)
> +
>  The first operations to implement for atomic_t's are the initializers and
>  plain reads.
> 
> 
