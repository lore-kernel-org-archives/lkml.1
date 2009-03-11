Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZCKSoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZCKSoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCKSnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:43:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbZCKSnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:43:52 -0400
Date: Wed, 11 Mar 2009 11:42:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, tux3@tux3.org
Subject: Re: Tux3 report: Tux3 Git tree available
Message-Id: <20090311114211.89eed5b8.akpm@linux-foundation.org>
In-Reply-To: <200903110925.37614.phillips@phunq.net>
References: <200903110925.37614.phillips@phunq.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 09:25:37 -0700
Daniel Phillips <phillips@phunq.net> wrote:

> The full patch is 191KB.  We could try patchbombing lkml with that, one
> patch per file, say.

One patch per file is OK.

Two considerations:


- It should be reviewable!  People don't want to spend all their
  review time scratching their heads wondering "wtf is this piece of
  code supposed to do".

  Thoughtfully commented data structures and functions are valuable
  during the code-review stage.  If you try to retrofit them later then
  reviewers get justifiably grumpy about all the time they wasted
  ineffectually trying to review the uncommented stuff.

- Send the code for review when it's ready for linux-next
  integration.  I don't think it's a good idea to have it reviewed,
  then you all disappear and spend three months changing it and then
  put it up for linux-next integration.

  OTOH, there may well be large changes as a result of review, so
  don't leave it too late and avoid the temptation to think of it as
  "finished", because it won't be!


Drive-by review:

- please prefer to leave a blank line between end-of-locals and
  start-of-code in each fucntion.

- C++ comments make checkpatch (and kernel developers) whine.

- The non-tux3-specific bitmap-handling functions in balloc.c
  shouldn't exist, I suspect.  Use core kernel helpers.  If they don't
  exist, add them.

- bytebits() should use hweight8()

- No new typedefs, please.  That means block_t.  If there is some
  real need to make block_t a typedef (such as: its size varies
  according to Kconfig options) then grumble, OK.  But it should then
  be called tux3_block_t.

- count_range() is an unsuitable identifier for a kernel-wide symbol.
  Please review all global symbols in the fs, ensure that they are
  prefixed with "tux3_".  Or make them static, of course.

- It uses printf() and assert()?  Kernel code uses printk() and
  BUG_ON().  Confused.

- There's a lot of this:

	int ended = 0, any = 0;
	struct buffer_head *buffer = blockread(mapping(inode), block);
	if (!buffer)
		return -1;
	unsigned bytes = blocksize - offset;
	if (bytes > tail)
		bytes = tail;
	unsigned char *p = bufdata(buffer) + offset, *top = p + bytes;

  Which will spew compilation warnings due to local variable
  definitions coming after code.

  Maybe this code is never to be compiled into the kernel image, but
  we might as well be consistent.

- What's "L"?

		printf("%Lx-", (L)begin);

- When 'bh' is known to be non-NULL, use put_bh() rather than brelse().

- Use __packed, not PACKED.

- Run `checkpatch --file', enjoy the result.

- get_buffer() looks like it's racy against truncate.  Needs to lock
  the page.

- eh?

	typedef u64 fixed32; /* Tux3 time values */

- link_entry() looks dangerous.

- Move SB_MAGIC to magic.h, change name.

- remove private hexdump(), use lib/hexdump.c


Generally: the code is _very_ namespace-piggy.  Lots and lots of very
generic-sounding identifiers.

