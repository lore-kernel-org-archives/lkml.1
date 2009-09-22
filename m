Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZIVD2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZIVD2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 23:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZIVD17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 23:27:59 -0400
Received: from science.horizon.com ([71.41.210.146]:61778 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752493AbZIVD17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 23:27:59 -0400
Date: 21 Sep 2009 23:28:02 -0400
Message-ID: <20090922032802.1827.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arjan@infradead.org
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> or make it one level simpler?
> Have a "wait for all started copies" call only.... saves a ton of book
> keeping, and is likely what people will use it for in the end anyway.

Aieeee!  No, no, a thousand times, no!

We do NOT need another blocking primitive that can't play well with others.
That would be a HORRIBLE design mistake.

The whole benefit of Linus' scheme is that it returns a file descriptor.
Any waiting should be done by the standard event-wait system call, poll().
It should return POLLIN when there's an interesting event (such as copy
completion), and should remain valid until explicitly close()d.

There's nothing wrong with a convenience function that waits for all
started copies, but I don't see a reason to design a new kernel interface
for the purpose.

A few more points:
- If the file descriptor returned by copyfile() is guaranteed not to be 0
  (even if that is available), perhaps it should be guaranteed to be >= 3.
- We might as well make the returned file descriptor O_CLOEXEC by default.
  You can always change it back if you want to.
