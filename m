Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXHaEpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXHaEpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbXHaEpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:45:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030AbXHaEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:45:34 -0400
Date: Thu, 30 Aug 2007 21:44:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Fix out-by-one error in traps.c
In-Reply-To: <1188512066.6353.5.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> 
 <20070822202551.GB31846@slug>  <20070823145038.9895784f.akpm@linux-foundation.org>
  <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org> 
 <20070824082249.GG31846@slug>  <1188043649.20041.81.camel@localhost.localdomain>
  <20070825122324.GA6138@slug> <20070825211405.GA18217@slug> 
 <1188230999.5531.15.camel@localhost.localdomain>  <20070830163812.GA22190@slug>
 <1188512066.6353.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Rusty Russell wrote:
>
> We don't care if ebp is on the stack, we care about ebp + 4.  Without
> this, lguest (with CONFIG_DEBUG_LOCKDEP) can touch a page unmapped by
> CONFIG_DEBUG_PAGEALLOC.

Hmm.. This *really* cannot happen with a normal kernel - it implies that 
the stack has crossed into an invalid page. 

Why is that allowed with lguest? What kind of code could validly *ever* 
come in here and cause problems?

I'm getting the nervous feeling that lguest is really doing things that 
shouldn't be done, or is using normal kernel functions in ways that they 
should not be used. 

In other words, yes, we load off "ebp+4", but I really don't see it being 
a valid situation wher ebp itself isn't also a valid stack frame. The 
stack is not sized for "off-by-one" errors - we're supposed to always have 
plenty of stack space free, and if you care about "off-by-one", you're not 
just living on the edge, you're way beyond it!

IOW, please explain why/how lguest ever triggers a case where this would 
possibly matter!

		Linus
