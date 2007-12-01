Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbXLAAbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbXLAAbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXLAAb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:31:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbXLAAb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:31:28 -0500
Date: Sat, 1 Dec 2007 00:31:19 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: "J.A. Magall??n" <jamagallon@ono.com>
Cc: Lo??c Greni?? <loic.grenie@gmail.com>, Ben.Crowhurst@stellatravel.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071201003119.GB8181@ftp.linux.org.uk>
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com> <20071201001950.11100a32@werewolf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201001950.11100a32@werewolf>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 12:19:50AM +0100, J.A. Magall??n wrote:
> An vtable in C++ takes exactly the same space that the function
> table pointer present in every driver nowadays... and probably
> the virtual method call that C++ does itself with
> 
> 	thing->do_something(with,this)
> 
> like
> 	push thing
> 	push with
> 	push this
> 	call THING_vtable+indexof(do_something) // constants at compile time

This is not what vtables are.  Think for a minute - all codepaths arriving
to that point in your code will pick the address to call from the same
location.  Either the contents of that location is constant (in which case
you could bloody well call it directly in the first place) *or* it has to
somehow be reassigned back and forth, according to the value of this.  The
former is dumb, the latter - outright insane.

The contents of vtables is constant.  The whole point of that thing is
to deal with the situations where we _can't_ tell which derived class
this ->do_something() is from; if we could tell which vtable it is at
compile time, we wouldn't need to bother at all.

It's a tradeoff - we pay the extra memory access (fetch vtable pointer, then 
fetch method from vtable) for not having to store a slew of method pointers
in each instance of base class.  But the extra memory access is very much
there.  It can be further optimized away if you have several method calls
for the same object next to each other (then vtable can be picked once),
but it's still done at runtime.
