Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0CGCZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 21:25:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab0CGCZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 21:25:33 -0500
Date: Sat, 6 Mar 2010 18:24:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] vsprintf.c: Reduce sizeof struct printf_spec from 24 to
 8 bytes
In-Reply-To: <alpine.LFD.2.00.1003061755400.23804@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003061818530.4033@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>  <20100304143837.af39845d.akpm@linux-foundation.org>  <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>  <1267911399.849.39.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
  <1267914654.849.81.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>  <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain>  <1267918554.849.89.camel@Joe-Laptop.home>  <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>
  <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>  <alpine.LFD.2.00.1003061556420.23804@localhost.localdomain> <1267924214.1937.12.camel@Joe-Laptop.home> <alpine.LFD.2.00.1003061755400.23804@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Linus Torvalds wrote:

> the 'pointer()' function has a 200+ byte stack footprint on x86-64. And 
> vsnprintf itself is about 100+ bytes. So that stack depth is way bigger 
> than I would have expected.
> 
> I'm not sure _why_ that stack footprint for 'pointer()' is so big, but I 
> bet it's due to some simple inlining, and gcc (once more) sucking at it 
> and not being able to combine stack frames. It's a damn shame.

Yeah, a few noinline's gets 'pointer()' to just save registers on the 
stack, no need for any extra buffers (which then is ok for your recursion 
case - the other subfunctions it can call have their own buffers, of 
course, but they won't be in the recursive call-path except at the leaf.

vsnprintf() itself seems less obviously fixable. I'm not sure wht gcc 
decides it needs 88 bytes of temp-space there.

		Linus
