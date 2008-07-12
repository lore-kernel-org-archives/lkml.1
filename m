Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYGLAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYGLAvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbYGLAvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:51:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbYGLAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:44 -0400
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <1215817836.10052.2.camel@johannes.berg>
References: <20080708093800.274504ba@infradead.org>
	 <20080708095307.6423cb6f@infradead.org>
	 <20080711122011.7ddf42ef.akpm@linux-foundation.org>
	 <20080711135409.6638498d@infradead.org>
	 <20080711151110.ab2b5401.akpm@linux-foundation.org>
	 <1215817836.10052.2.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 02:51:22 +0200
Message-Id: <1215823882.10052.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> #define WARN_ON(test, fmt...)           	\
>   do {                                  	\
>       if (test) {                       	\
>           warn_on_slowpath(cnt(fmt) , ## fmt);	\
>           printf("WARN\n");             	\
>       }                                 	\
>   } while (0)

That doesn't play well with the bugtrap stuff, obviously. This one is a
bit better, but still has more overhead than the bugtrap stuff, but
avoids the overhead in the no-argument case.


#include <stdarg.h>
#include <stdio.h>

#define unlikely(x) (x)

#define hasargs(...) _hasargs( , ## __VA_ARGS__)
#define _hasargs(...) __hasargs(__VA_ARGS__,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)
#define __hasargs(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,n,ys...) n

static void warn_slowpath(int count, ...)
{
	va_list args;
	char *fmt;

	printf("WARNING: <<\n");

	if (count) {
		va_start(args, count);
		fmt = va_arg(args, char *);
		vprintf(fmt, args);
		va_end(args);
	}
	printf(">>\n");
}

/*
 * This is the original arch WARN_ON that just emits
 * a trap instruction and a bugtrap section entry for
 * example on powerpc.
 *
 * Obviously this isn't, but it could be.
 */
#define BUGTRAP_WARN_ON(test) ({			\
	if (unlikely(test))				\
		printf("WARNING: %s\n", #test);		\
	unlikely(test);					\
})

/*
 * This is a WARN_ON for some other architectures that don't
 * use the bugtrap section, it calls the slowpath function
 * which leads to more code size. But when you've added
 * parameters to your WARN_ON those need to be calculated
 * as well so you've already increased code size.
 */
#define OUT_OF_LINE_WARN_ON(test, fmt...) ({		\
	if (unlikely(test))				\
		warn_slowpath(hasargs(fmt) , ## fmt);	\
	unlikely(test);					\
})

/*
 * This new version determines whether to do a bugtrap
 * entry or not depending on whether there were any extra
 * arguments given.
 */
#define CONFIG_BUG_EXTRA_VERBOSE
#ifdef CONFIG_BUG_EXTRA_VERBOSE
#define WARN_ON(test, fmt...) ({			\
	if (!hasargs(fmt))				\
		BUGTRAP_WARN_ON(test);			\
	else						\
		OUT_OF_LINE_WARN_ON(test , ## fmt);	\
})
#else
#define WARN_ON(test, fmt...) BUGTRAP_WARN_ON(test)
#endif

int main(void)
{
	WARN_ON(1);
	WARN_ON(2, "asdf %d %d\n", 7, 8);
	WARN_ON(3, "asdf\n");

	return 0;
}


