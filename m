Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbXKTUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbXKTUYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762416AbXKTUX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:23:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762284AbXKTUXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:23:54 -0500
Date: Tue, 20 Nov 2007 12:22:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: herbert@gondor.apana.org.au, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KERNEL]: Avoid divide in IS_ALIGN
Message-Id: <20071120122243.a737c8a8.akpm@linux-foundation.org>
In-Reply-To: <1195582635.4675.145.camel@localhost>
References: <20071120135607.GA18346@gondor.apana.org.au>
	<1195582635.4675.145.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 10:17:15 -0800
Joe Perches <joe@perches.com> wrote:

> On Tue, 2007-11-20 at 21:56 +0800, Herbert Xu wrote:
> > [KERNEL]: Avoid divide in IS_ALIGN
> > I was happy to discover the brand new IS_ALIGN macro and quickly
> > used it in my code.  To my dismay I found that the generated code
> > used division to perform the test.
> > This patch fixes it by changing the % test to an &.  This avoids
> > the division.
> 
> Perhaps this should use is_power_of_2?
> 
> #define IS_ALIGNED(x, a) 				\
> 	({ typeof(x) _a = (typeof(x))(a); 		\
> 	   is_power_of_2(_a) ? (((x) & (_a - 1)) == 0)	\
> 			     : (((x) % _a == 0); })
> 
> gcc -o2/oS seems to do the right thing.

The other *ALIGN* macros in there are only good for power-of-2 alignments
so I guess Herbert's change is OK.

The whole thing's a bit crufty really - there's no reason why it _can't_
work on non-power-of-2 numbers 9via an implementation such as you suggest)
and there's no commentary in there explaining that this will presently
break things.

Those macros are sufficiently obscure, risky and undocumented as to make
them of dubious value IMO.  I mean, anything which forces you to go and
stare at the definition for a while when reviewing a callsite isn't worth
it.

