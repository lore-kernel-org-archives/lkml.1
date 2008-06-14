Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbYFNARk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbYFNARk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbYFNANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:20 -0400
Received: from mail.suse.de ([195.135.220.2]:34292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbYFNANS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:18 -0400
Date: Fri, 13 Jun 2008 17:10:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 16/47] bluetooth: fix locking bug in the rfcomm socket
	cleanup handling
Message-ID: <20080614001058.GP24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arjan van de Ven <arjan@linux.intel.com>

[ Upstream commit: 7dccf1f4e1696c79bff064c3770867cc53cbc71c ]

in net/bluetooth/rfcomm/sock.c, rfcomm_sk_state_change() does the
following operation:

        if (parent && sock_flag(sk, SOCK_ZAPPED)) {
                /* We have to drop DLC lock here, otherwise
                 * rfcomm_sock_destruct() will dead lock. */
                rfcomm_dlc_unlock(d);
                rfcomm_sock_kill(sk);
                rfcomm_dlc_lock(d);
        }
}

which is fine, since rfcomm_sock_kill() will call sk_free() which will call
rfcomm_sock_destruct() which takes the rfcomm_dlc_lock()... so far so good.

HOWEVER, this assumes that the rfcomm_sk_state_change() function always gets
called with the rfcomm_dlc_lock() taken. This is the case for all but one
case, and in that case where we don't have the lock, we do a double unlock
followed by an attempt to take the lock, which due to underflow isn't
going anywhere fast.

This patch fixes this by moving the stragling case inside the lock, like
the other usages of the same call are doing in this code.

This was found with the help of the www.kerneloops.org project, where this
deadlock was observed 51 times at this point in time:
http://www.kerneloops.org/search.php?search=rfcomm_sock_destruct

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/bluetooth/rfcomm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -423,8 +423,8 @@ static int __rfcomm_dlc_close(struct rfc
 
 		rfcomm_dlc_lock(d);
 		d->state = BT_CLOSED;
-		rfcomm_dlc_unlock(d);
 		d->state_change(d, err);
+		rfcomm_dlc_unlock(d);
 
 		skb_queue_purge(&d->tx_queue);
 		rfcomm_dlc_unlink(d);

-- 
