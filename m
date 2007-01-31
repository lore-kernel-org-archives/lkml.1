Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXAaHf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXAaHf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXAaHf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:35:59 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:53985 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbXAaHf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:35:59 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 02:20:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <45BFEF2A.5070907@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701310203310.29480@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
 <45BFEF2A.5070907@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Nick Piggin wrote:

> Robert P. J. Day wrote:
> > On Tue, 30 Jan 2007, Nick Piggin wrote:
> >
> >
> > > Robert P. J. Day wrote:
> > >
> > > >  Add the inline function "is_power_of_2()" to log2.h, where the value
> > > > zero is *not* considered to be a power of two.
> > >
> > > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > > >
> > > > /*
> > > > + *  Determine whether some value is a power of two, where zero is
> > > > + * *not* considered a power of two.
> > > > + */
> > >
> > > Why the qualifier? Zero *is* not a power of 2, is it?
> >
> >
> > no, but it bears repeating since some developers might think it *is*.
> > if you peruse the current kernel code, you'll find some tests of the
> > simpler form:
> >
> > 	((n & (n - 1)) == 0))
> >
> > which is clearly testing for "power of twoness" but which will
> > return true for a value of zero.  that's wrong, and it's why it's
> > emphasized in the comment.
>
> I would have thought you'd comment the broken ones, but that's just
> me.

  good point, so let's just sum up here.  (man, it's hard to believe
that something this simple could drag on so long.  i feel like i'm
discussing free device driver development or something. :-)

  the new is_power_of_2() macro is defined as:

  (n != 0 && ((n & (n - 1)) == 0))

which (correctly, IMHO) does *not* identify zero as a power of two.
if someone truly wants *that* test, they can write it themselves:

  if (x == 0 || is_power_of_2(x))

  this means that, if someone wants to start rewriting those tests in
the source tree, every time they run across an apparent "power of two"
test of the simpler form:

  (n & (n - 1))

they have to ask themselves, "ok, did this coder mean to include zero
or not?"  in some cases, it's probably not going to be obvious.
(maybe the maintainers could do a quick check themselves and make the
substitution 'cuz, once the kernel janitors get ahold of this, you
never know what hilarity will ensue. :-)

  as far as the patch itself i submitted is concerned, the *only*
place that changed the existing semantics was here:

=================================================
--- a/arch/ppc/syslib/ppc85xx_rio.c
+++ b/arch/ppc/syslib/ppc85xx_rio.c
@@ -59,8 +59,6 @@
 #define DBELL_TID(x)           (*(u8 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)           (*(u16 *)(x + DOORBELL_INFO_OFFSET))

-#define is_power_of_2(x)       (((x) & ((x) - 1)) == 0)
-
 struct rio_atmu_regs {
        u32 rowtar;
        u32 pad1;
=================================================

so if the powerpc people are ok with that, then the patch itself
should be fine, and it's only the upcoming substitutions in the source
tree that will have to be checked carefully, one by one.

rday

--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
