Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZGKLXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZGKLXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZGKLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:23:04 -0400
Received: from ozlabs.org ([203.10.76.45]:44087 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZGKLXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:23:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Date: Sat, 11 Jul 2009 20:52:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907111537.03191.rusty@rustcorp.com.au> <20090711073037.GA28414@elte.hu>
In-Reply-To: <20090711073037.GA28414@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907112052.57174.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 05:00:37 pm Ingo Molnar wrote:
> Sigh, and now you apply this incomplete and unclean patch. The thing
> is, unpatched upstream kernel/module.c is quite a readability mess
> right now, even on the most trivial level and beyond comments:

Hi Ingo!

    First, thanks for reading this code.  Always useful to annoy you into 
reading my stuff :)

TBH most of those things don't worry me enough to reject patches.  If there 
were other problems, I might ask someone to fix those up too, but I try not to 
post feedback like the one you gave.

>  - Code flow confusion: inconsistent checks for allocation errors
>    within the same function.

Which one were you thinking?

>  - Huge functions that should be broken up. load_module() is 470
>    lines long (!).

It is, but unfortunately there's not a clear point to break it.  Pulling 
unrelated ops into a separate function just to reduce function size is worse 
than the disease (see init/main.c's do_basic_setup() for an example, though 
that file is not as bad as I remember).

>         if (ret) {
>                 /* Update module bounds. */
>                 if ((unsigned long)ret < module_addr_min)
>                         module_addr_min = (unsigned long)ret;
>                 if ((unsigned long)ret + size > module_addr_max)
>                         module_addr_max = (unsigned long)ret + size;
>         }
>         return ret;
>   }
>
>   Can you read that function at a glance? I sure cannot.

Yep, for me this is ugly but clear.

I prefer accessible addresses to be held in void *; the module code is a bit 
borderline, but originally void * was less casts than unsigned long (that may 
well have changed in the last few years tho).

> And i'm sure there's more - this is what 2 minutes of looking
> showed. If we cannot even get the trivial stuff right how can we get
> the more complex stuff right?
>
> _Please_ work on making it more readabe before piling more features
> on it ...

I'm not happy with the module.c code, but not for these reasons.  It just does 
lots of little, bitsy things to load and set up a module, many of which are 
arch-specific hooks, and/or config conditional.

eg. I'd like to split load_module() where it says "Module has moved": this 
would be clean, because before that point "mod" is pointing to the temporary 
version.  But trying it quickly reveals it to be worse than the current code.

Small cleanups are possible, but they're not the ones which would make this 
code really straightforward.

Cheers,
Rusty.
