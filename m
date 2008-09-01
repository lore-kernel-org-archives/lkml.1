Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYIANyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYIANyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYIANyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:54:01 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:25050 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYIANyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:54:00 -0400
Message-Id: <48BC1065.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 01 Sep 2008 14:55:17 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const
	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
In-Reply-To: <48BBEE04.30903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 15:28 >>>
>--- a/include/linux/compiler.h
>+++ b/include/linux/compiler.h
>@@ -195,7 +195,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
> #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> 
> /* Force a compilation error if condition is true */
>-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>+#define BUILD_BUG_ON(condition)					  \
>+do {									  \
>+	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;\
>+} while(0)
> 
> /* Force a compilation error if condition is true, but also produce a
>    result (of value 0 and type size_t), so the expression can be used

I have to admit that I'm surprise this compiles: You replace an expression
with a statement, and hence you reduce the places where BUILD_BUG_ON()
can validly be used. Of course you could wrap the whole thing in ({}),
but I can't see why not to use a bit-field to achieve the intended effect.

Also, are you sure the compiler will eliminate the dead variable in all
cases?

Finally, using as common a variable as 'x' here seems dangerous, too:
What if somewhere x is #define-d to something more complex than a
simple identifier?

Jan

