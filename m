Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZBGUHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZBGUHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBGUG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:06:59 -0500
Received: from vena.lwn.net ([206.168.112.25]:51296 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZBGUG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:06:59 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH/RFC] Fasync BKL removal
Date: Sat,  7 Feb 2009 13:06:53 -0700
Message-Id: <1234037217-16124-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With any luck at all, this is my final attempt at removing the BKL from the
fasync() path and providing proper protection for struct file->f_flags.
This week's episode includes these patches:

1) Rename f_ep_lock to f_lock and move it out of CONFIG_EPOLL.  Epoll
   remains the only user, but the lock is now available for others.

2) Use f_lock to protect f_flags.  This provides better protection to the
   flags than we've had before and allows the removal of the BKL in places
   where its only purpose was protecting accesses to this field.

3) Move FASYNC bit handling into ->fasync(): this is how changes to that
   bit and calls to f_op->fasync() are kept atomic in the absence of the
   BKL.  Almost every FASYNC implementation uses fasync_helper(), so the
   actual bit manipulation is done there.  The one exception (for sockets)
   has been fixed up.  At this point, there is no more BKL in these paths.

4) Rationalize fasync_helper() return value handling.  Some drivers mapped
   positive return values from fasync_helper() onto zero, most others did
   not bother.  This optional cleanup patch moves that mapping into the VFS
   code, making things consistent and enabling the removal of some 50 lines
   of code.

Parts 3 and 4 are essentially the same as the last time around.

Once again, this code works for me and, if there's any regressions here,
the LTP test suite cannot find them.

Thanks to all who have looked at this interminable stream of patches...

jon


