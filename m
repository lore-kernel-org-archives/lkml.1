Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXL2JSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXL2JSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXL2JSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:18:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49508
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXL2JSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:18:03 -0500
Date: Sat, 29 Dec 2007 01:18:02 -0800 (PST)
Message-Id: <20071229.011802.76136568.davem@davemloft.net>
To: bunk@kernel.org
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071229090619.GB27360@does.not.exist>
References: <20071229084846.GA27360@does.not.exist>
	<20071229.005408.76652528.davem@davemloft.net>
	<20071229090619.GB27360@does.not.exist>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sat, 29 Dec 2007 11:06:19 +0200

> On Sat, Dec 29, 2007 at 12:54:08AM -0800, David Miller wrote:
> > From: Adrian Bunk <bunk@kernel.org>
> > Date: Sat, 29 Dec 2007 10:48:46 +0200
> > 
> > > On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> > > > That's why I'm not worried about this issue and it's not critical at
> > > > all.
> > > 
> > > If a module calls sunserial_console_match() that's an Oops.
> > 
> > That's true.
> > 
> > I'm trying to figure out a way to fix this.
> 
> #ifdef FOO_CONSOLE around the sunserial_console_match() calls in the  
> drivers should work.

It absolutely doesn't work, I tried this, see my other reply.

The issue is add_preferred_console() is __init, driver probe calls are
__devinit which are either __init or not __init.

So even with the FOO_CONSOLE ifdef (or something similar like the
patch I posted) we'll still get section mismatch warnings.

> If you consider this too many #ifdef's, an alternative solution would be 
> doing the following in drivers/serial/suncore.h:
> 
> #ifndef MODULE
> extern int sunserial_console_match(struct console *, struct device_node *,
>                                    struct uart_driver *, int);
> #else
> static inline int sunserial_console_match(struct console *, struct device_node *,
>                                           struct uart_driver *, int);
> { return 0; }
> #endif

Just removing the __init tag from add_preferred_console() (and
subsequently sunserial_console_match()) is probably the easiest way to
fix all of this.
