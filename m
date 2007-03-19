Return-Path: <linux-kernel-owner+w=401wt.eu-S1030579AbXCSSkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579AbXCSSkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXCSSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:40:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030572AbXCSSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:40:15 -0400
Date: Mon, 19 Mar 2007 11:38:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
References: <20070316.023331.59468179.davem@davemloft.net> <45FB005D.9060809@goop.org>
 <1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net>
 <20070318120814.GA45869@muc.de> <1174272469.11680.23.camel@localhost.localdomain>
 <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Mar 2007, Eric W. Biederman wrote:
> 
> True.  You can use all of the call clobbered registers.

Quite often, the biggest single win of inlining is not so much the code 
size (although if done right, that will be smaller too), but the fact that 
inlining DOES NOT CLOBBER AS MANY REGISTERS!

The lack of register clobbering, and the freedom for the compiler to 
choose registers around an inlined function is usually the biggest win! If 
you can't do that, then inlining generally doesn't actually even help: a 
call/return to a single instruction isn't all that much slower than just 
doing the "cli" in the first place.

If we end up with a setup where any inlined instruction needs to act as if 
it was a function call (just with the "call" instruction papered over with 
the inlined instruction sequence), then there is no point to this at all. 

In short: people here seem to think that inlining is about avoiding the 
call/ret sequence. Not so. The real advantages of inlining are elsewhere.

So *please* don't believe that you can make it "as cheap" to have some 
automatic fixup of two sequences, one inlined and one as a "call".  It may 
look so when you look at the single instruction generated, but you're 
ignoring all the instructions *around* the site.

			Linus
