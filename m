Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbXE3SFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbXE3SFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXE3SF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:05:27 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbXE3SFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:05:25 -0400
Date: Wed, 30 May 2007 11:03:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
In-Reply-To: <Pine.LNX.4.64.0705300903030.31930@anakin>
Message-ID: <alpine.LFD.0.98.0705301051580.26602@woody.linux-foundation.org>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg>
 <20070529173818.fd94ae81.akpm@linux-foundation.org> <465D1020.3030605@cosmosbay.com>
 <Pine.LNX.4.64.0705300903030.31930@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Geert Uytterhoeven wrote:
> 
> Apparently you get a warning only if the _first_ occurrence of a struct
> is declared inside a parameter list of a function.

This is normal C behaviour (and afaik, the "inside a parameter list" part 
is actually just _modern_ C, not traditional C. I _think_ traditional C 
had a single global namespace for struct names, and no scoping at all).

You can use a _pointer_ to a structure without declaring the structure 
itself, and this is totally standard C behaviour. The very use of the 
pointer will tell the C compiler that such a structure exists, and since 
you only use the pointer, the compiler doesn't care what the struct 
_looks_ like. It just adds it to its list of known structures.

In fact, you can often use such a pointer without _ever_ declaring the 
structure at all. The structure may not even _exist_. It may be just a way 
to get type safety, and every time you want to actually use the pointer, 
you have to explicitly cast it to something else.

(Example: in <stdio.h> you can do

	typedef struct dummy_made_up_struct FILE;

and make sure that everybody ever uses a "FILE *f", and trying to create a 
"FILE f" would be a compile-time error, because that "struct 
dummy_made_up_struct" simply doesn't even exist, and all the real users 
will cast it to some internal thing)

The reason the "inside a parameter list" is special is that modern C (I 
think through some obscure C++ reason, but I'm not sure) considers the 
function parameter list to be inside function scope, and that includes the 
types, not just the parameter names.

So when you do

	extern function(struct hello *);

without (forward-)declaring "struch hello" earlier, then the compiler will 
still create a "struct hello" internally, but since the scope of that 
declaration is purely just that function prototype itself, it will be 
forgotten immediately afterwards, and a subsequent use of "struct hello" 
will be considered a _different_ "struct hello", since it's in different 
scope.

So you generally never need to forward-declare structures, unless you only 
then use them inside function prototypes. In which case you would just do

	struct hello;

to tell the compiler that you have a "struct hello" that you haven't 
actually declared yet, and now it's in scope _outside_ the function 
prototype, and everybody is happy and agrees that they are using the same 
"struct hello".

		Linus
