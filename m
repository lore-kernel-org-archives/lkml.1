Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZHYH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZHYH7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZHYH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:59:37 -0400
Received: from ozlabs.org ([203.10.76.45]:34941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZHYH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:59:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: kernel segv with 2.6.31-rc6 ?
Date: Tue, 25 Aug 2009 17:29:32 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Roland McGrath <roland@redhat.com>, Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4A89CC4D.5040801@gmx.de> <20090819013124.7539E4730F@magilla.sf.frob.com> <1250645916.18426.12.camel@mulgrave.site>
In-Reply-To: <1250645916.18426.12.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908251729.32855.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 11:08:36 am James Bottomley wrote:
> On Tue, 2009-08-18 at 18:31 -0700, Roland McGrath wrote:
> > > Actually, I think we do; the module loader is a runtime linker, after
> > > all.  [...]
> > 
> > Indeed you do.  I've just read some of the parts of ld that normally
> > address this issue for HPPA.  They don't run for ld -r.  So this is just
> > another fine example of the lunacy of the ET_REL .ko madness that would be
> > naturally avoided by a sensible tweaked ET_DYN scheme.
> 
> Using ET_DYN would have made our life easier when trying to code the
> kernel module loader as well.  The basic problem is, of course, that
> this is simple on an x86, so it didn't matter that much for the initial
> implementation.  It just becomes less simple on anything else.

Actually, x86 was one of the archs which fucked us.  Richard Henderson and
I *had* this, but ld -shared without -fPIC helpfully tells you "you're doing
it wrong" on x86-64.

There were other issues, ISTR MIPS was a showstopper.  Google finds the
following summary I wrote when this stuff was fresher:

http://lkml.org/lkml/2003/1/12/271 :

	While ET_DYN modules are a reasonably serious win for ia64 (and
	probably hppa) (ie. -300 lines or so), they're a minor win for alpha
	and ppc64 (-100 lines or so), and no real change for arm, i386, ppc,
	sparc, and sparc64.  It's a lose for x86_64 (toolchain fixes, unless
	they want to use -fPIC for modules), mips and mips64 (major toolchain
	fixes, unless they want to use -fPIC for modules and stop using r28
	for current inside modules).

> >   But that battle was
> > lost way, way back in the long, long ago, so long ago they were probably
> > even still making HPPA machines then.

This isn't quite true; userspace should handle ET_DYN fine (at least, it
was supposed to).

So you could change any arch to use that, but it's a fair refactor if we leave
some archs behind.

If anyone's really interested, I can dig out the bits I have...

> So that leaves us stuck with the current implementation and still
> needing a solution for the duplicate section names?

If this is not a "don't do that" bug, we could try hacking around it in
parisc's module_arch_frob_sections?

Rusty.
