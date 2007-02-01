Return-Path: <linux-kernel-owner+w=401wt.eu-S1422665AbXBAXB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665AbXBAXB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422695AbXBAXB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:01:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422665AbXBAXB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:01:56 -0500
Date: Thu, 1 Feb 2007 14:55:25 -0800
From: Andrew Morton <akpm@osdl.org>
To: eranian@hpl.hp.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: i386 and x86-64 bitops function prototypes differ
Message-Id: <20070201145525.d4d950c0.akpm@osdl.org>
In-Reply-To: <20070201091555.GA32377@frankl.hpl.hp.com>
References: <20070126143555.GL11525@frankl.hpl.hp.com>
	<45BA3F42.3020006@zytor.com>
	<20070201091555.GA32377@frankl.hpl.hp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 01:15:55 -0800
Stephane Eranian <eranian@hpl.hp.com> wrote:

> Hello,
> 
> On Fri, Jan 26, 2007 at 09:49:54AM -0800, H. Peter Anvin wrote:
> > >
> > >I ran into compiler warnings with the perfmon code when I tried
> > >using test() and __set_bit() on i386. 
> > >
> > >For some reason, the i386 bitops functions use unsigned long * for
> > >the address whereas x86-64/ia64 use void *.
> > >
> > >I do not quite understand why such difference?
> > >Is this just for historical reasons?
> > >
> > >Thanks.
> > >
> > 
> > Arguably void * is the right thing for a littleendian architecture.  For 
> > bigendian architectures it unfortunately matters what the chunk size is, 
> > regardless of if the chunks are numbered in bigendian (reverse) or 
> > littleendian (forward) order.
> > 
> 
> I agree with you, but i386 is definitively little endian, so here is a patch
> against 2.6.20-rc6-mm3 to make x86-64 and i386 have the same prototypes for
> bit manipulation routines.
> 
> changelog:
> 	- change all bit manipulation inline routine to use void * as their
> 	  address argument instead of unsigned long *. Match x86-64
> 
> signed-off-by: stephane eranian <eranian@hpl.hp.com>
> 
> --- linux-2.6.20-rc6-mm3.orig/include/asm-i386/bitops.h	2007-01-31 09:24:21.000000000 -0800
> +++ linux-2.6.20-rc6-mm3.base/include/asm-i386/bitops.h	2007-01-31 09:31:46.000000000 -0800
> @@ -33,7 +33,7 @@
>   * Note that @nr may be almost arbitrarily large; this function is not
>   * restricted to acting on a single-word quantity.
>   */
> -static inline void set_bit(int nr, volatile unsigned long * addr)
> +static inline void set_bit(int nr, volatile void * addr)

These bitops are only valid on long*'s.  Or a least, they require a
long-aligned address, and using long* is how we communicate and enforce
that.

Numerous architectures implement these functions using ulong*.  If we make
this change, we risk someone doing set_bit() on, say, a char *.  That
change would compile and run happily on x86 and would then fail on, say,
arm or h8/300.

So I'd say that x86_64 is wrong, and should be changed to take ulong*.
