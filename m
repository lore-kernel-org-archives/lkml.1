Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXJ1ErZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXJ1ErZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 00:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXJ1ErR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 00:47:17 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2970 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXJ1ErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 00:47:16 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: epoll design problems with common fork/exec patterns
Date: Sat, 27 Oct 2007 21:47:12 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEEDHNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0710270950170.12127@alien.or.mcafeemobile.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 27 Oct 2007 21:48:09 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 27 Oct 2007 21:48:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 6) Epoll removes the file from the set, when the *kernel* object gets
>    closed (internal use-count goes to zero)
>
> With that in mind, how can the code snippet above trigger a removal from
> the epoll set?

	I don't see how that can be. Suppose I add fd 8 to an epoll set. Suppose fd
5 is a dup of fd 8. Now, I close fd 8. How can fd 8 remain in my epoll set,
since there no longer is an fd 8? Events on files registered for epoll
notification are reported by descriptor, so the set membership has to be
associated (as reflected into userspace) with the descriptor, not the file.

	For example, consider:

	1) Process creates an epoll set, the set gets fd 4.

	2) Process creates a socket, it gets fd 5.

	3) The process adds fd 5 to set 4.

	4) The process forks.

	5) The child inherits the epoll set but not the socket.

	Here the kernel cannot quite do the right thing. Ideally, the parent would
still have fd 5 in its version of the epoll set. After all, it has not
closed fd 5. However, the child *cannot* see fd 5 in its version of the
epoll set since it has no fd 5. An event reported for fd 5 would be
nonsense.

	So it seems the kernel either has to break one of these "would/cannot"
requirements, or it has to split the epoll set in two. However, splitting
the set into two sets is clearly wrong since the processes should share it.

              Q6     Will  the  close of an fd cause it to be removed from
all
                     epoll sets automatically?

              A6     Yes.

	Note that this talks of the close of an "fd", not a file. The 'close'
function in fact closes an fd, as that fd is then reusable. So it sounds
like the problem above is solved by removing the fd from the set, but in
practice this doesn't happen. I have programs that call 'close' between
'fork' and 'exec' and do not see the socket removed from the poll set.

	DS


