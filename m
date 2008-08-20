Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYHTMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYHTMcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYHTMcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:32:03 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33175 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYHTMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=WM9XwrZ4lfa11x7KAOAsveEGRVeRNpVqDFdCc4Bp2y3k98Jvt24hChJyIhylAco5Te
         RGr62z7ZZRvCzMqwUzZNvb1M3JOozsaedu7gNYmUvbgN468z725t2gPAoVB65yHoaoPS
         w1EK/kzPO76fGxBvtM3R2zQbiWMXBRCGN6OVo=
Message-ID: <48AC0EB9.3080708@panasas.com>
Date: Wed, 20 Aug 2008 15:31:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com> <20080820105922.GC18524@elte.hu>
In-Reply-To: <20080820105922.GC18524@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> If the user of virtio_has_feature() must pass a compile-time constant 
>> then it must be converted to a MACRO, and then the BUILD_BUG_ON will 
>> work. Or it should be changed to a BUG_ON() if fbit is a runtime 
>> variable.
> 

The use of __builtin_constant_p in inline functions is broken. This
is because it will give different results depending on the -O level
used. So I think that using it in the Kernel with inlines is plain
broken. And should be discouraged.

That said, my trick with enum is exactly the same as __builtin_constant_p
when -O is off, that is, does not traverse inline. But it is consistent
across any optimization.

> well, that's the question i'm asking: that sort of proposed 
> BUILD_BUG_ON() variantcannot be used in inline functions like 
> virtio_has_feature() does. If we get forced back to macros that's not an 
> improvement.
> 

I think it is an improvement, in a sense that now we think something is happening
but get silently ignored if compilation conditions are different, and/or the programmer
had a mistake. The new way will show us what code will be produced in the worse 
case and will error if wrong.
  
> Maybe the link-time last-line-of-defense mechanism i posed is the most 
> flexible one perhaps after all? (it's ugly too but none of this is 
> particularly pretty)
> 

The link-time gives the same results. Only warns at link time instead of
compile time. The difference between our approaches is the use of
__builtin_constant_p which is suppose to work cross inline stack boundary,
but in effect it does not if the optimization is not just right.

> hm?
> 
> 	Ingo

Here is gcc documentation about __builtin_constant_p:

— Built-in Function: int __builtin_constant_p (exp)

    You can use the built-in function __builtin_constant_p to determine if a value is known to be constant at compile-time and hence that GCC can perform constant-folding on expressions involving that value. The argument of the function is the value to test. The function returns the integer 1 if the argument is known to be a compile-time constant and 0 if it is not known to be a compile-time constant. A return of 0 does not indicate that the value is not a constant, but merely that GCC cannot prove it is a constant with the specified value of the -O option.

    You would typically use this function in an embedded application where memory was a critical resource. If you have some complex calculation, you may want it to be folded if it involves constants, but need to call a function if it does not. For example:

              #define Scale_Value(X)      \
                (__builtin_constant_p (X) \
                ? ((X) * SCALE + OFFSET) : Scale (X))
         

    You may use this built-in function in either a macro or an inline function. However, if you use it in an inlined function and pass an argument of the function as the argument to the built-in, GCC will never return 1 when you call the inline function with a string constant or compound literal (see Compound Literals) and will not return 1 when you pass a constant numeric value to the inline function unless you specify the -O option.

    You may also use __builtin_constant_p in initializers for static data. For instance, you can write

              static const int table[] = {
                 __builtin_constant_p (EXPRESSION) ? (EXPRESSION) : -1,
                 /* ... */
              };
         

    This is an acceptable initializer even if EXPRESSION is not a constant expression. GCC must be more conservative about evaluating the built-in in this case, because it has no opportunity to perform optimization.

    Previous versions of GCC did not accept this built-in in data initializers. The earliest version where it is completely safe is 3.0.1. 


I have tried the test below:
#include <stdio.h>

#define __maybe_unused			__attribute__((unused))

#define BUILD_BUG_ON_ORIG(condition) ((void)sizeof(char[1 - 2*!!(condition)]))

#define BUILD_BUG_ON_B(condition)				\
do { 								\
	enum { bad = !!(condition)}; 				\
	static struct { char arr[1 - 2*bad]; } x __maybe_unused;\
} while(0)

#define BUILD_BUG_ON_R(condition)						\
do {									\
	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;	\
} while(0)

extern unsigned int __BUILD_BUG_ON_non_constant;
#define BUILD_BUG_ON_I(condition)				\
do {								\
	(void)sizeof(char[1 - 2*!!(condition)]);		\
	if (!__builtin_constant_p(condition))			\
		__BUILD_BUG_ON_non_constant++;			\
} while (0)

#define BUILD_BUG_ON BUILD_BUG_ON_R

int main()
{
	int var;

	var = random();

	BUILD_BUG_ON(2 < 1);
	BUILD_BUG_ON(1 < 2);
	BUILD_BUG_ON(var < 2);

	printf("var=%d", var);
	return 0;
}

where I changed #define BUILD_BUG_ON BUILD_BUG_ON_X to the three
variants (ORIG/B/R/I) here is what I get (optimization is off).

_ORIG:
2 < 1:   good (is silent)
1 < 2:   good (error report)
var < 2: bad (just ignored)

_B && _R:
2 < 1:   good (is silent)
1 < 2:   good (error report)
var < 2: good (error report)

_I: (optimization is off)
2 < 1:   bad (link time error)
1 < 2:   good (error report)
var < 2: good- (link time error)

So I think the BUILD_BUG_ON_R should be accepted. This will force
two changes in current Kernel (i386 allmodconfig), which in my
opinion are case 3 above and should be fixed anyway.

Please propose other tests we should try, for example with cross
inline-functions/macros.

Boaz
