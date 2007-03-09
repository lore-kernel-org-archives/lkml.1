Return-Path: <linux-kernel-owner+w=401wt.eu-S1767632AbXCIXQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767632AbXCIXQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767629AbXCIXQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:16:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767632AbXCIXQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:16:01 -0500
Date: Fri, 9 Mar 2007 15:15:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN (Re: [PATCH] Fix get_order())
In-Reply-To: <20070309231334.GB17084@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0703091509180.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org>
 <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
 <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower>
 <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
 <20070309231334.GB17084@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Oleg Verych wrote:
> 
> OTOH, if i would write it this way
> 
> #define BALIGN(x,bits)      ((((x) >> (bits)) + 1) << (bits))

But that's *wrong*. It aligns something that is *already* aligned to 
something else.

So you'd have to do it as something like

	#define ALIGN_TO_POW2(x,pow) \
		((((x)+(1<<(pow))-1)>>(pow))<<(pow))

and the thing is, that's actually both (a) less readable than what ALIGN() 
already does (b) unless the compiler notices that what you really want is 
a "bitwise and", it's really inefficient too because shifts are generally 
much more expensive than simple bitops.

So you're simply better off doing it as

	#define ALIGN_TO_POW2(x,pow) ALIGN(x, (1ull << pow))

but then you'd still have to depend on the "typeof()" magic in ALIGN() to 
turn the final end result back to the type of "x".

(the "1ull" is necessary exactly because you don't know what type "x" is 
beforehand, so you need to make sure that the mask is at *least* as big a 
type as x, and not overflow to undefined C semantics).

			Linus
