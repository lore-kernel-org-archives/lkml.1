Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXJaPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXJaPZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXJaPYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803AbXJaPYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:21 -0400
Date: Wed, 31 Oct 2007 08:11:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/26] Fix zero length socket write() semantics.
Message-ID: <20071031151124.GI2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-zero-length-socket-write-semantics.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

changeset e79ad711a0108475c1b3a03815527e7237020b08 from mainline.

This fixes kernel bugzilla #5731

It should generate an empty packet for datagram protocols when the
socket is connected, for one.

The check is doubly-wrong because all that a write() can be is a
sendmsg() call with a NULL msg_control and a single entry iovec.  No
special semantics should be assigned to it, therefore the zero length
check should be removed entirely.

This matches the behavior of BSD and several other systems.

Alan Cox notes that SuSv3 says the behavior of a zero length write on
non-files is "unspecified", but that's kind of useless since BSD has
defined this behavior for a quarter century and BSD is essentially
what application folks code to.

Based upon a patch from Stephen Hemminger.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -778,9 +778,6 @@ static ssize_t sock_aio_write(struct kio
 	if (pos != 0)
 		return -ESPIPE;
 
-	if (iocb->ki_left == 0)	/* Match SYS5 behaviour */
-		return 0;
-
 	x = alloc_sock_iocb(iocb, &siocb);
 	if (!x)
 		return -ENOMEM;

-- 
