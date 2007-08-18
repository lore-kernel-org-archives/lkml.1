Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXHRExo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXHRExo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 00:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXHRExh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 00:53:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51391
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbXHRExg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 00:53:36 -0400
Date: Fri, 17 Aug 2007 21:53:35 -0700 (PDT)
Message-Id: <20070817.215335.26278415.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: arjan@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] i386: optimize memset of 6 and 8 bytes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070817203139.61d1505b@freepuppy.rosehill.hemminger.net>
References: <20070817185452.5cbf60c4@freepuppy.rosehill.hemminger.net>
	<1187402220.2789.2.camel@laptopd505.fenrus.org>
	<20070817203139.61d1505b@freepuppy.rosehill.hemminger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Fri, 17 Aug 2007 20:31:39 -0700

> On Fri, 17 Aug 2007 18:57:00 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > 
> > On Fri, 2007-08-17 at 18:54 -0700, Stephen Hemminger wrote:
> > > On Fri, 17 Aug 2007 18:49:34 -0700
> > > Arjan van de Ven <arjan@infradead.org> wrote:
> > > 
> > > > 
> > > > On Fri, 2007-08-17 at 16:50 -0700, Stephen Hemminger wrote:
> > > > > Tne network code does memset for 6 and 8 byte values, that can easily
> > > > > be optimized into simple assignments without string instructions.
> > > > 
> > > > 
> > > > so... question.
> > > > Why are we doing this by hand? Wouldn't gcc just generate this code in
> > > > the first place (when using __builtin_memset)? I very much suspect it
> > > > would (and if some version doesn't.... we really ought to get that
> > > > fixed)
> > > 
> > > i386 and x86_64 are not using __builtin_memset, as least from the
> > > code that I see generated.
> > 
> > .. maybe we should just fix it that way then?
> > 
> There probably is history behind the decision, like gcc problems
> on some old compiler version.

Yes, but those reasons are very likely no longer true.

In fact, just removing the memcpy macro altogether is the best
thing to do.  GCC will do inline memcpy when appropriate.
Then put all of the rep; movsl; etc. code in an external
assembler file and name the routine memcpy.

The inlining is senseless even if it all gets optimized away
into the bare necessary instructions.  All the x86 registers
get clobbered in most of those rep; movsl; code paths, so
it's hardly going to be more expensive to extern the thing
and it will make the kernel smaller to boot.

Anyways the point is to make the real C symbol called by "memcpy"
because that's what makes all the automatic gcc inline memcpy logic
kick in.  If you define the "memcpy" as a macro which calls
differently named functions, you bypass all of that.
