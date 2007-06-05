Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbXFEOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbXFEOn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764204AbXFEOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:43:51 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:46691 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbXFEOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:43:50 -0400
Subject: Problems (a bug?) with UINT_MAX from kernel.h
From: Richard Purdie <richard@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 15:42:42 +0100
Message-Id: <1181054562.6180.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses UINT_MAX defined from kernel.h in a variety of places.

While looking at the behaviour of the LZO code, I noticed it seemed to
think an int was 8 bytes large on my 32 bit i386 machine. It isn't but
why did it think that?

kernel.h says:

#define INT_MAX		((int)(~0U>>1))
#define INT_MIN		(-INT_MAX - 1)
#define UINT_MAX	(~0U)
#define LONG_MAX	((long)(~0UL>>1))
#define LONG_MIN	(-LONG_MAX - 1)
#define ULONG_MAX	(~0UL)
#define LLONG_MAX	((long long)(~0ULL>>1))
#define LLONG_MIN	(-LLONG_MAX - 1)
#define ULLONG_MAX	(~0ULL)

If I try to compile the code fragment below, I see the error:

#define UINT_MAX	(~0U)
#if (0xffffffffffffffff == UINT_MAX)
  #error argh
#endif

I've tested this on several systems with a variety of gcc versions with
the same result. I've tried various other ways of testing this all with
the same conclusion, UINT_MAX is wrong.

The *LONG* definitions above should work as gcc is forced to a certain
type. Where just 0U is specified, I don't think it will work as intended
as gcc seems to automatically increase the type to fit the value and
avoid truncation ending up with a long long.

If I change the above to:

/* Handle GCC = 3.2 */
#if !defined(__INT_MAX__)
#define INT_MAX		0x7fffffff
#else
#define INT_MAX		(__INT_MAX__)
#endif
#define INT_MIN		(-INT_MAX - 1)
#define UINT_MAX	((INT_MAX<<1)+1)

I get the expected result of an int being 4 bytes long. Is there a
better solution? Its probably better that whats there now but could
break a machine using gcc 3.2 that doesn't have int size = 4 bytes...

(gcc <= 3.2 doesn't define __INT_MAX__)

Richard


