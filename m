Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYGVKyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYGVKyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYGVKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:53:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbYGVKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:53:58 -0400
Date: Tue, 22 Jul 2008 03:53:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: michael@ellerman.id.au
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Peter Anvin <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Make u64 long long on all architectures (was: the
 printk problem)
Message-Id: <20080722035318.76cad6dd.akpm@linux-foundation.org>
In-Reply-To: <1216722995.8357.4.camel@localhost>
References: <20080625131101.GA6205@digi.com>
	<20080704104634.GA31634@digi.com>
	<20080704111540.ddffd241.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0807041147450.2815@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807041250220.2815@woody.linux-foundation.org>
	<20080704132716.f1e12554.akpm@linux-foundation.org>
	<20080704204252.GM14894@parisc-linux.org>
	<20080704150100.1f7b8a65.akpm@linux-foundation.org>
	<20080705020350.GN14894@parisc-linux.org>
	<20080722030506.206a2cc2.akpm@linux-foundation.org>
	<1216722995.8357.4.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 20:36:35 +1000 Michael Ellerman <michael@ellerman.id.au> wrote:

> On Tue, 2008-07-22 at 03:05 -0700, Andrew Morton wrote:
> > On Fri, 4 Jul 2008 20:03:51 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> > > [PATCH] Make u64 long long on all architectures
> > > 
> > > It is currently awkward to print a u64 type.  Some architectures use
> > > unsigned long while others use unsigned long long.  Since unsigned long
> > > long is 64-bit for all existing Linux architectures, change those that
> > > use long to use long long.  Note that this applies only within the
> > > kernel.  If u64 is being used in a C++ method definition, the symbol
> > > mangling would change.
> > > 
> > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > > 
> > > diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
> > > index 2af9b75..32f07bd 100644
> > > --- a/include/asm-generic/int-l64.h
> > > +++ b/include/asm-generic/int-l64.h
> > > @@ -23,8 +23,13 @@ typedef unsigned short __u16;
> > >  typedef __signed__ int __s32;
> > >  typedef unsigned int __u32;
> > >  
> > > +#ifdef __KERNEL__
> > > +typedef __signed__ long long __s64;
> > > +typedef unsigned long long __u64;
> > > +#else
> > >  typedef __signed__ long __s64;
> > >  typedef unsigned long __u64;
> > > +#endif
> > >  
> > >  #endif /* __ASSEMBLY__ */
> > 
> > This is (IMO) a desirable change and will prevent a heck of a lot of
> > goofing around, and will permit a lot of prior goofing around to
> > be removed.
> > 
> > But I bet there are lots of instalces of printk("%l", some_u64) down in
> > arch code where the type of u64 _is_ known which will now spew warnings.
> > 
> > Oh well.
> 
> As a rough estimate:
> 
> concordia powerpc(master) $ find arch/powerpc/ ! -name '*32.*' | xargs grep "%l" | grep -v "%ll" | wc -l
> 635

lolz.  If yesterdays-linux-next on todays-mainline wasn't such a
hilarious trainwreck I'd test your grepping.  I guess that could be
done on mainline too.

> Someone's gonna get a lot of git points for fixing all those. Might keep
> the speeling fix crowd busy for a while.

I'm not sure I have the energy for this.

But we really should do it.
