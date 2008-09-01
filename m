Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYIAGzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYIAGzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYIAGzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:55:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6089 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYIAGzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:55:31 -0400
Message-Id: <48BBAE50.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 01 Sep 2008 07:56:48 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BUILD_BUG_ON() should not use array type
References: <48B7FDBA.76E4.0078.0@novell.com>
 <20080829132211.d0ed1932.akpm@linux-foundation.org>
In-Reply-To: <20080829132211.d0ed1932.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.27-rc5/include/linux/kernel.h	2008-08-21 14:37:35.000000000 +0200
>> +++ 2.6.27-rc5-build-bug-on/include/linux/kernel.h	2008-08-28 15:10:28.000000000 +0200
>> @@ -468,13 +468,17 @@ struct sysinfo {
>>  };
>>  
>>  /* Force a compilation error if condition is true */
>> -#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>> +#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
>> +
>> +/* Force a compilation error if condition is constant and true */
>> +#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
>
>MAYBE_BUILD_BUG_ON() hurts my brain.  It's doing:
>
>	if (__builtin_constant_p(expr))
>		BUILD_BUG_ON(expr);
>
>yes?  For inlined (or macro) callsites which can be used with constant
>or non-constant args.

Yes, its attempting to have the effect of that if() construct.

>It's tempting to just zap the one callsite and not add this at all, but
>I suppose that it's a legitimate thing to want to do, and that other
>users of it may well turn up.  Many of them are probably just using run-time
>BUG_ON(), which is sensible, but less efficient.
>
>However it would benefit from a clearer description and perhaps a
>better name.  BUILD_BUG_ON_IF_CONSTANT?

Admittedly I didn't like the name much either, but so I also didn't like
any other name I could think of. And really, I'd also favor removing
the one use site altogether (hence the comment about the construct
there not having any effect), but thought it'd be a step backward
documentation-wise.

So for re-submitting an adjusted patch I'd need to be clear about the
way to go...

>>  /* Force a compilation error if condition is true, but also produce a
>>     result (of value 0 and type size_t), so the expression can be used
>>     e.g. in a structure initializer (or where-ever else comma expressions
>>     aren't permitted). */
>> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>> +#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>> +#define BUILD_BUG_ON_NULL(e) ((void *)BUILD_BUG_ON_ZERO(e))
>
>What does BUILD_BUG_ON_NULL() do and why did you add it?  It has no
>callers.

I was under the (apparently wrong) impression that while plain 0 can be
used to initialize a pointer, an expression evaluating to zero would need
a cast. While that's not the case as I just checked, I'd still prefer keeping
the construct both for documentation purposes and because in the error
case without the case you'd not only get the intended error message,
but also an extra (and perhaps confusing) warning.

Jan

