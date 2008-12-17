Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755294AbYLQQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYLQQE3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLQQET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:04:19 -0500
Received: from science.horizon.com ([192.35.100.1]:18510 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750996AbYLQQES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:04:18 -0500
Message-ID: <20081217160417.18507.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Wed, 17 Dec 2008 11:04:17 -0500
To: peterz@infradead.org, andi@firstfloor.org
Cc: tj@kernel.org, srostedt@redhat.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>
 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
In-Reply-To: <1229526942.9487.75.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:
> ftrace has a globbing thing in there somewhere as well and that does
> indeed take user input.

Yes, but (I just looked at the code), its patterns take the form:
- Optional leading *
- Literal text
- Optional trailing *

Thus, only one case (*literal*) requires any backtracking, and it's
just strstr().

> Using recursion in kernel code is indeed not recommended, what Andi said
> we have tiny stacks.

The stack frame is tiny, and it only recurses on a *, so if the number
of *s in the pattern is bounded, the stack usage is bounded.

For the intended application (compile-time constant device blacklists),
this is not a problem at all.  Indeed, nothing but a trailing * is even
needed; I only implemented the feature to be compatible with fnmatch().
(Which is part of the reason I'm reluctant to do anything heroic to
make it work.)

The problem is, what if some future thoughtless person feeds user data
into the pattern argument?

I could just take support for non-trailing * out entirely.  That would be
a different sort of documentation burden.

Or I could just add an explicit 2-level stack. If you overflow the stack,
matching always fails.  Unfortunately, the code will be larger.

Do people think that would be, on balance, better?  It would be plenty
good enough for the blacklist application.
