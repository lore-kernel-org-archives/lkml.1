Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565Ab0BZI2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:28:53 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:38448 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935533Ab0BZI2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:28:52 -0500
X-Greylist: delayed 3771 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 03:28:52 EST
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
Date: Fri, 26 Feb 2010 07:26:01 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hm7t29$hqu$1@taverner.cs.berkeley.edu>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1267169161 18270 128.32.153.193 (26 Feb 2010 07:26:01 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 26 Feb 2010 07:26:01 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa  wrote:
>[RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
>
>kmalloc() and friends are sometimes used in a way
>
>	struct foo *ptr = kmalloc(size + sizeof(struct foo), GFP_KERNEL);
>	if (!ptr)
>		return -ENOMEM;
>	ptr->size = size;
>	...
>	return 0;
>
>Everybody should check for ptr != NULL, and most callers are actually checking
>for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.
>
>If caller passed 0 as size argument by error (e.g. integer overflow bug),
>the caller will start writing against address starting from ZERO_SIZE_PTR
>because the caller assumes that "size + sizeof(struct foo)" bytes of memory is
>successfully allocated. (kstrdup() is an example, although it will be
>impossible to pass s where strlen(s) == (size_t) -1 .)

I don't see how your patch solves the problem.

Case 1: As you point out, if size = -sizeof(struct foo), then we'll have
an integer overflow and allocate a 0-byte object.  Later operations will
likely write past the bounds of the allocated object.

Case 2: It's also true that if size = -sizeof(struct foo) + 1, that
will also trigger an integer overflow and will allocate a 1-byte object.
Consequently later operations will likely write past the bounds of the
allocated object.

Changing the behavior of kmalloc(0, .) does nothing about the
second case.  Any code that is vulnerable to Case 1 is also vulnerable
to Case 2.  The consequence of the two cases is identical: in both
cases, there is an out-of-bounds write (which might pose, for
instance, a security risk, or might trigger a crash).

I don't see the point of trying to address Case 1 without doing
anything about Case 2.  Is there something that would make Case 1
significantly more likely to occur by chance than Case 2?

So what should the kernel do about the risk of this kind of integer
overflow bugs?  I can see three possible strategies:

Strategy 1: Be really careful.  Don't introduce any code that has
this kind of integer overflow bug.  (Downside: Nobody is perfect.
It's easy to introduce an integer overflow bug without realizing it.)

Strategy 2: Try to modify kmalloc() to detect these bugs.
However, it's not clear that there is any good robust strategy
here.  I certainly don't have a concrete proposal.
(For instance, one thing that I'm told MS Visual C does is to
make malloc() a macro that checks the processor overflow/carry
flag on its length argument at runtime -- this doesn't catch all
integer overflow bugs but might catch some of them.  But it's a
bit of a hack.)

Strategy 3: Build static or runtime analysis tools to detect
these kinds of bugs.  The problem is that static analysis tools
generally find it difficult to reason about integer overflow,
without either missing many bugs or introducing many false
positives.  Sophisticated runtime tools might be in a better
position to detect these bugs (for instance, I've done some
research on tools for detecting integer overflow bugs using
symbolic execution and smart fuzzing), but they are non-trivial
to build.
