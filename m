Return-Path: <linux-kernel-owner+w=401wt.eu-S1422872AbXBAX13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422872AbXBAX13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422892AbXBAX13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:27:29 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:60278 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422872AbXBAX12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:27:28 -0500
Date: Thu, 1 Feb 2007 15:27:09 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: i386 and x86-64 bitops function prototypes differ
Message-ID: <20070201232709.GF1175@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070126143555.GL11525@frankl.hpl.hp.com> <45BA3F42.3020006@zytor.com> <20070201091555.GA32377@frankl.hpl.hp.com> <20070201145525.d4d950c0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201145525.d4d950c0.akpm@osdl.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Feb 01, 2007 at 02:55:25PM -0800, Andrew Morton wrote:
> On Thu, 1 Feb 2007 01:15:55 -0800
> Stephane Eranian <eranian@hpl.hp.com> wrote:
> 
> > Hello,
> > 
> > On Fri, Jan 26, 2007 at 09:49:54AM -0800, H. Peter Anvin wrote:
> > > >
> > > >I ran into compiler warnings with the perfmon code when I tried
> > > >using test() and __set_bit() on i386. 
> > > >
> > > >For some reason, the i386 bitops functions use unsigned long * for
> > > >the address whereas x86-64/ia64 use void *.
> > > >
> > > >I do not quite understand why such difference?
> > > >Is this just for historical reasons?
> > > >
> > > >Thanks.
> > > >
> > > 
> > > Arguably void * is the right thing for a littleendian architecture.  For 
> > > bigendian architectures it unfortunately matters what the chunk size is, 
> > > regardless of if the chunks are numbered in bigendian (reverse) or 
> > > littleendian (forward) order.
> > > 
> > 
> > I agree with you, but i386 is definitively little endian, so here is a patch
> > against 2.6.20-rc6-mm3 to make x86-64 and i386 have the same prototypes for
> > bit manipulation routines.
> > 
> > changelog:
> > 	- change all bit manipulation inline routine to use void * as their
> > 	  address argument instead of unsigned long *. Match x86-64
> > 
> > signed-off-by: stephane eranian <eranian@hpl.hp.com>
> > 
> > --- linux-2.6.20-rc6-mm3.orig/include/asm-i386/bitops.h	2007-01-31 09:24:21.000000000 -0800
> > +++ linux-2.6.20-rc6-mm3.base/include/asm-i386/bitops.h	2007-01-31 09:31:46.000000000 -0800
> > @@ -33,7 +33,7 @@
> >   * Note that @nr may be almost arbitrarily large; this function is not
> >   * restricted to acting on a single-word quantity.
> >   */
> > -static inline void set_bit(int nr, volatile unsigned long * addr)
> > +static inline void set_bit(int nr, volatile void * addr)
> 
> These bitops are only valid on long*'s.  Or a least, they require a
> long-aligned address, and using long* is how we communicate and enforce
> that.
> 
Yes, I realize this now.

> Numerous architectures implement these functions using ulong*.  If we make
> this change, we risk someone doing set_bit() on, say, a char *.  That
> change would compile and run happily on x86 and would then fail on, say,
> arm or h8/300.
> 
> So I'd say that x86_64 is wrong, and should be changed to take ulong*.

We need to fix x86-64 and also ia64 it seems. I'll see if I can do that.
Thanks.

-- 
-Stephane
