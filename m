Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752084AbYLRIAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYLRIAj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYLRIA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:00:29 -0500
Received: from science.horizon.com ([192.35.100.1]:11998 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751125AbYLRIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:00:29 -0500
Message-ID: <20081218080027.27011.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Thu, 18 Dec 2008 03:00:27 -0500
To: srostedt@redhat.com, peterz@infradead.org
Cc: tj@kernel.org, linux@horizon.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>
 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
 <1229528856.30177.4.camel@localhost.localdomain>
In-Reply-To: <1229528856.30177.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <srostedt@redhat.com> wrote:
> I need to look at your code (I would like a generalized glob feature for
> user input). Can you accomplish the same with using a loop instead of
> recursion?

Unfortunately, no.  Matching multiple * characters inherently requires
backtracking, and backtracking requires a stack.

I could make it a finite-depth explicit stack rather than using
the C stack implicitly, but it doesn't save much on reasonable
patterns.

But if you want it for user input, I can work at making it more
robust.  What are your sped needs?
0 - Runs once only, speed unimportant
1 - Runs several thousand times (counting all NxM matches), would like
    it to not be too slow.
2 - Run a thousand times per second, but it's a debug feature so
    a speed hit is acceptable.
3 - Common code path, maybe rearchitect to save time.
4 - Kernel fast path, every cycle counts!

There are quite a few things (with commensurate code size increases)
that can't help the big-O worst-case performance, but improve the average
case considerably.

One thing I don't do that's quite possible is to find the fixed-length
head and tail of the pattern (the parts before the first * and after the
last) and match those before dealing with the annoying middle.

That would avoid all backtracking in cases with a single *, and make a
good pre-filter before doing anything expensive in the middle.

H'm... I think there's an equivalent and more general version based on
the number of characters a pattern matches.  Any pattern's length is
N characters, plus a flag indicating if that's fixed or just a minimum.

When matching a *, compute the length of the following pattern and only
try matching cases which have the right length.

If we need to do a lot of matching against a single pattern, it's possible
to preprocess it to find the fixed-length spans and their lengths.
(The current blacklist application is exactly the opposite: matching
one string against a list of patterns.)
