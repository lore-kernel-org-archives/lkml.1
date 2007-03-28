Return-Path: <linux-kernel-owner+w=401wt.eu-S934348AbXC1BsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbXC1BsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbXC1BsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:48:19 -0400
Received: from science.horizon.com ([192.35.100.1]:18874 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934346AbXC1BsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:48:18 -0400
Date: 27 Mar 2007 21:48:16 -0400
Message-ID: <20070328014816.4159.qmail@science.horizon.com>
From: linux@horizon.com
To: linux@horizon.com, miklos@szeredi.hu
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <E1HWIKP-0004oj-00@dorka.pomaz.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Linux _will_ write all modified data to permanent storage locations.
> Since 2.6.17 it will do this regardless of msync().  Before 2.6.17 you
> do need msync() to enable data to be written back.
> 
> But it will not start I/O immediately, which is not a requirement in
> the standard, or at least it's pretty vague about that.

As I've said before, I disagree, but I'm not going to start a major
flame war about it.

The most relevant paragraph is:

# When MS_ASYNC is specified, msync() returns immediately once all the
# write operations are initiated or queued for servicing; when MS_SYNC is
# specified, msync() will not return until all write operations are
# completed as defined for synchronised I/O data integrity completion.
# Either MS_ASYNC or MS_SYNC is specified, but not both.

Note two things:
1) In the paragraphs before, what msync does is defined independently
   of the MS_* flags.  Only the time of the return to user space varies.
   Thus, whatever the delay between calling msync() and the data being
   written, it should be the same whether MS_SYNC or MS_ASYNC is used.

   The implementation intended is:
   - Start all I/O
   - If MS_SYNC, wait for I/O to complete
   - Return to user space

2) "all the write operations are initiated or queued for servicing".
   It is a common convention in English (and most languages, I expect)
   that in the "or" is a preference for the first alternative.  The second
   is a permitted alternative if the first is not possible.

   And "queued for servicing", especially "initiated or queued for
   servicing", to me imples queuing waiting for some resource.  To have
   the resource being waited for be a timer expiry seems like rather a
   cheat to me.  It's perhaps doesn't break the letter of the standard,
   but definitely bends it.  It feels like a fiddle.

Still, the basic hint function of msync(MS_ASYNC) *is* being accomplished:
"I don't expect to write this page any more, so now would be a good time
to clean it."
It would just make my life easier if the kernel procrastinated less.
