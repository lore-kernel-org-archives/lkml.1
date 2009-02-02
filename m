Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZBBSUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZBBSUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBBSUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:20:14 -0500
Received: from vena.lwn.net ([206.168.112.25]:53452 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZBBSUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:20:12 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       linux-api@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC] F_SETFL/Fasync BKL removal, now without unsightly global locks
Date: Mon,  2 Feb 2009 11:20:07 -0700
Message-Id: <1233598811-6871-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is yet another attempt to remove the BKL from the handling of changes
to filp->f_flags and FASYNC changes.  This approach is a bit more complex,
and has been split into four patches.  The end-result is the removal of the
BKL and some excess code.

1) Use bitops for f_flags: turn f_flags into an unsigned long and
   manipulate its contents with atomic bitops.  New NR_* macros have been
   defined for the bits which are actually changed after open/create time.

2) Use a bitlock in epoll: use one of the f_flags bit to replace the
   ep_lock spinlock.  This (more than) mitigates the growth in struct file
   created by part 1).  The bitop will be a bit slower, but it should not
   be a performance-critical part of the epoll implementation.  (Ideal
   courtesy of Matt Mackall).

3) Move FASYNC bit handling into ->fasync(): this is how changes to that
   bit and calls to f_op->fasync() are kept atomic in the absence of the
   BKL.  Almost every FASYNC implementation uses fasync_helper(), so the
   actual bit manipulation is done there.  The one exception (for sockets)
   has been fixed up.  At this point, there is no more BKL in these paths.
   (Idea-suggested-by: Andi Kleen).

4) Rationalize fasync_helper() return value handling.  Some drivers mapped
   positive return values from fasync_helper() onto zero, most others did
   not bother.  This optional cleanup patch moves that mapping into the VFS
   code, making things consistent and enabling the removal of some 50 lines
   of code.  It's worth noting that this is technically an ABI change: some
   drivers which returned positive values from fcntl(..., F_SETFL, ...)
   will now return zero instead.  I sure *hope* that wouldn't break
   anything... 

To be extra-sure that I wasn't breaking anything subtle, I went and figured
out how to run the Linux Test Project suite.  Pretty amazing stuff - I've
never run a program which would put my system's load average at 7400
before.  If there are any regressions here, LTP did not find them.

As always, comments welcome.

jon


