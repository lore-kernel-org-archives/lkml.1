Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbXFBCzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbXFBCzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXFBCzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:55:05 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbXFBCzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:55:03 -0400
Date: Fri, 1 Jun 2007 19:54:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011947030.3957@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
>  
> -	if (!x)
> +	if (x <= ZERO_SIZE_PTR)
>  		return;

Btw, this is _not_ safe.

A number of gcc versions have done signed arithmetic on pointers. It's 
insane and stupid, but it happens, and it so happens to work on 
architectures where the point where the sign changes over is not a valid 
pointer area.

On x86, doing signed arithmetic on pointers is a clear and unambiguous 
_bug_ (because a C object really _can_ start in "positive" space and end 
in "negative" pointer space), but I think some gcc versions did it there 
too.

On some other architectures, like x86-64, the virtual memory around the 
magic switch-over point is not mappable, so a C object cannot validly 
straddle the area where positive overflows into negative, and as such a 
compiler _could_ consider pointers to be signed (although I really don't 
see the point).

So when I suggested the uglier

	if ((unsigned long)x <= 16)
		return;

I really did mean to use that ugly cast.. Yours is prettier, but sadly, 
yours is simply not safe: a signed comparison might end up making _all_ 
kernel pointers trigger that test.

			Linus
